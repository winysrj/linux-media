Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:50132 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdH0BaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 21:30:16 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, sean@mess.org,
        jasmin@anw.at
Subject: [PATCH 1/1] build: gpio-ir-tx backport
Date: Sun, 27 Aug 2017 03:30:10 +0200
Message-Id: <1503797410-11860-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1503797410-11860-1-git-send-email-jasmin@anw.at>
References: <1503797410-11860-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- Added v3.16_gpio-ir-tx.patch
- gpio_ir_tx needs 3.13. at least

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt          |  1 +
 backports/v3.16_gpio-ir-tx.patch | 25 +++++++++++++++++++++++++
 v4l/versions.txt                 |  1 +
 3 files changed, 27 insertions(+)
 create mode 100644 backports/v3.16_gpio-ir-tx.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 87b9ee8..22b73a8 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -83,6 +83,7 @@ add v3.17_fix_clamp.patch
 add v3.16_netdev.patch
 add v3.16_wait_on_bit.patch
 add v3.16_void_gpiochip_remove.patch
+add v3.16_gpio-ir-tx.patch
 
 [3.13.255]
 add v3.13_ddbridge_pcimsi.patch
diff --git a/backports/v3.16_gpio-ir-tx.patch b/backports/v3.16_gpio-ir-tx.patch
new file mode 100644
index 0000000..3ec4304
--- /dev/null
+++ b/backports/v3.16_gpio-ir-tx.patch
@@ -0,0 +1,25 @@
+diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
+index cd476ca..f48aba2 100644
+--- a/drivers/media/rc/gpio-ir-tx.c
++++ b/drivers/media/rc/gpio-ir-tx.c
+@@ -136,13 +136,19 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
+ 	if (!rcdev)
+ 		return -ENOMEM;
+ 
+-	gpio_ir->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
++	gpio_ir->gpio = devm_gpiod_get(&pdev->dev, NULL);
+ 	if (IS_ERR(gpio_ir->gpio)) {
+ 		if (PTR_ERR(gpio_ir->gpio) != -EPROBE_DEFER)
+ 			dev_err(&pdev->dev, "Failed to get gpio (%ld)\n",
+ 				PTR_ERR(gpio_ir->gpio));
+ 		return PTR_ERR(gpio_ir->gpio);
+ 	}
++	rc = gpiod_direction_output(gpio_ir->gpio, 0);
++	if (!rc) {
++		dev_err(&pdev->dev, "Failed to set output direction(%d)\n", rc);
++		gpiod_put(gpio_ir->gpio);
++		return rc;
++	}
+ 
+ 	rcdev->priv = gpio_ir;
+ 	rcdev->driver_name = DRIVER_NAME;
diff --git a/v4l/versions.txt b/v4l/versions.txt
index 0c7a3b5..7c54778 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -97,6 +97,7 @@ VIDEO_COBALT
 [3.13.0]
 # needs gpio/consumer.h
 RADIO_SI4713
+IR_GPIO_TX
 
 [3.12.0]
 # BIN_ATTR_RW was changed
-- 
2.7.4
