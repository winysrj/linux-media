Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:47112 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3GZXvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 19:51:51 -0400
Received: by mail-ee0-f49.google.com with SMTP id b57so1796478eek.36
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 16:51:49 -0700 (PDT)
Message-ID: <51F30B93.4070700@zenburn.net>
Date: Sat, 27 Jul 2013 01:51:47 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
References: <51D37796.2000601@zenburn.net> <3227918.6DpNM0vnE9@avalon> <51E717EF.9070703@zenburn.net> <1993436.YNJGSXUIek@avalon>
In-Reply-To: <1993436.YNJGSXUIek@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Laurent,

The offending commit is
b2da46e52fe7871cba36e1a435844502c0eccf39

After reverting it I get good image on v3.5-rc1. Unfortunatelly trying 
to revert it on the board/beagle/mt9p031 branch causes conflicts and I 
am too tired to even try to fix them right now.

The hanging unfortunatelly remains. It hangs most of the time with 
(ctrl-c was pressed at ≈133 seconds):

[   39.601318] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
[   39.607299] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
[   39.613586] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
[   39.620056] omap3isp omap3isp: 
--------------------------------------------
[  133.516906] omap3isp omap3isp: OMAP3 ISP AEWB: user wants to disable 
module.
[  133.524383] omap3isp omap3isp: OMAP3 ISP AEWB: module is being disabled
[  133.531311] omap3isp omap3isp: OMAP3 ISP AF: user wants to disable 
module.
[  133.538543] omap3isp omap3isp: OMAP3 ISP AF: module is being disabled
[  133.545288] omap3isp omap3isp: OMAP3 ISP histogram: user wants to 
disable module.
[  133.553131] omap3isp omap3isp: OMAP3 ISP histogram: module is being 
disabled

One time I got a lucky and after 1 second elapsed I got:

[   35.250274] omap3isp omap3isp: Unable to stop OMAP3 ISP CCDC
477 images processed in 16.655242 seconds (28.639629 fps)

The second line is console output from ./live.



PS. In case anybody would wish to reproduce my results:

For kernels 3.3 - 3.9 you have to apply:
https://linuxtv.org/patch/10250/
to get omapdss to work.

Until 15693b57931b19f3bb4664cb4fa3f6f966058749 (between 3.4 and 3.5-rc1) 
you can use for the board intergration patch:
https://github.com/MaxGalemin/buildroot/blob/develop/board/beagleboard/xm/kernel-patches/linux-0003-Add-support-for-MT9P031-Aptina-image-sensor-driver.patch

Later ones needs to replace the reset callback with a GPIO number and 
remove the COLOR/MONOCHROME parameter.

The rest is wrestling with changing kernel config parameter names. 
(DVI->TFP410? ;)

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
