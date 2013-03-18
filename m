Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4493 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3CRQig (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] stk1160: remove V4L2_CHIP_MATCH_AC97 placeholder.
Date: Mon, 18 Mar 2013 17:38:17 +0100
Message-Id: <1363624700-29270-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It was just a placeholder and we want to get rid of the AC97 matching
define.

Also replace MATCH_HOST with MATCH_BRIDGE since we are here anyway.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 5307a63..ef0ca2d 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -458,7 +458,7 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 	       struct v4l2_dbg_chip_ident *chip)
 {
 	switch (chip->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
+	case V4L2_CHIP_MATCH_BRIDGE:
 		chip->ident = V4L2_IDENT_NONE;
 		chip->revision = 0;
 		return 0;
@@ -476,9 +476,6 @@ static int vidioc_g_register(struct file *file, void *priv,
 	u8 val;
 
 	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_AC97:
-		/* TODO: Support me please :-( */
-		return -EINVAL;
 	case V4L2_CHIP_MATCH_I2C_DRIVER:
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
 		return 0;
@@ -505,8 +502,6 @@ static int vidioc_s_register(struct file *file, void *priv,
 	struct stk1160 *dev = video_drvdata(file);
 
 	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_AC97:
-		return -EINVAL;
 	case V4L2_CHIP_MATCH_I2C_DRIVER:
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
 		return 0;
-- 
1.7.10.4

