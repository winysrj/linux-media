Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1H0U6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 16:58:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media@vger.kernel.org, Amber Jain <amber@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: VIDEO_OMAP2_VOUT broken
Date: Sat, 27 Aug 2011 22:58:04 +0200
Message-ID: <10799840.E2KM4cQAaW@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

Apparently your patch 8cff88c5d "OMAP: DSS2: remove update_mode from omapdss"
broke building the omap_vout driver:

/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2202:15: error: 'struct omap_dss_driver' has no member 
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2203:12: error: 'struct omap_dss_driver' has no member 
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: error: 'OMAP_DSS_UPDATE_MANUAL' undeclared (first 
use in this function)
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: note: each undeclared identifier is reported only 
once for each function it appears in
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2206:15: error: 'struct omap_dss_driver' has no member 
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2207:12: error: 'struct omap_dss_driver' has no member 
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2208:8: error: 'OMAP_DSS_UPDATE_AUTO' undeclared (first use 
in this function)
make[3]: *** [drivers/media/video/omap/omap_vout.o] Error 1
make[2]: *** [drivers/media/video/omap] Error 2
make[1]: *** [drivers/media/video/] Error 2
make: *** [sub-make] Error 2

I've disabled the driver for now in my tree, but I guess this should be
addressed before 3.1.

	Arnd
