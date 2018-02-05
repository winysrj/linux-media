Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58016 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752738AbeBEQzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 11:55:09 -0500
Date: Mon, 5 Feb 2018 14:55:01 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
Message-ID: <20180205145457.6c083894@vento.lan>
In-Reply-To: <20180205143729.12783826@vento.lan>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
        <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
        <20180205143729.12783826@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Feb 2018 14:37:29 -0200
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Em Mon, 5 Feb 2018 08:21:54 -0800
> Tim Harvey <tharvey@gateworks.com> escreveu:
> 
> > Hans,
> > 
> > I'm failing compile (of master 4ee9911) with:
> > 
> >   CXX      v4l2_compliance-media-info.o
> > media-info.cpp: In function ‘media_type media_detect_type(const char*)’:
> > media-info.cpp:79:39: error: no matching function for call to
> > ‘std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)’
> >   std::ifstream uevent_file(uevent_path);
> >                                        ^  
> 
> Btw, while on it, a few days ago, I noticed several class warnings when
> building v4l-utils on Raspbian, saying that it was using some features
> that future versions of gcc would stop using at qv4l2. See enclosed.
> 
> I didn't have time to look on them.

FYI, it still happens with today's upstream's version:

	4ee99116d0ec (HEAD, origin/master, origin/HEAD) v4l2-ctl: improve the fps calculation when streaming

$ gcc --version
gcc (Raspbian 6.3.0-18+rpi1) 6.3.0 20170516
Copyright (C) 2016 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


> 
> Thanks,
> Mauro
> 
> In file included from /usr/include/c++/6/map:60:0,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype.h:57,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h:54,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidget.h:44,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainwindow.h:43,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainWindow:1,
>                  from qv4l2.h:25,
>                  from ctrl-tab.cpp:20:
> /usr/include/c++/6/bits/stl_tree.h: In member function ‘std::pair<std::_Rb_tree_node_base*, std::_Rb_tree_node_base*> std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::_M_get_insert_hint_unique_pos(std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, const key_type&) [with _Key = unsigned int; _Val = std::pair<const unsigned int, v4l2_query_ext_ctrl>; _KeyOfValue = std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >; _Compare = std::less<unsigned int>; _Alloc = std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >]’:
> /usr/include/c++/6/bits/stl_tree.h:1928:5: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>      _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /usr/include/c++/6/bits/stl_tree.h: In function ‘std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::iterator std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::_M_emplace_hint_unique(std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, _Args&& ...) [with _Args = {const std::piecewise_construct_t&, std::tuple<const unsigned int&>, std::tuple<>}; _Key = unsigned int; _Val = std::pair<const unsigned int, v4l2_query_ext_ctrl>; _KeyOfValue = std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >; _Compare = std::less<unsigned int>; _Alloc = std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >]’:
> /usr/include/c++/6/bits/stl_tree.h:2193:7: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>        _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from /usr/include/c++/6/map:61:0,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype.h:57,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h:54,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidget.h:44,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainwindow.h:43,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainWindow:1,
>                  from qv4l2.h:25,
>                  from ctrl-tab.cpp:20:
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setWhat(QWidget*, unsigned int, const QString&)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setWhat(QWidget*, unsigned int, long long int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> In file included from /usr/include/c++/6/map:60:0,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype.h:57,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h:54,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidget.h:44,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainwindow.h:43,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainWindow:1,
>                  from qv4l2.h:25,
>                  from ctrl-tab.cpp:20:
> /usr/include/c++/6/bits/stl_tree.h: In function ‘std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::iterator std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::_M_emplace_hint_unique(std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, _Args&& ...) [with _Args = {const std::piecewise_construct_t&, std::tuple<unsigned int&&>, std::tuple<>}; _Key = unsigned int; _Val = std::pair<const unsigned int, v4l2_query_ext_ctrl>; _KeyOfValue = std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >; _Compare = std::less<unsigned int>; _Alloc = std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >]’:
> /usr/include/c++/6/bits/stl_tree.h:2193:7: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>        _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from /usr/include/c++/6/map:61:0,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype.h:57,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h:54,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidget.h:44,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainwindow.h:43,
>                  from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainWindow:1,
>                  from qv4l2.h:25,
>                  from ctrl-tab.cpp:20:
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setVal64(unsigned int, long long int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘long long int ApplicationWindow::getVal64(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setString(unsigned int, const QString&)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘QString ApplicationWindow::getString(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘int ApplicationWindow::getVal(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setVal(unsigned int, int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::refresh(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::updateCtrl(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::setDefaults(unsigned int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::ctrlAction(int)’:
> /usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::updateCtrlRange(unsigned int, __s32)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h: In member function ‘void ApplicationWindow::addTabs(int)’:
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> /usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argument of type ‘std::_Rb_tree<unsigned int, std::pair<const unsigned int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}’ will change in GCC 7.1
>     __i = _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
>     ^~~
> 



Thanks,
Mauro
