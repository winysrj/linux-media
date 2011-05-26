Return-path: <mchehab@pedra>
Received: from visualpaging.com ([24.123.23.170]:55536 "EHLO
	unifiedpaging.messagenetsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547Ab1EZNLE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 09:11:04 -0400
Received: from devcentos5x64.msgnet.com (visualpaging.com [24.123.23.170])
	by unifiedpaging.messagenetsystems.com (8.13.1/8.13.1) with ESMTP id p4QDB31i018801
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 09:11:03 -0400
Message-ID: <4DDE5168.1090805@MessageNetSystems.com>
Date: Thu, 26 May 2011 09:11:04 -0400
From: Jerry Geis <geisj@MessageNetSystems.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: use compile uvc_video
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am using centos 5.6 (older kernel) and I get compile errors when I 
grabbed
the latest from http://linuxtv.org/hg/v4l-dvb (which I expect as I have 
an older 2.6.18 kernel)

All I need is uvc so I thought I would do "make menuconfig" and turn 
everything off
but v4l/UVC stuff.

when I do make I get an error:
Kernel build directory is /lib/modules/2.6.18-194.32.1.el5/build
make -C /lib/modules/2.6.18-194.32.1.el5/build 
SUBDIRS=/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.18-194.32.1.el5-x86_64'
  CC [M]  
/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o
In file included from 
/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.c:19:
/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/compat.h:133: 
error: static declaration of 'strict_strtoul' follows non-static declaration
include/linux/kernel.h:141: error: previous declaration of 
'strict_strtoul' was here
make[3]: *** 
[/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o] 
Error 1
make[2]: *** 
[_module_/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.18-194.32.1.el5-x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory 
`/home/silentm/MessageNet/v4l/new/v4l-dvb-3724e93f7af5/v4l'
make: *** [all] Error 2


Is there a way I can just compile the linux/drivers/media/video/uvc ?

thats all I need. How do I do that?

Thanks,

Jerry
