Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcGRB4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 21/36] [media] doc-rst: add omap3isp documentation
Date: Sun, 17 Jul 2016 22:56:04 -0300
Message-Id: <b9561093037ce128fff2f65e1d61b1a8f64b74c4.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert omap3isp documentation to ReST and add it to the
media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst    |   1 +
 Documentation/media/v4l-drivers/omap3isp.rst | 135 ++++++++++++++-------------
 2 files changed, 70 insertions(+), 66 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 8c6f4745aa07..272c2dc9ceb1 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -28,4 +28,5 @@ License".
 	fimc
 	ivtv
 	meye
+	omap3isp
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/omap3isp.rst b/Documentation/media/v4l-drivers/omap3isp.rst
index b9a9f83b1587..336e58feaee2 100644
--- a/Documentation/media/v4l-drivers/omap3isp.rst
+++ b/Documentation/media/v4l-drivers/omap3isp.rst
@@ -1,15 +1,18 @@
+.. include:: <isonum.txt>
+
 OMAP 3 Image Signal Processor (ISP) driver
+==========================================
 
-Copyright (C) 2010 Nokia Corporation
-Copyright (C) 2009 Texas Instruments, Inc.
+Copyright |copy| 2010 Nokia Corporation
 
-Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-	  Sakari Ailus <sakari.ailus@iki.fi>
-	  David Cohen <dacohen@gmail.com>
+Copyright |copy| 2009 Texas Instruments, Inc.
+
+Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
+Sakari Ailus <sakari.ailus@iki.fi>, David Cohen <dacohen@gmail.com>
 
 
 Introduction
-============
+------------
 
 This file documents the Texas Instruments OMAP 3 Image Signal Processor (ISP)
 driver located under drivers/media/platform/omap3isp. The original driver was
@@ -18,9 +21,9 @@ Nokia.
 
 The driver has been successfully used on the following versions of OMAP 3:
 
-	3430
-	3530
-	3630
+- 3430
+- 3530
+- 3630
 
 The driver implements V4L2, Media controller and v4l2_subdev interfaces.
 Sensor, lens and flash drivers using the v4l2_subdev interface in the kernel
@@ -28,27 +31,27 @@ are supported.
 
 
 Split to subdevs
-================
+----------------
 
 The OMAP 3 ISP is split into V4L2 subdevs, each of the blocks inside the ISP
 having one subdev to represent it. Each of the subdevs provide a V4L2 subdev
 interface to userspace.
 
-	OMAP3 ISP CCP2
-	OMAP3 ISP CSI2a
-	OMAP3 ISP CCDC
-	OMAP3 ISP preview
-	OMAP3 ISP resizer
-	OMAP3 ISP AEWB
-	OMAP3 ISP AF
-	OMAP3 ISP histogram
+- OMAP3 ISP CCP2
+- OMAP3 ISP CSI2a
+- OMAP3 ISP CCDC
+- OMAP3 ISP preview
+- OMAP3 ISP resizer
+- OMAP3 ISP AEWB
+- OMAP3 ISP AF
+- OMAP3 ISP histogram
 
 Each possible link in the ISP is modelled by a link in the Media controller
-interface. For an example program see [2].
+interface. For an example program see [#f2]_.
 
 
 Controlling the OMAP 3 ISP
-==========================
+--------------------------
 
 In general, the settings given to the OMAP 3 ISP take effect at the beginning
 of the following frame. This is done when the module becomes idle during the
@@ -65,7 +68,7 @@ is non-zero.
 
 
 Events
-======
+------
 
 The OMAP 3 ISP driver does support the V4L2 event interface on CCDC and
 statistics (AEWB, AF and histogram) subdevs.
@@ -85,9 +88,9 @@ generated whenever a statistics buffer can be dequeued by a user space
 application using the VIDIOC_OMAP3ISP_STAT_REQ IOCTL. The events available
 are:
 
-	V4L2_EVENT_OMAP3ISP_AEWB
-	V4L2_EVENT_OMAP3ISP_AF
-	V4L2_EVENT_OMAP3ISP_HIST
+- V4L2_EVENT_OMAP3ISP_AEWB
+- V4L2_EVENT_OMAP3ISP_AF
+- V4L2_EVENT_OMAP3ISP_HIST
 
 The type of the event data is struct omap3isp_stat_event_status for these
 ioctls. If there is an error calculating the statistics, there will be an
@@ -96,7 +99,7 @@ omap3isp_stat_event_status.buf_err is set to non-zero.
 
 
 Private IOCTLs
-==============
+--------------
 
 The OMAP 3 ISP driver supports standard V4L2 IOCTLs and controls where
 possible and practical. Much of the functions provided by the ISP, however,
@@ -108,13 +111,13 @@ containing hardware-dependent functions.
 
 The following private IOCTLs are supported:
 
-	VIDIOC_OMAP3ISP_CCDC_CFG
-	VIDIOC_OMAP3ISP_PRV_CFG
-	VIDIOC_OMAP3ISP_AEWB_CFG
-	VIDIOC_OMAP3ISP_HIST_CFG
-	VIDIOC_OMAP3ISP_AF_CFG
-	VIDIOC_OMAP3ISP_STAT_REQ
-	VIDIOC_OMAP3ISP_STAT_EN
+- VIDIOC_OMAP3ISP_CCDC_CFG
+- VIDIOC_OMAP3ISP_PRV_CFG
+- VIDIOC_OMAP3ISP_AEWB_CFG
+- VIDIOC_OMAP3ISP_HIST_CFG
+- VIDIOC_OMAP3ISP_AF_CFG
+- VIDIOC_OMAP3ISP_STAT_REQ
+- VIDIOC_OMAP3ISP_STAT_EN
 
 The parameter structures used by these ioctls are described in
 include/linux/omap3isp.h. The detailed functions of the ISP itself related to
@@ -128,7 +131,7 @@ appropriate private IOCTLs.
 
 
 CCDC and preview block IOCTLs
-=============================
+-----------------------------
 
 The VIDIOC_OMAP3ISP_CCDC_CFG and VIDIOC_OMAP3ISP_PRV_CFG IOCTLs are used to
 configure, enable and disable functions in the CCDC and preview blocks,
@@ -136,7 +139,7 @@ respectively. Both IOCTLs control several functions in the blocks they
 control. VIDIOC_OMAP3ISP_CCDC_CFG IOCTL accepts a pointer to struct
 omap3isp_ccdc_update_config as its argument. Similarly VIDIOC_OMAP3ISP_PRV_CFG
 accepts a pointer to struct omap3isp_prev_update_config. The definition of
-both structures is available in [1].
+both structures is available in [#f1]_.
 
 The update field in the structures tells whether to update the configuration
 for the specific function and the flag tells whether to enable or disable the
@@ -151,34 +154,34 @@ Valid values for the update and flag fields are listed here for
 VIDIOC_OMAP3ISP_CCDC_CFG. Values may be or'ed to configure more than one
 function in the same IOCTL call.
 
-        OMAP3ISP_CCDC_ALAW
-        OMAP3ISP_CCDC_LPF
-        OMAP3ISP_CCDC_BLCLAMP
-        OMAP3ISP_CCDC_BCOMP
-        OMAP3ISP_CCDC_FPC
-        OMAP3ISP_CCDC_CULL
-        OMAP3ISP_CCDC_CONFIG_LSC
-        OMAP3ISP_CCDC_TBL_LSC
+- OMAP3ISP_CCDC_ALAW
+- OMAP3ISP_CCDC_LPF
+- OMAP3ISP_CCDC_BLCLAMP
+- OMAP3ISP_CCDC_BCOMP
+- OMAP3ISP_CCDC_FPC
+- OMAP3ISP_CCDC_CULL
+- OMAP3ISP_CCDC_CONFIG_LSC
+- OMAP3ISP_CCDC_TBL_LSC
 
 The corresponding values for the VIDIOC_OMAP3ISP_PRV_CFG are here:
 
-        OMAP3ISP_PREV_LUMAENH
-        OMAP3ISP_PREV_INVALAW
-        OMAP3ISP_PREV_HRZ_MED
-        OMAP3ISP_PREV_CFA
-        OMAP3ISP_PREV_CHROMA_SUPP
-        OMAP3ISP_PREV_WB
-        OMAP3ISP_PREV_BLKADJ
-        OMAP3ISP_PREV_RGB2RGB
-        OMAP3ISP_PREV_COLOR_CONV
-        OMAP3ISP_PREV_YC_LIMIT
-        OMAP3ISP_PREV_DEFECT_COR
-        OMAP3ISP_PREV_GAMMABYPASS
-        OMAP3ISP_PREV_DRK_FRM_CAPTURE
-        OMAP3ISP_PREV_DRK_FRM_SUBTRACT
-        OMAP3ISP_PREV_LENS_SHADING
-        OMAP3ISP_PREV_NF
-        OMAP3ISP_PREV_GAMMA
+- OMAP3ISP_PREV_LUMAENH
+- OMAP3ISP_PREV_INVALAW
+- OMAP3ISP_PREV_HRZ_MED
+- OMAP3ISP_PREV_CFA
+- OMAP3ISP_PREV_CHROMA_SUPP
+- OMAP3ISP_PREV_WB
+- OMAP3ISP_PREV_BLKADJ
+- OMAP3ISP_PREV_RGB2RGB
+- OMAP3ISP_PREV_COLOR_CONV
+- OMAP3ISP_PREV_YC_LIMIT
+- OMAP3ISP_PREV_DEFECT_COR
+- OMAP3ISP_PREV_GAMMABYPASS
+- OMAP3ISP_PREV_DRK_FRM_CAPTURE
+- OMAP3ISP_PREV_DRK_FRM_SUBTRACT
+- OMAP3ISP_PREV_LENS_SHADING
+- OMAP3ISP_PREV_NF
+- OMAP3ISP_PREV_GAMMA
 
 The associated configuration pointer for the function may not be NULL when
 enabling the function. When disabling a function the configuration pointer is
@@ -186,7 +189,7 @@ ignored.
 
 
 Statistic blocks IOCTLs
-=======================
+-----------------------
 
 The statistics subdevs do offer more dynamic configuration options than the
 other subdevs. They can be enabled, disable and reconfigured when the pipeline
@@ -218,7 +221,7 @@ can be found on OMAP's TRMs. The two following fields common to all the above
 configure private IOCTLs require explanation for better understanding as they
 are not part of the TRM.
 
-omap3isp_[h3a_af/h3a_aewb/hist]_config.buf_size:
+omap3isp_[h3a_af/h3a_aewb/hist]\_config.buf_size:
 
 The modules handle their buffers internally. The necessary buffer size for the
 module's data output depends on the requested configuration. Although the
@@ -235,7 +238,7 @@ out of [minimum, maximum] buffer size range, it's clamped to fit in there.
 The driver then selects the biggest value. The corrected buf_size value is
 written back to user application.
 
-omap3isp_[h3a_af/h3a_aewb/hist]_config.config_counter:
+omap3isp_[h3a_af/h3a_aewb/hist]\_config.config_counter:
 
 As the configuration doesn't take effect synchronously to the request, the
 driver must provide a way to track this information to provide more accurate
@@ -254,7 +257,7 @@ matches with the video buffer's field_count.
 
 
 Technical reference manuals (TRMs) and other documentation
-==========================================================
+----------------------------------------------------------
 
 OMAP 3430 TRM:
 <URL:http://focus.ti.com/pdfs/wtbu/OMAP34xx_ES3.1.x_PUBLIC_TRM_vZM.zip>
@@ -272,8 +275,8 @@ DM 3730 TRM:
 
 
 References
-==========
+----------
 
-[1] include/linux/omap3isp.h
+.. [#f1] include/linux/omap3isp.h
 
-[2] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
+.. [#f2] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
-- 
2.7.4

