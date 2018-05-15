Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43282 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbeEOOmq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 10:42:46 -0400
Received: by mail-qt0-f196.google.com with SMTP id f13-v6so530423qtp.10
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 07:42:45 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] mfd: cros_ec_dev: Add CEC sub-device registration
Date: Tue, 15 May 2018 16:42:21 +0200
Message-Id: <1526395342-15481-5-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
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
