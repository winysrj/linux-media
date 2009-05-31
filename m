Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pascal_stroeing@arcor.de>) id 1MAhRG-0006y6-7A
	for linux-dvb@linuxtv.org; Sun, 31 May 2009 11:34:47 +0200
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net
	[151.189.8.29]) by mx.arcor.de (Postfix) with ESMTP id DD3C7256F79
	for <linux-dvb@linuxtv.org>; Sun, 31 May 2009 11:34:12 +0200 (CEST)
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mail-in-12-z2.arcor-online.net (Postfix) with ESMTP id 900B9279459
	for <linux-dvb@linuxtv.org>; Sun, 31 May 2009 11:34:12 +0200 (CEST)
Received: from [192.168.2.101] (dslb-084-057-037-093.pools.arcor-ip.net
	[84.57.37.93]) (Authenticated sender: pascal_stroeing@arcor.de)
	by mail-in-04.arcor-online.net (Postfix) with ESMTPA id 3338133A9E0
	for <linux-dvb@linuxtv.org>; Sun, 31 May 2009 11:34:12 +0200 (CEST)
Message-ID: <4A224F10.6020908@arcor.de>
Date: Sun, 31 May 2009 11:34:08 +0200
From: =?ISO-8859-15?Q?Pascal_Str=F6ing?= <pascal_stroeing@arcor.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] udev creates '/dev/video0' and '/dev/v4l/' instead of
 '/dev/dvb/' when I plug in my DVB-T USB stick
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dear TV-under-Linux-watchers,


I want to present my problem without detours:

I own a pinnacle USB DVB-T stick '70e'. It runs very well under Ubuntu 
8.04. I used this driver-list: 
'|http://mcentral.de/hg/~mrec/v4l-dvb-kernel' and ||'modprobe em28xx'. 
No need of firmware.
|
Now I try to install the driver on a fresh Debian 5.0 system. The driver 
file I have made good exerience with does not work (errors while doing 
'make'). So I tried out 'http://linuxtv.org/hg/v4l-dvb' 
<http://linuxtv.org/hg/v4l-dvb>. No problems during installation. Typing 
|'modprobe em28xx'|, no error message. When I now plug in the device, 
there is no '/dev/dvb/' directory like usual but I can find new files in 
'/dev/v4l/' and a '/dev/video0' file. This seems to me v4l handles the 
stick like a webcam or something but not an USB DVB-T stick!? That is 
why the usual dvb-apps testing tools or kaffein do not work.
'|lsmod|' and '|dmesg|' shows me a lot of |'modprobe em28xx'-percepiency|!?


Can anyone tell me how I can use my TV stick?

Best regards,
Pascal
||

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
