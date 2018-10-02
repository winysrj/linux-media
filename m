Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41846 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbeJBOOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:14:25 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v5 5/6] [media] ad5820: DT new compatible devices
Date: Tue,  2 Oct 2018 09:32:21 +0200
Message-Id: <20181002073222.11368-5-ricardo.ribalda@gmail.com>
In-Reply-To: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document new compatible devices.

Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/i2c/ad5820.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
index 9ccd96d3d5f0..cc7b10fe0368 100644
--- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
@@ -2,7 +2,10 @@
 
 Required Properties:
 
-  - compatible: Must contain "adi,ad5820"
+  - compatible: Must contain one of:
+		- "adi,ad5820"
+		- "adi,ad5821"
+		- "adi,ad5823"
 
   - reg: I2C slave address
 
-- 
2.19.0
