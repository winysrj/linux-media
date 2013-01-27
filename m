Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:47033 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:53 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 5/7] saa7134: v4l2-compliance: fix g_tuner/s_tuner
Date: Sun, 27 Jan 2013 20:45:10 +0100
Message-Id: <1359315912-1767-6-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: return real frequency range in
g_tuner and fail in s_tuner for non-zero tuner

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 87b2b9e..0b42f0c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2011,11 +2011,11 @@ static int saa7134_g_tuner(struct file *file, void *priv,
 	if (NULL != card_in(dev, n).name) {
 		strcpy(t->name, "Television");
 		t->type = V4L2_TUNER_ANALOG_TV;
+		saa_call_all(dev, tuner, g_tuner, t);
 		t->capability = V4L2_TUNER_CAP_NORM |
 			V4L2_TUNER_CAP_STEREO |
 			V4L2_TUNER_CAP_LANG1 |
 			V4L2_TUNER_CAP_LANG2;
-		t->rangehigh = 0xffffffffUL;
 		t->rxsubchans = saa7134_tvaudio_getstereo(dev);
 		t->audmode = saa7134_tvaudio_rx2mode(t->rxsubchans);
 	}
@@ -2031,6 +2031,9 @@ static int saa7134_s_tuner(struct file *file, void *priv,
 	struct saa7134_dev *dev = fh->dev;
 	int rx, mode;
 
+	if (0 != t->index)
+		return -EINVAL;
+
 	mode = dev->thread.mode;
 	if (UNSET == mode) {
 		rx   = saa7134_tvaudio_getstereo(dev);
-- 
Ondrej Zary

