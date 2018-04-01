Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40323 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbeDAA7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 31 Mar 2018 20:59:31 -0400
Received: by mail-pl0-f67.google.com with SMTP id x4-v6so2125583pln.7
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2018 17:59:31 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v6 1/2] media: dt-bindings: Add bindings for panasonic,amg88xx
Date: Sat, 31 Mar 2018 17:59:25 -0700
Message-Id: <20180401005926.18203-2-matt.ranostay@konsulko.com>
In-Reply-To: <20180401005926.18203-1-matt.ranostay@konsulko.com>
References: <20180401005926.18203-1-matt.ranostay@konsulko.com>
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
