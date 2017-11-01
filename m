Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64333 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933304AbdKAVGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 07/26] media: radio-si476x: fix behavior when seek->range* are defined
Date: Wed,  1 Nov 2017 17:05:44 -0400
Message-Id: <719a45638261947315e47bf7cd8743f7f4f513a1.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at si476x_radio_s_hw_freq_seek() checks if the
frequency range that will be used to handle hardware seek
has the minimal frequency under rangelow. That works fine
if userspace zeros both fields. However, if userspace
fills either seek->rangelow or seek-rangehigh, it won't
read the corresponding range from the device, causing the
values to be unitialized, as warned by smatch:

	drivers/media/radio/radio-si476x.c:789 si476x_radio_s_hw_freq_seek() error: uninitialized symbol 'rangelow'.
	drivers/media/radio/radio-si476x.c:789 si476x_radio_s_hw_freq_seek() error: uninitialized symbol 'rangehigh'.

Fix it by initializing those vars from the values present at
the struct v4l2_hw_freq_seek.

While here, simplify the logic which reads such values from
the hardware limits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/radio-si476x.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 271f725b17e8..740714d9dd85 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -755,7 +755,7 @@ static int si476x_radio_s_hw_freq_seek(struct file *file, void *priv,
 {
 	int err;
 	enum si476x_func func;
-	u32 rangelow, rangehigh;
+	u32 rangelow = seek->rangelow, rangehigh = seek->rangehigh;
 	struct si476x_radio *radio = video_drvdata(file);
 
 	if (file->f_flags & O_NONBLOCK)
@@ -767,23 +767,21 @@ static int si476x_radio_s_hw_freq_seek(struct file *file, void *priv,
 
 	si476x_core_lock(radio->core);
 
-	if (!seek->rangelow) {
+	if (!rangelow) {
 		err = regmap_read(radio->core->regmap,
 				  SI476X_PROP_SEEK_BAND_BOTTOM,
 				  &rangelow);
-		if (!err)
-			rangelow = si476x_to_v4l2(radio->core, rangelow);
-		else
+		if (err)
 			goto unlock;
+		rangelow = si476x_to_v4l2(radio->core, rangelow);
 	}
-	if (!seek->rangehigh) {
+	if (!rangehigh) {
 		err = regmap_read(radio->core->regmap,
 				  SI476X_PROP_SEEK_BAND_TOP,
 				  &rangehigh);
-		if (!err)
-			rangehigh = si476x_to_v4l2(radio->core, rangehigh);
-		else
+		if (err)
 			goto unlock;
+		rangehigh = si476x_to_v4l2(radio->core, rangehigh);
 	}
 
 	if (rangelow > rangehigh) {
-- 
2.13.6
