Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4301 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0KPV4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:52 -0500
Message-Id: <0819999d64a0e2c9b092c60602d32e2d7ab7ad25.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:48 +0100
Subject: [RFCv2 PATCH 15/15] cx18: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx18/cx18-streams.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 9045f1e..ab461e2 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -41,7 +41,7 @@ static struct v4l2_file_operations cx18_v4l2_enc_fops = {
 	.read = cx18_v4l2_read,
 	.open = cx18_v4l2_open,
 	/* FIXME change to video_ioctl2 if serialization lock can be removed */
-	.ioctl = cx18_v4l2_ioctl,
+	.unlocked_ioctl = cx18_v4l2_ioctl,
 	.release = cx18_v4l2_close,
 	.poll = cx18_v4l2_enc_poll,
 };
-- 
1.7.0.4

