Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:51399 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1ARQYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 11:24:13 -0500
Message-ID: <4D35BC6D.1050801@matrix-vision.de>
Date: Tue, 18 Jan 2011 17:14:37 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: link error w/ media-0006-sensors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent & Sakari,

On Laurent's media-0006-sensors branch, when compiling with
CONFIG_VIDEO_OMAP3=m, I got the following linking error:

ERROR: "omap_pm_set_min_bus_tput" [drivers/media/video/isp/omap3-isp.ko]
undefined!

I can get rid of the error with the patch below. But as always, I
wonder: Why didn't anybody else come across this error? Are you all
compiling with VIDEO_OMAP3=y? Is there a config file somewhere I can see
where someone is using that?

And would anything be wrong with the patch below?

-Michael

diff --git a/arch/arm/plat-omap/omap-pm-noop.c b/arch/arm/plat-omap/omap-pm-noop.c
index e129ce8..9e0bcb6 100644
--- a/arch/arm/plat-omap/omap-pm-noop.c
+++ b/arch/arm/plat-omap/omap-pm-noop.c
@@ -88,6 +88,7 @@ int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(omap_pm_set_min_bus_tput);
 
 int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
 				   long t)





MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
