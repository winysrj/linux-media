Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36434 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeBQByp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 20:54:45 -0500
Received: by mail-pl0-f67.google.com with SMTP id v3so2634202plg.3
        for <linux-media@vger.kernel.org>; Fri, 16 Feb 2018 17:54:45 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: imx.rst: Fix formatting errors
Date: Fri, 16 Feb 2018 17:54:34 -0800
Message-Id: <1518832474-2796-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a few formatting errors.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/media/v4l-drivers/imx.rst | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 3c4f58b..18e3141 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -213,9 +213,11 @@ To give an example of crop and /2 downscale, this will crop a
 1280x960 input frame to 640x480, and then /2 downscale in both
 dimensions to 320x240 (assumes ipu1_csi0 is linked to ipu1_csi0_mux):
 
-media-ctl -V "'ipu1_csi0_mux':2[fmt:UYVY2X8/1280x960]"
-media-ctl -V "'ipu1_csi0':0[crop:(0,0)/640x480]"
-media-ctl -V "'ipu1_csi0':0[compose:(0,0)/320x240]"
+.. code-block:: none
+
+   media-ctl -V "'ipu1_csi0_mux':2[fmt:UYVY2X8/1280x960]"
+   media-ctl -V "'ipu1_csi0':0[crop:(0,0)/640x480]"
+   media-ctl -V "'ipu1_csi0':0[compose:(0,0)/320x240]"
 
 Frame Skipping in ipuX_csiY
 ---------------------------
@@ -229,8 +231,10 @@ at the source pad.
 The following example reduces an assumed incoming 60 Hz frame
 rate by half at the IDMAC output source pad:
 
-media-ctl -V "'ipu1_csi0':0[fmt:UYVY2X8/640x480@1/60]"
-media-ctl -V "'ipu1_csi0':2[fmt:UYVY2X8/640x480@1/30]"
+.. code-block:: none
+
+   media-ctl -V "'ipu1_csi0':0[fmt:UYVY2X8/640x480@1/60]"
+   media-ctl -V "'ipu1_csi0':2[fmt:UYVY2X8/640x480@1/30]"
 
 Frame Interval Monitor in ipuX_csiY
 -----------------------------------
@@ -422,8 +426,7 @@ This pipeline uses the preprocess encode entity to route frames directly
 from the CSI to the IC, to carry out scaling up to 1024x1024 resolution,
 CSC, flipping, and image rotation:
 
--> ipuX_csiY:1 -> 0:ipuX_ic_prp:1 -> 0:ipuX_ic_prpenc:1 ->
-   ipuX_ic_prpenc capture
+-> ipuX_csiY:1 -> 0:ipuX_ic_prp:1 -> 0:ipuX_ic_prpenc:1 -> ipuX_ic_prpenc capture
 
 Motion Compensated De-interlace:
 --------------------------------
@@ -432,8 +435,7 @@ This pipeline routes frames from the CSI direct pad to the VDIC entity to
 support motion-compensated de-interlacing (high motion mode only),
 scaling up to 1024x1024, CSC, flip, and rotation:
 
--> ipuX_csiY:1 -> 0:ipuX_vdic:2 -> 0:ipuX_ic_prp:2 ->
-   0:ipuX_ic_prpvf:1 -> ipuX_ic_prpvf capture
+-> ipuX_csiY:1 -> 0:ipuX_vdic:2 -> 0:ipuX_ic_prp:2 -> 0:ipuX_ic_prpvf:1 -> ipuX_ic_prpvf capture
 
 
 Usage Notes
@@ -458,8 +460,8 @@ This platform requires the OmniVision OV5642 module with a parallel
 camera interface, and the OV5640 module with a MIPI CSI-2
 interface. Both modules are available from Boundary Devices:
 
-https://boundarydevices.com/product/nit6x_5mp
-https://boundarydevices.com/product/nit6x_5mp_mipi
+- https://boundarydevices.com/product/nit6x_5mp
+- https://boundarydevices.com/product/nit6x_5mp_mipi
 
 Note that if only one camera module is available, the other sensor
 node can be disabled in the device tree.
-- 
2.7.4
