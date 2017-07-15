Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38176 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751182AbdGOVrn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 17:47:43 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pulse8-cec/rainshadow-cec: make adapter name unique
Message-ID: <d945e72e-8008-7249-3973-612eff60b66d@xs4all.nl>
Date: Sat, 15 Jul 2017 23:47:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC adapter name used by the pulse8-cec and rainshadow-cec USB device drivers
was a fixed string, but it should be unique if you connect multiple of these devices
to the same computer.

Use dev_name(&serio->dev) instead, which make it unique again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index c843070f24c1..e29d43237046 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -656,7 +656,7 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)

 	pulse8->serio = serio;
 	pulse8->adap = cec_allocate_adapter(&pulse8_cec_adap_ops, pulse8,
-		"HDMI CEC", caps, 1);
+					    dev_name(&serio->dev), caps, 1);
 	err = PTR_ERR_OR_ZERO(pulse8->adap);
 	if (err < 0)
 		goto free_device;
diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index f203699e9c1b..7e80eefdf604 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -325,7 +325,7 @@ static int rain_connect(struct serio *serio, struct serio_driver *drv)

 	rain->serio = serio;
 	rain->adap = cec_allocate_adapter(&rain_cec_adap_ops, rain,
-		"HDMI CEC", caps, 1);
+					  dev_name(&serio->dev), caps, 1);
 	err = PTR_ERR_OR_ZERO(rain->adap);
 	if (err < 0)
 		goto free_device;
