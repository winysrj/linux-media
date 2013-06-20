Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4047 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTNvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:51:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/15] saa6588: remove unused CMD_OPEN.
Date: Thu, 20 Jun 2013 15:44:29 +0200
Message-Id: <1371735871-2658-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa6588.c | 4 ----
 include/media/saa6588.h     | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 54dd7a0..21cf940 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -394,10 +394,6 @@ static long saa6588_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	struct saa6588_command *a = arg;
 
 	switch (cmd) {
-		/* --- open() for /dev/radio --- */
-	case SAA6588_CMD_OPEN:
-		a->result = 0;	/* return error if chip doesn't work ??? */
-		break;
 		/* --- close() for /dev/radio --- */
 	case SAA6588_CMD_CLOSE:
 		s->data_available_for_read = 1;
diff --git a/include/media/saa6588.h b/include/media/saa6588.h
index 2c3c442..1489a52 100644
--- a/include/media/saa6588.h
+++ b/include/media/saa6588.h
@@ -34,7 +34,6 @@ struct saa6588_command {
 };
 
 /* These ioctls are internal to the kernel */
-#define SAA6588_CMD_OPEN	_IOW('R', 1, int)
 #define SAA6588_CMD_CLOSE	_IOW('R', 2, int)
 #define SAA6588_CMD_READ	_IOR('R', 3, int)
 #define SAA6588_CMD_POLL	_IOR('R', 4, int)
-- 
1.8.3.1

