Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56072 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdFSO4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:39 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 18/19] doc: media/v4l-drivers: Qualcomm Camera Subsystem - Scale and crop
Date: Mon, 19 Jun 2017 17:48:38 +0300
Message-Id: <1497883719-12410-19-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the Qualcomm Camera Subsystem driver document for VFE scale
and crop modules support.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/v4l-drivers/qcom_camss.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index 4df5655..7e4ab6e 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -35,7 +35,8 @@ driver consists of:
   the CSIDs to the inputs of the VFE;
 - VFE (Video Front End) module. Contains a pipeline of image processing hardware
   blocks. The VFE has different input interfaces. The PIX input interface feeds
-  the input data to the image processing pipeline. Three RDI input interfaces
+  the input data to the image processing pipeline. The image processing pipeline
+  contains also a scale and crop module at the end. Three RDI input interfaces
   bypass the image processing pipeline. The VFE also contains the AXI bus
   interface which writes the output data to memory.
 
@@ -69,6 +70,11 @@ The current version of the driver supports:
     - NV12/NV21 (two plane YUV 4:2:0);
     - NV16/NV61 (two plane YUV 4:2:2).
 
+  - Scaling support. Configuration of the VFE Encoder Scale module
+    for downscalling with ratio up to 16x.
+
+  - Cropping support. Configuration of the VFE Encoder Crop module.
+
 - Concurrent and independent usage of two data inputs - could be camera sensors
   and/or TG.
 
@@ -130,6 +136,12 @@ not required to implement the currently supported functionality. The complete
 configuration on each hardware module is applied on STREAMON ioctl based on
 the current active media links, formats and controls set.
 
+The output size of the scaler module in the VFE is configured with the actual
+compose selection rectangle on the sink pad of the 'msm_vfe0_pix' entity.
+
+The crop output area of the crop module in the VFE is configured with the actual
+crop selection rectangle on the source pad of the 'msm_vfe0_pix' entity.
+
 
 Documentation
 -------------
-- 
1.9.1
