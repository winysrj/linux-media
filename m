Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46629 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/16] msi3101: fix overflow in freq setting
Date: Wed,  7 Aug 2013 21:51:44 +0300
Message-Id: <1375901507-26661-14-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 93168db..56f9757 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1507,11 +1507,11 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s: frequency=%u Hz (%d)\n",
-			__func__, f->frequency * 625U / 10U, f->frequency);
+	dev_dbg(&s->udev->dev, "%s: frequency=%lu Hz (%u)\n",
+			__func__, f->frequency * 625UL / 10UL, f->frequency);
 
 	return v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
-			f->frequency * 625U / 10U);
+			f->frequency * 625UL / 10UL);
 }
 
 const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
-- 
1.7.11.7

