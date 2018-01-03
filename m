Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41476 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeACSX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 13:23:28 -0500
Received: by mail-pg0-f66.google.com with SMTP id 77so984693pgd.8
        for <linux-media@vger.kernel.org>; Wed, 03 Jan 2018 10:23:28 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 3/4] media: mt9m111: document missing required clocks property
Date: Thu,  4 Jan 2018 03:22:46 +0900
Message-Id: <1515003767-12006-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1515003767-12006-1-git-send-email-akinobu.mita@gmail.com>
References: <1515003767-12006-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9m111 driver requires clocks property for the master clock to the
sensor, but there is no description for that.  This adds it.

Cc: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* Changelog v2
- Fix typo s/meida/media/ in the patch title, noticed by Sakari Ailus
- Improve the wording for "clock-names" property, suggested by Sakari Ailus

 Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index ed5a334..6b91003 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -6,6 +6,8 @@ interface.
 
 Required Properties:
 - compatible: value should be "micron,mt9m111"
+- clocks: reference to the master clock.
+- clock-names: shall be "mclk".
 
 For further reading on port node refer to
 Documentation/devicetree/bindings/media/video-interfaces.txt.
@@ -16,6 +18,8 @@ Example:
 		mt9m111@5d {
 			compatible = "micron,mt9m111";
 			reg = <0x5d>;
+			clocks = <&mclk>;
+			clock-names = "mclk";
 
 			remote = <&pxa_camera>;
 			port {
-- 
2.7.4
