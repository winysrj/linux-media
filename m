Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:46440 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTQd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:33:56 -0500
Received: by mail-pf0-f196.google.com with SMTP id c204so12760975pfc.13
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:33:55 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/4] meida: mt9m111: document missing required clocks property
Date: Thu, 21 Dec 2017 01:33:33 +0900
Message-Id: <1513787614-12008-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
References: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9m111 driver requires clocks property for the master clock to the
sensor, but there is no description for that.  This adds it.

Cc: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
index ed5a334..ffb57d1 100644
--- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -6,6 +6,8 @@ interface.
 
 Required Properties:
 - compatible: value should be "micron,mt9m111"
+- clocks: reference to the master clock.
+- clock-names: should be "mclk".
 
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
