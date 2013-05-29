Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3816 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965704Ab3E2LBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>
Subject: [PATCHv1 32/38] sn9c20x: the reg->size field wasn't filled in.
Date: Wed, 29 May 2013 13:00:05 +0200
Message-Id: <1369825211-29770-33-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Brian Johnson <brijohn@gmail.com>
---
 drivers/media/usb/gspca/sn9c20x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 23b71f9..f4453d5 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1557,6 +1557,7 @@ static int sd_dbg_g_register(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
+	reg->size = 1;
 	switch (reg->match.addr) {
 	case 0:
 		if (reg->reg < 0x1000 || reg->reg > 0x11ff)
@@ -1568,6 +1569,7 @@ static int sd_dbg_g_register(struct gspca_dev *gspca_dev,
 		if (sd->sensor >= SENSOR_MT9V011 &&
 		    sd->sensor <= SENSOR_MT9M112) {
 			i2c_r2(gspca_dev, reg->reg, (u16 *) &reg->val);
+			reg->size = 2;
 		} else {
 			i2c_r1(gspca_dev, reg->reg, (u8 *) &reg->val);
 		}
-- 
1.7.10.4

