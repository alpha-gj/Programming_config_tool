set tags=tags;

" color vimrc module, need put color theem here first becasue other color setting will be set
source ~/vimrc_module/color_setting

" vim setting
source ~/vimrc_module/alias_vim_command
source ~/vimrc_module/vim_basic_setting
source ~/vimrc_module/vim_key_mapping

" hotkey vimrc module
source ~/vimrc_module/hotkey_CopyDefine_ImpleDefine
source ~/vimrc_module/hotkey_switch_header_file
source ~/vimrc_module/hotkey_basic

" function vimrc module
source ~/vimrc_module/function_create_header_file_pattern

" coding style
source ~/vimrc_module/coding_style_tab


"=================================================================
" Start vundle
"=================================================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"===============================================================
" Write your plugins here
"===============================================================
" indent對齊參考線
"Plugin 'Yggdroot/indentLine'
" 顯示行尾空白
Plugin 'ntpeters/vim-better-whitespace'
" 顯示狀態資訊 (包含git版本)
Plugin 'vim-airline/vim-airline'
" 在vim中使用git命令
Plugin 'tpope/vim-fugitive'
" 把cscope指令對應到hotkey
Plugin 'chazy/cscope_maps'
" 列出檔案中所有symbols，並可以跳至symbol處
Plugin 'vim-scripts/taglist.vim'
" 顯示目錄結構
Plugin 'scrooloose/nerdtree'
" 切割視窗列出function定義
Plugin 'wesleyche/SrcExpl'
" 控管SrcExpl, taglist, nerdtree視窗
Plugin 'wesleyche/Trinity'
" taglist加強
Plugin 'majutsushi/tagbar'


"================================================================
" Run vundle
"================================================================
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"====================================================================
" airline Settings 目前未安裝此plugin
"===================================================================
" 指定安裝的字型 (airline會需要一些特殊符號字型)
set guifont=Inconsolata\ for\ Powerline\ 20
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

nmap <tab> :bn<CR>
nmap <S-tab> :bp<CR>
nmap <F3> :bd<CR><S-tab>

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
echohl ErrorMsg
echomsg a:msg
echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
if empty(a:buffer)
let btarget = bufnr('%')
elseif a:buffer =~ '^\d\+$'
let btarget = bufnr(str2nr(a:buffer))
else
let btarget = bufnr(a:buffer)
endif
if btarget < 0
call s:Warn('No matching buffer for '.a:buffer)
return
endif
if empty(a:bang) && getbufvar(btarget, '&modified')
call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
return
endif
" Numbers of windows that view target buffer which we will delete.
let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
if !g:bclose_multiple && len(wnums) > 1
call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
return
endif
let wcurrent = winnr()
for w in wnums
execute w.'wincmd w'
let prevbuf = bufnr('#')
if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
buffer #
else
bprevious
endif
if btarget == bufnr('%')
" Numbers of listed buffers which are not the target to be deleted.
let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
" Listed, not target, and not displayed.
let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
" Take the first buffer, if any (could be more intelligent).
let bjump = (bhidden + blisted + [-1])[0]
if bjump > 0
execute 'buffer '.bjump
else
execute 'enew'.a:bang
endif
endif
endfor
execute 'bdelete'.a:bang.' '.btarget
execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>
nnoremap <silent> <Leader>bD :Bclose!<CR>

"====================================================================
" Trinity Settings
"====================================================================
"Open/close the Tagbar separately
nmap <F7> :TagbarToggle<CR>
"Open/close the Source Explorer separately
"nmap <F8>  :TrinityToggleSourceExplorer<CR>
"Open/close the Taglist separately
"nmap <F9> :TrinityToggleTagList<CR>
"Open/close the NERDTree separately
nmap <F10> :TrinityToggleNERDTree<CR>
"Open/close SrcExpl, Taglist, Nerdtree
"nmap <F11>  :TrinityToggleAll<CR>
