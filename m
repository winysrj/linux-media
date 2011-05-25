Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56642 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EYHWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 03:22:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex Gershgorin <alexg@meprolight.com>
Subject: Re: FW: OMAP 3 ISP
Date: Wed, 25 May 2011 09:22:27 +0200
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	Michael Jones <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
References: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D40@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D40@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201105250922.28496.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

On Tuesday 24 May 2011 16:11:16 Alex Gershgorin wrote:
> Hi All,
> 
> I wrote a simple V4L2 subdevs I2C driver which returns a fixed format and
> size. I do not understand who reads these parameters, user application
> through IOCTL or OMAP3 ISP driver uses them regardless of the user space
> application?

Both. media-ctl (and other userspace applications) can use them, and the OMAP3
ISP driver retrieves them when starting the video stream to make sure that the
formats at the "sensor" output and at the CCDC input match.

> Another question, if I need to change polarity of Vertical or Horizontal
> synchronization signals, according struct isp_parallel_platform_data, is
> it not possible?
> 
> struct isp_parallel_platform_data {
>         unsigned int data_lane_shift:2;
>         unsigned int clk_pol:1;
>         unsigned int bridge:4;
> };

Could you please try the following patch ?

>From 7f8eff25e63880a93bc283cd97840227cd092622 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Wed, 25 May 2011 09:16:28 +0200
Subject: [PATCH] omap3isp: Support configurable HS/VS polarities

Add two fields to the ISP parallel platform data to set the HS and VS
signals polarities.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.h     |    6 ++++++
 drivers/media/video/omap3isp/ispccdc.c |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 2620c40..529e582 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -139,6 +139,10 @@ struct isp_reg {
  *		3 - CAMEXT[13:6] -> CAM[7:0]
  * @clk_pol: Pixel clock polarity
  *		0 - Non Inverted, 1 - Inverted
+ * @hs_pol: Horizontal synchronization polarity
+ *		0 - Active high, 1 - Active low
+ * @vs_pol: Vertical synchronization polarity
+ *		0 - Active high, 1 - Active low
  * @bridge: CCDC Bridge input control
  *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
  *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
@@ -147,6 +151,8 @@ struct isp_reg {
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
 	unsigned int clk_pol:1;
+	unsigned int hs_pol:1;
+	unsigned int vs_pol:1;
 	unsigned int bridge:4;
 };
 
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 39d501b..5e742b2 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1148,6 +1148,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
 
 	ccdc->syncif.datsz = depth_out;
+	ccdc->syncif.hdpol = pdata ? pdata-> hs_pol : 0;
+	ccdc->syncif.vdpol = pdata ? pdata-> vs_pol : 0;
 	ccdc_config_sync_if(ccdc, &ccdc->syncif);
 
 	/* CCDC_PAD_SINK */
@@ -2257,8 +2259,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 	ccdc->syncif.fldout = 0;
 	ccdc->syncif.fldpol = 0;
 	ccdc->syncif.fldstat = 0;
-	ccdc->syncif.hdpol = 0;
-	ccdc->syncif.vdpol = 0;
 
 	ccdc->clamp.oblen = 0;
 	ccdc->clamp.dcsubval = 0;
-- 
1.7.3.4

-- 
Regards,

Laurent Pinchart
