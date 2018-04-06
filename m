Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33285 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbeDFWwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 18:52:55 -0400
Received: by mail-pf0-f195.google.com with SMTP id f15so1762326pfn.0
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2018 15:52:54 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v8 1/2] media: dt-bindings: Add bindings for panasonic,amg88xx
Date: Fri,  6 Apr 2018 15:52:30 -0700
Message-Id: <20180406225231.13831-2-matt.ranostay@konsulko.com>
In-Reply-To: <20180406225231.13831-1-matt.ranostay@konsulko.com>
References: <20180406225231.13831-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define the device tree bindings for the panasonic,amg88xx i2c
video driver.

Cc: devicetree@vger.kernel.org
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 .../bindings/media/i2c/panasonic,amg88xx.txt          | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt b/Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
new file mode 100644
index 000000000000..4a3181a3dd7e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
@@ -0,0 +1,19 @@
+* Panasonic AMG88xx
+
+The Panasonic family of AMG88xx Grid-Eye sensors allow recording
+8x8 10Hz video which consists of thermal datapoints
+
+Required Properties:
+ - compatible : Must be "panasonic,amg88xx"
+ - reg : i2c address of the device
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		amg88xx@69 {
+			compatible = "panasonic,amg88xx";
+			reg = <0x69>;
+		};
+		...
+	};
-- 
2.14.1
