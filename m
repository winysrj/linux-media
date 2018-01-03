Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:28411 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752246AbeACJ6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 04:58:39 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v5 1/5] media: ov5640: switch to gpiod_set_value_cansleep()
Date: Wed, 3 Jan 2018 10:57:28 +0100
Message-ID: <1514973452-10464-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch gpiod_set_value to gpiod_set_value_cansleep to avoid
warnings when powering sensor.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index c89ed66..61071f5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1524,7 +1524,7 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 
 static void ov5640_power(struct ov5640_dev *sensor, bool enable)
 {
-	gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
+	gpiod_set_value_cansleep(sensor->pwdn_gpio, enable ? 0 : 1);
 }
 
 static void ov5640_reset(struct ov5640_dev *sensor)
@@ -1532,7 +1532,7 @@ static void ov5640_reset(struct ov5640_dev *sensor)
 	if (!sensor->reset_gpio)
 		return;
 
-	gpiod_set_value(sensor->reset_gpio, 0);
+	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 
 	/* camera power cycle */
 	ov5640_power(sensor, false);
@@ -1540,10 +1540,10 @@ static void ov5640_reset(struct ov5640_dev *sensor)
 	ov5640_power(sensor, true);
 	usleep_range(5000, 10000);
 
-	gpiod_set_value(sensor->reset_gpio, 1);
+	gpiod_set_value_cansleep(sensor->reset_gpio, 1);
 	usleep_range(1000, 2000);
 
-	gpiod_set_value(sensor->reset_gpio, 0);
+	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 	usleep_range(5000, 10000);
 }
 
-- 
1.9.1
