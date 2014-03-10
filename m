Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaCJXOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 30/48] adv7604: Don't put info string arrays on the stack
Date: Tue, 11 Mar 2014 00:15:41 +0100
Message-Id: <1394493359-14115-31-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lars-Peter Clausen <lars@metafoo.de>

We do not want to modify the info string arrays ever, so no need to
waste stack space for them. While we are at it also make them const.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c3a76ac..81d737c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1882,13 +1882,13 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	struct stdi_readback stdi;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
 
-	char *csc_coeff_sel_rb[16] = {
+	static const char * const csc_coeff_sel_rb[16] = {
 		"bypassed", "YPbPr601 -> RGB", "reserved", "YPbPr709 -> RGB",
 		"reserved", "RGB -> YPbPr601", "reserved", "RGB -> YPbPr709",
 		"reserved", "YPbPr709 -> YPbPr601", "YPbPr601 -> YPbPr709",
 		"reserved", "reserved", "reserved", "reserved", "manual"
 	};
-	char *input_color_space_txt[16] = {
+	static const char * const input_color_space_txt[16] = {
 		"RGB limited range (16-235)", "RGB full range (0-255)",
 		"YCbCr Bt.601 (16-235)", "YCbCr Bt.709 (16-235)",
 		"xvYCC Bt.601", "xvYCC Bt.709",
@@ -1896,12 +1896,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 		"invalid", "invalid", "invalid", "invalid", "invalid",
 		"invalid", "invalid", "automatic"
 	};
-	char *rgb_quantization_range_txt[] = {
+	static const char * const rgb_quantization_range_txt[] = {
 		"Automatic",
 		"RGB limited range (16-235)",
 		"RGB full range (0-255)",
 	};
-	char *deep_color_mode_txt[4] = {
+	static const char * const deep_color_mode_txt[4] = {
 		"8-bits per channel",
 		"10-bits per channel",
 		"12-bits per channel",
-- 
1.8.3.2

