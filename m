Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36368 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756532AbdDPRgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:36:04 -0400
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 6/7] ov2640: fix vflip control
Date: Sun, 16 Apr 2017 19:35:45 +0200
Message-Id: <20170416173546.4317-7-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enabling vflip currently causes wrong colors.
It seems that (at least with the current sensor setup) REG04_VFLIP_IMG only
changes the vertical readout direction.
Because pixels are arranged RGRG... in odd lines and GBGB... in even lines,
either a one line shift or even/odd line swap is required, too, but
apparently this doesn't happen.

I finally figured out that this can be done manually by setting
REG04_VREF_EN.
Looking at hflip, it turns out that bit REG04_HREF_EN is set there
permanetly, but according to my tests has no effect on the pixel readout
order.
So my conclusion is that the current documentation of sensor register 0x04
is wrong (has changed after preliminary datasheet version 2.2).

I'm pretty sure that automatic vertical line shift/switch can be enabled,
too, but until anyone finds ot how this works, we have to stick with manual
switching.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/media/i2c/ov2640.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 123767c58e83..6aba0ffe486d 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -716,8 +716,10 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		val = ctrl->val ? REG04_VFLIP_IMG : 0x00;
-		return ov2640_mask_set(client, REG04, REG04_VFLIP_IMG, val);
+		val = ctrl->val ? REG04_VFLIP_IMG | REG04_VREF_EN : 0x00;
+		return ov2640_mask_set(client, REG04,
+				       REG04_VFLIP_IMG | REG04_VREF_EN, val);
+		/* NOTE: REG04_VREF_EN: 1 line shift / even/odd line swap */
 	case V4L2_CID_HFLIP:
 		val = ctrl->val ? REG04_HFLIP_IMG : 0x00;
 		return ov2640_mask_set(client, REG04, REG04_HFLIP_IMG, val);
-- 
2.12.2
