Return-path: <mchehab@gaivota>
Received: from mail-out.m-online.net ([212.18.0.9]:57896 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab0LMSTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 13:19:36 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Detlev Zundel <dzu@denx.de>
Subject: [PATCH 1/2] media: saa7115: allow input standard autodetection for SAA7113
Date: Mon, 13 Dec 2010 19:19:36 +0100
Message-Id: <1292264377-31877-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Autodetect input's standard using field frequency detection
feature (FIDT in status byte at 0x1F) of the SAA7113.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/saa7115.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 301c62b..f28a4c7 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1348,6 +1348,18 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	int reg1e;
 
 	*std = V4L2_STD_ALL;
+
+	if (state->ident == V4L2_IDENT_SAA7113) {
+		int reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
+
+		if (reg1f & 0x20)
+			*std = V4L2_STD_NTSC;
+		else
+			*std = V4L2_STD_PAL;
+
+		return 0;
+	}
+
 	if (state->ident != V4L2_IDENT_SAA7115)
 		return 0;
 	reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
-- 
1.7.1

