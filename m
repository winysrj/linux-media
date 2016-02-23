Return-path: <linux-media-owner@vger.kernel.org>
Received: from jusst.de ([188.40.114.84]:45513 "EHLO web01.jusst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbcBWVLt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 16:11:49 -0500
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	lars@metafoo.de, hverkuil@xs4all.nl
Cc: Julian Scheel <julian@jusst.de>
Subject: [PATCH 1/2] media: adv7180: Add device tree binding document
Date: Tue, 23 Feb 2016 22:11:20 +0100
Message-Id: <1456261881-28172-1-git-send-email-julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the adv7180 video decoder family.

Signed-off-by: Julian Scheel <julian@jusst.de>
---
 .../devicetree/bindings/media/i2c/adv7180.txt        | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7180.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
new file mode 100644
index 0000000..2f39f26
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
@@ -0,0 +1,20 @@
+* Analog Devices ADV7180 analog video decoder family
+
+The adv7180 family devices are used to capture analog video to different
+digital interfaces like parallel video.
+
+Required Properties :
+- compatible : value must be "adi,adv7180"
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		adv7180@21 {
+			compatible = "adi,adv7180";
+			reg = <0x21>;
+		};
+		...
+	};
+
-- 
2.7.1

