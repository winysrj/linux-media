Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:43907 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbdHRIQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 04:16:58 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: hans.verkuil@cisco.com
Cc: mchehab@kernel.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 1/2] doc: media/v4l-drivers/qcom_camss: Add abbreviations explanation
Date: Fri, 18 Aug 2017 11:16:33 +0300
Message-Id: <1503044194-7405-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add explanations for VFE's PIX and RDI interfaces.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 Documentation/media/v4l-drivers/qcom_camss.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index 7ef632a..9e66b7b 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -34,11 +34,12 @@ driver consists of:
 - ISPIF (ISP Interface) module. Handles the routing of the data streams from
   the CSIDs to the inputs of the VFE;
 - VFE (Video Front End) module. Contains a pipeline of image processing hardware
-  blocks. The VFE has different input interfaces. The PIX input interface feeds
-  the input data to the image processing pipeline. The image processing pipeline
-  contains also a scale and crop module at the end. Three RDI input interfaces
-  bypass the image processing pipeline. The VFE also contains the AXI bus
-  interface which writes the output data to memory.
+  blocks. The VFE has different input interfaces. The PIX (Pixel) input
+  interface feeds the input data to the image processing pipeline. The image
+  processing pipeline contains also a scale and crop module at the end. Three
+  RDI (Raw Dump Interface) input interfaces bypass the image processing
+  pipeline. The VFE also contains the AXI bus interface which writes the output
+  data to memory.
 
 
 Supported functionality
-- 
2.7.4
