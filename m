Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58803 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934459AbeF2Qm7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 12:42:59 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 2/2] media: i2c: ov5640: Remove start/stop sequence
Date: Fri, 29 Jun 2018 18:42:40 +0200
Message-Id: <1530290560-25806-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacopo Mondi <jacopo@jmondi.org>

Now that data and clock lanes start in LP11 no need to issue a start/stop
sequence at power on time to 'coax the lanes in LP11 state'.

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/ov5640.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 465acce..96d0203 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1796,20 +1796,6 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
 		if (ret)
 			goto power_off;
 
-		if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
-			/*
-			 * start streaming briefly followed by stream off in
-			 * order to coax the clock lane into LP-11 state.
-			 */
-			ret = ov5640_set_stream_mipi(sensor, true);
-			if (ret)
-				goto power_off;
-			usleep_range(1000, 2000);
-			ret = ov5640_set_stream_mipi(sensor, false);
-			if (ret)
-				goto power_off;
-		}
-
 		return 0;
 	}
 
-- 
2.7.4
