Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41805 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbeBEQhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 11:37:37 -0500
Date: Mon, 5 Feb 2018 14:37:29 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
Message-ID: <20180205143729.12783826@vento.lan>
In-Reply-To: <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
        <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Feb 2018 08:21:54 -0800
Tim Harvey <tharvey@gateworks.com> escreveu:

> Hans,
>=20
> I'm failing compile (of master 4ee9911) with:
>=20
>   CXX      v4l2_compliance-media-info.o
> media-info.cpp: In function =E2=80=98media_type media_detect_type(const c=
har*)=E2=80=99:
> media-info.cpp:79:39: error: no matching function for call to
> =E2=80=98std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)=
=E2=80=99
>   std::ifstream uevent_file(uevent_path);
>                                        ^

Btw, while on it, a few days ago, I noticed several class warnings when
building v4l-utils on Raspbian, saying that it was using some features
that future versions of gcc would stop using at qv4l2. See enclosed.

I didn't have time to look on them.

Thanks,
Mauro

In file included from /usr/include/c++/6/map:60:0,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype=
.h:57,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h=
:54,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidge=
t.h:44,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainw=
indow.h:43,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainW=
indow:1,
                 from qv4l2.h:25,
                 from ctrl-tab.cpp:20:
/usr/include/c++/6/bits/stl_tree.h: In member function =E2=80=98std::pair<s=
td::_Rb_tree_node_base*, std::_Rb_tree_node_base*> std::_Rb_tree<_Key, _Val=
, _KeyOfValue, _Compare, _Alloc>::_M_get_insert_hint_unique_pos(std::_Rb_tr=
ee<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, const key_ty=
pe&) [with _Key =3D unsigned int; _Val =3D std::pair<const unsigned int, v4=
l2_query_ext_ctrl>; _KeyOfValue =3D std::_Select1st<std::pair<const unsigne=
d int, v4l2_query_ext_ctrl> >; _Compare =3D std::less<unsigned int>; _Alloc=
 =3D std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >]=
=E2=80=99:
/usr/include/c++/6/bits/stl_tree.h:1928:5: note: parameter passing for argu=
ment of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned =
int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4=
l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<con=
st unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tre=
e_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=
=80=99 will change in GCC 7.1
     _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/usr/include/c++/6/bits/stl_tree.h: In function =E2=80=98std::_Rb_tree<_Key=
, _Val, _KeyOfValue, _Compare, _Alloc>::iterator std::_Rb_tree<_Key, _Val, =
_KeyOfValue, _Compare, _Alloc>::_M_emplace_hint_unique(std::_Rb_tree<_Key, =
_Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, _Args&& ...) [with _A=
rgs =3D {const std::piecewise_construct_t&, std::tuple<const unsigned int&>=
, std::tuple<>}; _Key =3D unsigned int; _Val =3D std::pair<const unsigned i=
nt, v4l2_query_ext_ctrl>; _KeyOfValue =3D std::_Select1st<std::pair<const u=
nsigned int, v4l2_query_ext_ctrl> >; _Compare =3D std::less<unsigned int>; =
_Alloc =3D std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl=
> >]=E2=80=99:
/usr/include/c++/6/bits/stl_tree.h:2193:7: note: parameter passing for argu=
ment of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned =
int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4=
l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<con=
st unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tre=
e_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=
=80=99 will change in GCC 7.1
       _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/c++/6/map:61:0,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype=
.h:57,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h=
:54,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidge=
t.h:44,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainw=
indow.h:43,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainW=
indow:1,
                 from qv4l2.h:25,
                 from ctrl-tab.cpp:20:
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setWhat(QWidget*, unsigned int, const QString&)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setWhat(QWidget*, unsigned int, long long int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
In file included from /usr/include/c++/6/map:60:0,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype=
.h:57,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h=
:54,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidge=
t.h:44,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainw=
indow.h:43,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainW=
indow:1,
                 from qv4l2.h:25,
                 from ctrl-tab.cpp:20:
/usr/include/c++/6/bits/stl_tree.h: In function =E2=80=98std::_Rb_tree<_Key=
, _Val, _KeyOfValue, _Compare, _Alloc>::iterator std::_Rb_tree<_Key, _Val, =
_KeyOfValue, _Compare, _Alloc>::_M_emplace_hint_unique(std::_Rb_tree<_Key, =
_Val, _KeyOfValue, _Compare, _Alloc>::const_iterator, _Args&& ...) [with _A=
rgs =3D {const std::piecewise_construct_t&, std::tuple<unsigned int&&>, std=
::tuple<>}; _Key =3D unsigned int; _Val =3D std::pair<const unsigned int, v=
4l2_query_ext_ctrl>; _KeyOfValue =3D std::_Select1st<std::pair<const unsign=
ed int, v4l2_query_ext_ctrl> >; _Compare =3D std::less<unsigned int>; _Allo=
c =3D std::allocator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >]=
=E2=80=99:
/usr/include/c++/6/bits/stl_tree.h:2193:7: note: parameter passing for argu=
ment of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned =
int, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4=
l2_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<con=
st unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tre=
e_const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=
=80=99 will change in GCC 7.1
       _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/c++/6/map:61:0,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qmetatype=
.h:57,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtCore/qobject.h=
:54,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qwidge=
t.h:44,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/qmainw=
indow.h:43,
                 from /usr/include/arm-linux-gnueabihf/qt5/QtWidgets/QMainW=
indow:1,
                 from qv4l2.h:25,
                 from ctrl-tab.cpp:20:
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setVal64(unsigned int, long long int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98long long in=
t ApplicationWindow::getVal64(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setString(unsigned int, const QString&)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98QString Appl=
icationWindow::getString(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98int Applicat=
ionWindow::getVal(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setVal(unsigned int, int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::refresh(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::updateCtrl(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::setDefaults(unsigned int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::ctrlAction(int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::updateCtrlRange(unsigned int, __s32)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h: In member function =E2=80=98void Applica=
tionWindow::addTabs(int)=E2=80=99:
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:483:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
/usr/include/c++/6/bits/stl_map.h:502:4: note: parameter passing for argume=
nt of type =E2=80=98std::_Rb_tree<unsigned int, std::pair<const unsigned in=
t, v4l2_query_ext_ctrl>, std::_Select1st<std::pair<const unsigned int, v4l2=
_query_ext_ctrl> >, std::less<unsigned int>, std::allocator<std::pair<const=
 unsigned int, v4l2_query_ext_ctrl> > >::const_iterator {aka std::_Rb_tree_=
const_iterator<std::pair<const unsigned int, v4l2_query_ext_ctrl> >}=E2=80=
=99 will change in GCC 7.1
    __i =3D _M_t._M_emplace_hint_unique(__i, std::piecewise_construct,
    ^~~
