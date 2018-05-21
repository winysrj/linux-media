Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38233 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbeEUOV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:21:57 -0400
Received: by mail-wm0-f66.google.com with SMTP id m129-v6so26832526wmb.3
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 07:21:57 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, eballetbo@gmail.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] mfd: cros_ec_dev: Add CEC sub-device registration
Date: Mon, 21 May 2018 16:21:45 +0200
Message-Id: <1526912506-18406-5-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1526912506-18406-1-git-send-email-narmstrong@baylibre.com>
References: <1526912506-18406-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
when the CEC feature bit is present.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 1d6dc5c..272969e 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -383,6 +383,10 @@ static void cros_ec_sensors_register(struct cros_ec_dev *ec)
 	kfree(msg);
 }
 
+static const struct mfd_cell cros_ec_cec_cells[] = {
+	{ .name = "cros-ec-cec" }
+};
+
 static const struct mfd_cell cros_ec_rtc_cells[] = {
 	{ .name = "cros-ec-rtc" }
 };
@@ -426,6 +430,18 @@ static int ec_device_probe(struct platform_device *pdev)
 	if (cros_ec_check_features(ec, EC_FEATURE_MOTION_SENSE))
 		cros_ec_sensors_register(ec);
 
+	/* Check whether this EC instance has CEC host command support */
+	if (cros_ec_check_features(ec, EC_FEATURE_CEC)) {
+		retval = mfd_add_devices(ec->dev, PLATFORM_DEVID_AUTO,
+					 cros_ec_cec_cells,
+					 ARRAY_SIZE(cros_ec_cec_cells),
+					 NULL, 0, NULL);
+		if (retval)
+			dev_err(ec->dev,
+				"failed to add cros-ec-cec device: %d\n",
+				retval);
+	}
+
 	/* Check whether this EC instance has RTC host command support */
 	if (cros_ec_check_features(ec, EC_FEATURE_RTC)) {
 		retval = mfd_add_devices(ec->dev, PLATFORM_DEVID_AUTO,
-- 
2.7.4
