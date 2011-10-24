Return-path: <linux-media-owner@vger.kernel.org>
Received: from contrabass.post.ru ([85.21.78.5]:26079 "EHLO
	contrabass.corbina.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1JXNqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 09:46:04 -0400
Message-ID: <4EA56C0B.70808@darkmike.ru>
Date: Mon, 24 Oct 2011 17:45:47 +0400
From: Mike Mironov <subscribe@darkmike.ru>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Josu Lazkano <josu.lazkano@gmail.com>
Subject: Re: Problem with TeVii S-470
References: <4EA54389.9040505@darkmike.ru>	<CAL9G6WX1tTSLsm-iMNWnJdWJWQQ1m31WTTzrvG3eh9BYE8fnfw@mail.gmail.com>	<4EA56322.7040609@darkmike.ru> <CAL9G6WXS9cPTG1w=AGgUDLA5vkcYyAK1e7ZHdK33aAXjzVCU0A@mail.gmail.com>
In-Reply-To: <CAL9G6WXS9cPTG1w=AGgUDLA5vkcYyAK1e7ZHdK33aAXjzVCU0A@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

24.10.2011 17:32, Josu Lazkano пишет:
> 2011/10/24 Mike Mironov<subscribe@darkmike.ru>:
>> 24.10.2011 15:29, Josu Lazkano пишет:
>>>
>>> 2011/10/24 Mike Mironov<subscribe@darkmike.ru>:
>>>>
>>>> Hello!
>>>>
>>>> I have this card http://www.linuxtv.org/wiki/index.php/TeVii_S470
>>>>
>>>> I try to use it under Debian Squeeze, but I can't get channel data from
>>>> it.
>>>>
>>>> I try to use drivers from 2.6.38, 2.6.39 kernels, s2-liplianin drivers
                                                        ^^^^^^^^^^^^
>
> Hello again, actually, I am using this method for Tevii S660 and S470:
>
> apt-get install linux-headers-`uname -r` build-essential
> mkdir /usr/local/src/dvb
> cd /usr/local/src/dvb
> wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
> unzip tip.zip
> cd s2-liplianin-0b7d3cc65161
> make CONFIG_DVB_FIREDTV:=n
> make install
>
> Both methods works for me on a Debian Squeeze (2.6.32). Here more
> info: http://linuxtv.org/wiki/index.php/TeVii_S470
>

As your can see in quoted text I always try to use this drivers. Result 
is same. I'll always read WiKi link. I know that another users use this 
card without problems. I have good signal quality (88% signal and 79-80% 
snr). But in my 2 linux systems I can't get channel data. Scan work 
fine(!).
