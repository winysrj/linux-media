Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86097C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5709820855
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfARIwO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:14 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58374 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfARIwN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:13 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 80DAB5FDAF; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 5/6] media: ov5640: Set JPEG output timings when outputting JPEG data
Date:   Fri, 18 Jan 2019 16:52:05 +0800
Message-Id: <20190118085206.2598-6-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118085206.2598-1-wens@csie.org>
References: <20190118085206.2598-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When compression is turned on, the on-bus data is framed according to
the compression mode, and the height and width set in VFIFO_VSIZE and
VFIFO_HSIZE. If these are not updated correctly, the sensor will send
data framed in a manner unexpected by the capture interface, such as
having more bytes per line than expected, and having the extra data
dropped. This ultimately results in corrupted data.

Set the two values when the media bus is configured for JPEG data,
meaning the sensor would be in JPEG mode.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/i2c/ov5640.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 13311483792c..1c1dc401c678 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -83,6 +83,8 @@
 #define OV5640_REG_SIGMADELTA_CTRL0C	0x3c0c
 #define OV5640_REG_FRAME_CTRL01		0x4202
 #define OV5640_REG_FORMAT_CONTROL00	0x4300
+#define OV5640_REG_VFIFO_HSIZE		0x4602
+#define OV5640_REG_VFIFO_VSIZE		0x4604
 #define OV5640_REG_POLARITY_CTRL00	0x4740
 #define OV5640_REG_MIPI_CTRL00		0x4800
 #define OV5640_REG_DEBUG_MODE		0x4814
@@ -1043,12 +1045,31 @@ static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
 			      (ilog2(pclk_div) << 4));
 }
 
+/* set JPEG framing sizes */
+static int ov5640_set_jpeg_timings(struct ov5640_dev *sensor,
+				   const struct ov5640_mode_info *mode)
+{
+	int ret;
+
+	ret = ov5640_write_reg16(sensor, OV5640_REG_VFIFO_HSIZE, mode->hact);
+	if (ret < 0)
+		return ret;
+
+	return ov5640_write_reg16(sensor, OV5640_REG_VFIFO_VSIZE, mode->vact);
+}
+
 /* download ov5640 settings to sensor through i2c */
 static int ov5640_set_timings(struct ov5640_dev *sensor,
 			      const struct ov5640_mode_info *mode)
 {
 	int ret;
 
+	if (sensor->fmt.code == MEDIA_BUS_FMT_JPEG_1X8) {
+		ret = ov5640_set_jpeg_timings(sensor, mode);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = ov5640_write_reg16(sensor, OV5640_REG_TIMING_DVPHO, mode->hact);
 	if (ret < 0)
 		return ret;
-- 
2.20.1

