Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3741 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3KDJ3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 04:29:07 -0500
Message-ID: <527768D9.3010906@xs4all.nl>
Date: Mon, 04 Nov 2013 10:28:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Petter Selasky <hps@bitfrost.no>
Subject: [PATCH] tef6862/radio-tea5764: actually assign clamp result.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding frequency clamping to the tef6862 and radio-tea5764 drivers
I forgot to actually *assign* the clamp result to the frequency.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Hans Petter Selasky <hps@bitfrost.no>
---
 drivers/media/radio/radio-tea5764.c | 2 +-
 drivers/media/radio/tef6862.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 036e2f5..3ed1f56 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -356,7 +356,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		   So we keep it as-is. */
 		return -EINVAL;
 	}
-	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
+	freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
 	tea5764_power_up(radio);
 	tea5764_tune(radio, (freq * 125) / 2);
 	return 0;
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 06ac692..f4bb456 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -112,7 +112,7 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 	if (f->tuner != 0)
 		return -EINVAL;
 
-	clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
+	freq = clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
 	pll = 1964 + ((freq - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
 	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
 	i2cmsg[1] = (pll >> 8) & 0xff;
-- 
1.8.4.2

