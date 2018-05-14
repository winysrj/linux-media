Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:40856 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbeENWkq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 18:40:46 -0400
Received: by mail-lf0-f67.google.com with SMTP id p85-v6so20404544lfg.7
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 15:40:45 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/5] mfd: cros_ec_dev: Add CEC sub-device registration
Date: Tue, 15 May 2018 00:40:35 +0200
Message-Id: <1526337639-3568-2-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
when the CEC feature bit is present.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index eafd06f..57064ec 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -383,6 +383,18 @@ static void cros_ec_sensors_register(struct cros_ec_dev *ec)
 	kfree(msg);
 }
 
+static void cros_ec_cec_register(struct cros_ec_dev *ec)
+{
+	int ret;
+	struct mfd_cell cec_cell = {
+		.name = "cros-ec-cec",
+	};
+
+	ret = mfd_add_devices(ec->dev, 0, &cec_cell, 1, NULL, 0, NULL);
+	if (ret)
+		dev_err(ec->dev, "failed to add EC CEC\n");
+}
+
 static int ec_device_probe(struct platform_device *pdev)
 {
 	int retval = -ENOMEM;
@@ -422,6 +434,10 @@ static int ec_device_probe(struct platform_device *pdev)
 	if (cros_ec_check_features(ec, EC_FEATURE_MOTION_SENSE))
 		cros_ec_sensors_register(ec);
 
+	/* check whether this EC handles CEC. */
+	if (cros_ec_check_features(ec, EC_FEATURE_CEC))
+		cros_ec_cec_register(ec);
+
 	/* Take control of the lightbar from the EC. */
 	lb_manual_suspend_ctrl(ec, 1);
 
-- 
2.7.4
