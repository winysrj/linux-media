Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46867 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2JFSXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 14:23:05 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2032750eek.19
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2012 11:23:03 -0700 (PDT)
Message-ID: <50707704.5030402@gmail.com>
Date: Sat, 06 Oct 2012 20:23:00 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement .get_frame_desc
 subdev callback
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com> <1348674853-24596-6-git-send-email-s.nawrocki@samsung.com> <50704D26.9020201@hoogenraad.net>
In-Reply-To: <50704D26.9020201@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jan,

On 10/06/2012 05:24 PM, Jan Hoogenraad wrote:
> On my ubuntu 10.4 system
> 
> Linux 2.6.32-43-generic-pae #97-Ubuntu SMP Wed Sep 5 16:59:17 UTC 2012
> i686 GNU/Linux
> 
> this patch breaks compilation of media_build.
> The constant SZ_1M is not defined in the includes on my system
> 
> Do you know what can be done about this ?
> 
> ---
> 
> /home/jhh/dvb/media_build/v4l/m5mols_core.c: In function
> 'm5mols_set_frame_desc':
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: 'SZ_1M'
> undeclared (first use in this function)
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: (Each undeclared
> identifier is reported only once
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: for each
> function it appears in.)

Thanks for reporting this issue. You most likely don't need the M-5MOLS
camera sensor driver on you system so one option is to just disable it
at kernel config. Make sure CONFIG_VIDEO_M5MOLS is not set, it can be 
unselected at menuconfig

 -> Device Drivers
    -> Multimedia
      -> Encoders, decoders, sensors and other helper chips
         < > Fujitsu M-5MOLS 8MP sensor support

The below patch which is intended to fix this issue won't work for
media drivers backport builds on kernels older than 3.6, so m5mols
driver should not be built for kernel versions < 3.6.

8<-------------------------------------------------------------------
>From 3e138ea603c9e5102452554cb14e4b404ce306e0 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Date: Sat, 6 Oct 2012 20:04:40 +0200
Subject: [PATCH] m5mols: Add missing #include <linux/sizes.h>

Include <linux/sizes.h> header that is missing after commit ab7ef22419927
"[media] m5mols: Implement .get_frame_desc subdev callback".
It prevents possible build errors due to undefined SZ_1M.

Reported-by: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/i2c/m5mols/m5mols.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols.h b/drivers/media/i2c/m5mols/m5mols.h
index 4ab8b37..90a6c52 100644
--- a/drivers/media/i2c/m5mols/m5mols.h
+++ b/drivers/media/i2c/m5mols/m5mols.h
@@ -16,6 +16,7 @@
 #ifndef M5MOLS_H
 #define M5MOLS_H
 
+#include <linux/sizes.h>
 #include <media/v4l2-subdev.h>
 #include "m5mols_reg.h"
 
-- 
1.7.4.1
8<-------------------------------------------------------------------

--

Regards,
Sylwester
