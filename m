Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550Ab1JDTxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94JrUQG011003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 4 Oct 2011 15:53:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2 4/8] [media] saa7115: Trust that V4L2 core will fill the mask
Date: Tue,  4 Oct 2011 16:53:16 -0300
Message-Id: <1317758000-21154-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-3-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
 <1317758000-21154-3-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using V4L2_STD_ALL when no standard is detected,
trust that the maximum allowed standards are already filled by
the V4L2 core. It is better this way, as the bridge and/or the audio
decoder may have some extra restrictions to some video standards.

This also allow other devices like audio and tuners to contribute to
standards detection, when they support such feature.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/saa7115.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 86627a8..5cfdbc7 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1346,17 +1346,23 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	struct saa711x_state *state = to_state(sd);
 	int reg1f, reg1e;
 
+	/*
+	 * The V4L2 core already initializes std with all supported
+	 * Standards. All driver needs to do is to mask it, to remove
+	 * standards that don't apply from the mask
+	 */
+
 	reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
 	v4l2_dbg(1, debug, sd, "Status byte 2 (0x1f)=0x%02x\n", reg1f);
-	if (reg1f & 0x40) {
-		/* horizontal/vertical not locked */
-		*std = V4L2_STD_ALL;
+
+	/* horizontal/vertical not locked */
+	if (reg1f & 0x40)
 		goto ret;
-	}
+
 	if (reg1f & 0x20)
-		*std = V4L2_STD_525_60;
+		*std &= V4L2_STD_525_60;
 	else
-		*std = V4L2_STD_625_50;
+		*std &= V4L2_STD_625_50;
 
 	if (state->ident != V4L2_IDENT_SAA7115)
 		goto ret;
@@ -1381,7 +1387,6 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 		break;
 	default:
 		/* Can't detect anything */
-		*std = V4L2_STD_ALL;
 		break;
 	}
 
-- 
1.7.6.4

