Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41300 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2CLKjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 06:39:15 -0400
Received: by ghrr11 with SMTP id r11so2366874ghr.19
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 03:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201203111527.41689.remi@remlab.net>
References: <CAGa-wNMGMTBdB2bqPL7vibgrv+tLZnOMQsQwDbHHWXO6cyNkTg@mail.gmail.com>
	<201203111527.41689.remi@remlab.net>
Date: Mon, 12 Mar 2012 11:39:14 +0100
Message-ID: <CAGa-wNNkivstczhfktOTqu=xGyBkjtdin7jhL4Q-jixOymcR5A@mail.gmail.com>
Subject: Re: dvb-c usb device for linux
From: Claus Olesen <ceolesen@gmail.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

@Remi - Thank you very much and to everyone involved in making it work.
Because - that it (almost) already works was knew to me.
I'm using Fedora 16 and Kaffeine all fully up to date
and for anyone interested here's all I had to do to make it work.

update software
===============
- get, build and install the latest media files as described in
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
if the build fails as it did for me then if you are able to fix the error(s) in
the source file(s) then you want to build as described under "./build --man" for
"develop a new patch" i.e. by
"cd media_build/v4l;make"
instead of by using the build script which resyncs with the repository thereby
undoing your changes.

setup kaffeine
==============
- close kaffeine
- run "w_scan -fc" (for cable, -ft for terrestial) but no need for any longer
than until it starts scanning frequencies - for the effect of its commanding of
the 290e into the role of a dvb-c device
(is that what the reset button on kaffeine's device panel is supposed to do?)
- launch kaffeine
verify that the device1 panel says DVB-C and Cable as Name
besides, notice that the device2 tab corresponding to
/dev/dvb/adapter0/frontend1
and formerly representing the dvb-c part of the 290e is now gone
- select a Source on the device1 panel
- scan for channels on the channels panel
notice that the channels panel says Cable as Source

with that kaffeine now shows cable tv using the 290e



On Sun, Mar 11, 2012 at 2:27 PM, Rémi Denis-Courmont <remi@remlab.net> wrote:
> Le dimanche 11 mars 2012 15:08:25 Claus Olesen, vous avez écrit :
>> PS.
>> If linux supported the 290e for dvb-c as supported by its chipset
>> CXD2820 as also used by the ET T2C for dvb-c then it would be my choice.
>
> The Linux driver does support DVB-C.
>
> However you need software that understands multi-standard frontends from the
> Linux DVB API v5.4, and that is hard to come by as of today.
>
>> As I said in my previous email then
>> I found that the 290e works for dvb-c using dvbviewer and just now
>> I found that it works for dvb-c also using dvblink
>
> I have 290e showing DVB-C channels with hacked VLC on Linux 3.3-rc6.
>
> --
> Rémi Denis-Courmont
> http://www.remlab.net/
> http://fi.linkedin.com/in/remidenis
