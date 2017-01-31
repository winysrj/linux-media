Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34011 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdAaVN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 16:13:56 -0500
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: mchehab@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, sean.wang@mediatek.com,
        sean@mess.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] Documentation: devicetree: add the RC map name of the geekbox remote
Date: Tue, 31 Jan 2017 22:13:42 +0100
Message-Id: <20170131211342.3297-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
The geekbox keymap was added while the documentation patch was not
applied yet (and I wasn't aware of this pending patch). This ensures
that the documentation is in sync with the actual keymaps.

 Documentation/devicetree/bindings/media/rc.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/rc.txt b/Documentation/devicetree/bindings/media/rc.txt
index 0d16d14ccd2a..d3e7a012bfda 100644
--- a/Documentation/devicetree/bindings/media/rc.txt
+++ b/Documentation/devicetree/bindings/media/rc.txt
@@ -46,6 +46,7 @@ The following properties are common to the infrared remote controllers:
   * "rc-flyvideo"
   * "rc-fusionhdtv-mce"
   * "rc-gadmei-rm008z"
+  * "rc-geekbox"
   * "rc-genius-tvgo-a11mce"
   * "rc-gotview7135"
   * "rc-hauppauge"
-- 
2.11.0

