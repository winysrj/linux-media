Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:57520 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZK1Wws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 17:52:48 -0500
Received: by ewy7 with SMTP id 7so3049856ewy.28
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 14:52:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <355c45860911281450g70094174u7805884d669dd5ea@mail.gmail.com>
References: <355c45860911281450g70094174u7805884d669dd5ea@mail.gmail.com>
Date: Sat, 28 Nov 2009 23:52:53 +0100
Message-ID: <355c45860911281452tcc8a6q99145ccbc7238b63@mail.gmail.com>
Subject: Fwd: Build fails when compiling dvb_frontend.c
From: Tomislav Strelar <tstrelar@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone.

I am trying to build v4l-dvb device drivers according to instruction
on linuxTV wiki
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

but it fails when compiling dvb_frontend.c

This is what I get:

/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.c: In
function 'dvb_frontend_stop':
/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.c:707: error:
implicit declaration of function 'init_MUTEX'
make[3]: *** [/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l/dvb_frontend.o]
Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/home/tomislav/src/v4l-dvb-e341e9e85af2/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-9-rt'

Kerner version is
Linux version 2.6.31-9-rt (buildd@yellow) (gcc version 4.4.1 (Ubuntu
4.4.1-4ubuntu8) ) #152-Ubuntu SMP PREEMPT RT Thu Oct 15 13:22:24 UTC
2009


I've searched everywhere, and I haven't find similar problem. Can
someone give me a hint what am I doing wrong. And just to say, I'm far
from being a linux expert. :)

Thank you,
Tomislav
