Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40720 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GCBAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 21:00:10 -0400
Received: by mail-ee0-f45.google.com with SMTP id c1so3082956eek.4
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 18:00:08 -0700 (PDT)
Message-ID: <51D37796.2000601@zenburn.net>
Date: Wed, 03 Jul 2013 03:00:06 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [omap3isp] xclk deadlock
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,


Background:

I was trying to get the mt9p031 sensor working on a BeagleBoard xM with 
a patched 3.9.8 kernel[1] or with the Laurent Pinchart's omap3isp/xclk 
branch[2]. I had this hardware working quite well under linux 3.2.8 and 
3.2.24 with a patchset from Max Galemin but I had kernel crashes from 
time to time so I wanted to give a more recent kernel a try.

Unfortunatelly I ran into some serious problems. I debugged them as far 
as I could but I cannot even begin to think of fixing this on my own so 
I would be really grateful if somebody could point me in the right 
direction.



The problems:

1. I get a kernel deadlock when I run "media-ctl -p":

mt9p031_power_on calls clk_prepare_enable to get it's clock running
This, via isp_xclk_prepare -> omap3isp_get -> isp_enable_clocks results 
in another call to clk_prepare_enable which causes a deadlock because of 
the global prepare_lock in clk.c

2. Another thing is a lockdep warning during bootup:

It warns about mixing the ordering of prepare_lock & isp->isp_mutex. The 
cause is that isp_probe acquires the isp_mutex first and then proceeds 
to enable clocks (acquiring prepare_lock in the process). Later on when 
the mt9p031 is intialized from v4l2_device_register_subdev it starts 
with getting it's clock and later locks isp_mutex via omap3isp_get (the 
deadlock does not happen in this case because the ISP clocks were 
already enabled).



[1]: My patches agains vanilla 3.9.8 can be inspected here:
 
https://github.com/LoEE/buildroot/tree/daf8276e3629f9aa8540fdd3510859c811dd2d24/board/beagleboard/xm/kernel-patches
I have cherry-picked some omap3isp and mt9p031 patches from this mailing 
list (and reinvented at least one of them myself). Other patches (most 
of them) were taken from
  https://github.com/RobertCNelson/stable-kernel/tree/v3.9.x

[2]: I made one change (to get cpu_is_omap3630 defined):
diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c 
b/arch/arm/mach-omap2/board-omap3beagle-camera.c
index bf84b48..cf5ad89e 100644
--- a/arch/arm/mach-omap2/board-omap3beagle-camera.c
+++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
@@ -18,6 +18,7 @@
  #include <media/omap3isp.h>

  #include "devices.h"
+#include "soc.h"

  #define MT9P031_RESET_GPIO     98


-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
