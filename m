Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0JDT2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 15:28:19 -0400
Date: Mon, 4 Oct 2010 21:28:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: saa7134: add test after for loop
Message-ID: <20101004192801.GG5692@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a check after the for loops to see if we found what we were looking
for or if we reached the end of the list.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 45f0ac8..24c3a78 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1871,9 +1871,12 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 			else
 				fixup = V4L2_STD_SECAM;
 		}
-		for (i = 0; i < TVNORMS; i++)
+		for (i = 0; i < TVNORMS; i++) {
 			if (fixup == tvnorms[i].id)
 				break;
+		}
+		if (i == TVNORMS)
+			return -EINVAL;
 	}
 
 	*id = tvnorms[i].id;
@@ -1997,9 +2000,12 @@ static int saa7134_g_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 	memset(t, 0, sizeof(*t));
-	for (n = 0; n < SAA7134_INPUT_MAX; n++)
+	for (n = 0; n < SAA7134_INPUT_MAX; n++) {
 		if (card_in(dev, n).tv)
 			break;
+	}
+	if (n == SAA7134_INPUT_MAX)
+		return -EINVAL;
 	if (NULL != card_in(dev, n).name) {
 		strcpy(t->name, "Television");
 		t->type = V4L2_TUNER_ANALOG_TV;
