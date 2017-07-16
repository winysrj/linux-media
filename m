Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39416 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750934AbdGPIPt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 04:15:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pulse8-cec: persistent_config should be off by default
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <0ae20f81-0d11-aa92-a97a-e1c407a53671@xs4all.nl>
Date: Sun, 16 Jul 2017 10:15:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The persistent_config option is used to make the CEC settings persistent by using
the eeprom inside the device to store this information. This was on by default, which
caused confusion since this device now behaves differently from other CEC devices
which all come up unconfigured.

Another reason for doing this now is that I hope a more standard way of selecting
persistent configuration will be created in the future. And for that to work all
CEC drivers should behave the same and come up unconfigured by default.

None of the open source CEC applications are using this CEC framework at the moment
so change this behavior before it is too late.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
---
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index c843070f24c1..f9ed9c950247 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -51,7 +51,7 @@ MODULE_DESCRIPTION("Pulse Eight HDMI CEC driver");
 MODULE_LICENSE("GPL");

 static int debug;
-static int persistent_config = 1;
+static int persistent_config;
 module_param(debug, int, 0644);
 module_param(persistent_config, int, 0644);
 MODULE_PARM_DESC(debug, "debug level (0-1)");
