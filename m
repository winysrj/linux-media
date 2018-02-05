Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49948 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752582AbeBEQ6L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 11:58:11 -0500
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
 <20180205143729.12783826@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0d974a93-f37a-e727-ada1-28ad97a7429d@xs4all.nl>
Date: Mon, 5 Feb 2018 17:58:06 +0100
MIME-Version: 1.0
In-Reply-To: <20180205143729.12783826@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 05:37 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 5 Feb 2018 08:21:54 -0800
> Tim Harvey <tharvey@gateworks.com> escreveu:
> 
>> Hans,
>>
>> I'm failing compile (of master 4ee9911) with:
>>
>>   CXX      v4l2_compliance-media-info.o
>> media-info.cpp: In function ‘media_type media_detect_type(const char*)’:
>> media-info.cpp:79:39: error: no matching function for call to
>> ‘std::basic_ifstream<char>::basic_ifstream(std::__cxx11::string&)’
>>   std::ifstream uevent_file(uevent_path);
>>                                        ^
> 
> Btw, while on it, a few days ago, I noticed several class warnings when
> building v4l-utils on Raspbian, saying that it was using some features
> that future versions of gcc would stop using at qv4l2. See enclosed.
> 
> I didn't have time to look on them.
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

I've seen it too, but I have no idea what to do with it. I'm not even sure that it is in my
code instead of in Qt headers or even c++ header.

It's not exactly an informative message.

Since I compile with g++ version 7.2 it appears that it is just fine since it doesn't complain.

Regards,

	Hans
