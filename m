Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37875 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbeJBOOU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:14:20 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v5 2/6] [media] ad5820: DT new optional field enable-gpios
Date: Tue,  2 Oct 2018 09:32:18 +0200
Message-Id: <20181002073222.11368-2-ricardo.ribalda@gmail.com>
In-Reply-To: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document new enable-gpio field. It can be used to disable the part
without turning down its regulator.

Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/devicetree/bindings/media/i2c/ad5820.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
index 5940ca11c021..9ccd96d3d5f0 100644
--- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
@@ -8,6 +8,12 @@ Required Properties:
 
   - VANA-supply: supply of voltage for VANA pin
 
+Optional properties:
+
+   - enable-gpios : GPIO spec for the XSHUTDOWN pin. Note that the polarity of
+the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the enable
+GPIO deasserts the XSHUTDOWN signal and vice versa).
+
 Example:
 
        ad5820: coil@c {
@@ -15,5 +21,6 @@ Example:
                reg = <0x0c>;
 
                VANA-supply = <&vaux4>;
+               enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
        };
 
-- 
2.19.0
