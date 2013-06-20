Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4526 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965495Ab3FTNpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/15] saa6588: after calling CMD_CLOSE, CMD_POLL is broken.
Date: Thu, 20 Jun 2013 15:44:28 +0200
Message-Id: <1371735871-2658-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

CMD_CLOSE sets data_available_for_read to 1, which is necessary to do the
wakeup call, but it is never reset to 0.

Because of this calling CMD_POLL afterwards will always return that data is
available, even if there isn't any.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa6588.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 70bc72e..54dd7a0 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -402,6 +402,7 @@ static long saa6588_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	case SAA6588_CMD_CLOSE:
 		s->data_available_for_read = 1;
 		wake_up_interruptible(&s->read_queue);
+		s->data_available_for_read = 0;
 		a->result = 0;
 		break;
 		/* --- read() for /dev/radio --- */
-- 
1.8.3.1

