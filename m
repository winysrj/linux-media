Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3045 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3EaKDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 19/21] radio-sf16fmi: clamp frequency.
Date: Fri, 31 May 2013 12:02:39 +0200
Message-Id: <1369994561-25236-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 80beda7..9cd0338 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -55,8 +55,8 @@ static struct fmi fmi_card;
 static struct pnp_dev *dev;
 bool pnp_attached;
 
-#define RSF16_MINFREQ (87 * 16000)
-#define RSF16_MAXFREQ (108 * 16000)
+#define RSF16_MINFREQ (87U * 16000)
+#define RSF16_MAXFREQ (108U * 16000)
 
 #define FMI_BIT_TUN_CE		(1 << 0)
 #define FMI_BIT_TUN_CLK		(1 << 1)
@@ -155,15 +155,14 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 					const struct v4l2_frequency *f)
 {
 	struct fmi *fmi = video_drvdata(file);
+	unsigned freq = f->frequency;
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	if (f->frequency < RSF16_MINFREQ ||
-			f->frequency > RSF16_MAXFREQ)
-		return -EINVAL;
+	clamp(freq, RSF16_MINFREQ, RSF16_MAXFREQ);
 	/* rounding in steps of 800 to match the freq
 	   that will be used */
-	lm7000_set_freq((f->frequency / 800) * 800, fmi, fmi_set_pins);
+	lm7000_set_freq((freq / 800) * 800, fmi, fmi_set_pins);
 	return 0;
 }
 
-- 
1.7.10.4

