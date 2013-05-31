Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3869 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3EaKDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 15/21] tef6862: clamp frequency.
Date: Fri, 31 May 2013 12:02:35 +0200
Message-Id: <1369994561-25236-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clamp the frequency to the valid frequency range as per the V4L2 specification.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/tef6862.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 82c6c94..de2e6db 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -31,8 +31,8 @@
 
 #define FREQ_MUL 16000
 
-#define TEF6862_LO_FREQ (875 * FREQ_MUL / 10)
-#define TEF6862_HI_FREQ (108 * FREQ_MUL)
+#define TEF6862_LO_FREQ (875U * FREQ_MUL / 10)
+#define TEF6862_HI_FREQ (108U * FREQ_MUL)
 
 /* Write mode sub addresses */
 #define WM_SUB_BANDWIDTH	0x0
@@ -105,6 +105,7 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 {
 	struct tef6862_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	unsigned freq = f->frequency;
 	u16 pll;
 	u8 i2cmsg[3];
 	int err;
@@ -112,7 +113,8 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 	if (f->tuner != 0)
 		return -EINVAL;
 
-	pll = 1964 + ((f->frequency - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
+	clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
+	pll = 1964 + ((freq - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
 	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
 	i2cmsg[1] = (pll >> 8) & 0xff;
 	i2cmsg[2] = pll & 0xff;
@@ -121,7 +123,7 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 	if (err != sizeof(i2cmsg))
 		return err < 0 ? err : -EIO;
 
-	state->freq = f->frequency;
+	state->freq = freq;
 	return 0;
 }
 
-- 
1.7.10.4

