Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-db02.mx.aol.com ([205.188.91.96]:64180 "EHLO
	imr-db02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0BVL2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 06:28:42 -0500
Received: from mtaout-ma02.r1000.mx.aol.com (mtaout-ma02.r1000.mx.aol.com [172.29.41.2])
	by imr-db02.mx.aol.com (8.14.1/8.14.1) with ESMTP id o1MBSeXY010220
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 06:28:40 -0500
Received: from [192.168.1.4] (cpc2-dals15-2-0-cust338.hari.cable.virginmedia.com [94.170.127.83])
	by mtaout-ma02.r1000.mx.aol.com (WebSuites/MUA Thirdparty client Interface) with ESMTPA id E8A8BE00008F
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 06:28:39 -0500 (EST)
Message-ID: <4B826A66.4000808@netscape.net>
Date: Mon, 22 Feb 2010 11:28:38 +0000
From: John Reid <johnbaronreid@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hauppage 2200 on 2.6.33 kernel : nodename is now devnode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry if this is a duplicate. My previous post didn't seem to appear.

I'm using mythbuntu 9.10.

I upgraded to kernel v2.6.33-rc8 because I have a DH55TC mobo (following 
the advice here https://wiki.ubuntu.com/Intel_DH55TC). This fixed a 
number of startup and slow video issues.

Now I can't rebuild the drivers for my hauppage 2200 as I did for my 
previous kernel. I've been following the instructions here:
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200
I've been using the dev tree but I also get similar errors with the 
stable tree.

Initially I got a message complaining v4l/config-compat.h could not 
include autoconf.h. I got around that by changing the include to be:
#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
#include <linux/autoconf.h>
#endif

Now I get the following error:
/home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.c: In function 
'init_dvbdev':
/home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.c:516: error: 
'struct class' has no member named 'nodename'
make[3]: *** 
[/home/john/local/src/hauppage-2200/saa7164-dev/v4l/dvbdev.o] Error 1
make[2]: *** 
[_module_/home/john/local/src/hauppage-2200/saa7164-dev/v4l] Error 2
make[2]: Leaving directory 
`/usr/src/linux-headers-2.6.33-020633rc8-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory 
`/home/john/local/src/hauppage-2200/saa7164-dev/v4l'
make: *** [all] Error 2

As far as I can tell by googling, 'nodename' is now 'devnode' and has a 
different signature. I don't think I know enough to edit the driver 
source to reflect this. Has anyone got a solution? If the 2200 driver is 
not currently supported on 2.6.33 does anyone know when it might be?

Thanks for any help!
John.
