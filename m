Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40809 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbeKIRgS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 12:36:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id x2-v6so569334pfm.7
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 23:56:55 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: mchehab@kernel.org, robh+dt@kernel.org, todor.tomov@linaro.org,
        hansverk@cisco.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] dt-bindings: media: i2c: Fix i2c address for OV5645 camera sensor
Date: Fri,  9 Nov 2018 13:26:43 +0530
Message-Id: <20181109075643.17575-1-manivannan.sadhasivam@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i2c address for the Omnivision OV5645 camera sensor is 0x3c. It is
incorrectly mentioned as 0x78 in binding. Hence fix that.

Fixes: 09c716af36e6 [media] media: i2c/ov5645: add the device tree binding document
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/devicetree/bindings/media/i2c/ov5645.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
index fd7aec9f8e24..1a68ca5eb9a3 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
@@ -26,9 +26,9 @@ Example:
 	&i2c1 {
 		...
 
-		ov5645: ov5645@78 {
+		ov5645: ov5645@3c {
 			compatible = "ovti,ov5645";
-			reg = <0x78>;
+			reg = <0x3c>;
 
 			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
 			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
-- 
2.17.1
