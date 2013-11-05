Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 05/29] [media] tef6862: fix warning on avr32 arch
Date: Tue,  5 Nov 2013 08:01:18 -0200
Message-Id: <1383645702-30636-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On avr32 arch, we get those warnings:
	drivers/media/radio/tef6862.c:59:1: warning: "MODE_SHIFT" redefined
	In file included from /devel/v4l/ktest-build/arch/avr32/include/asm/ptrace.h:11,
	arch/avr32/include/uapi/asm/ptrace.h:41:1: warning: this is the location of the previous definition
Prefix MSA_ to the MSA register bitmap macros, to avoid reusing the same symbol.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/radio/tef6862.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 06ac69245ca1..69e3245a58a0 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -48,15 +48,15 @@
 #define WM_SUB_TEST		0xF
 
 /* Different modes of the MSA register */
-#define MODE_BUFFER		0x0
-#define MODE_PRESET		0x1
-#define MODE_SEARCH		0x2
-#define MODE_AF_UPDATE		0x3
-#define MODE_JUMP		0x4
-#define MODE_CHECK		0x5
-#define MODE_LOAD		0x6
-#define MODE_END		0x7
-#define MODE_SHIFT		5
+#define MSA_MODE_BUFFER		0x0
+#define MSA_MODE_PRESET		0x1
+#define MSA_MODE_SEARCH		0x2
+#define MSA_MODE_AF_UPDATE	0x3
+#define MSA_MODE_JUMP		0x4
+#define MSA_MODE_CHECK		0x5
+#define MSA_MODE_LOAD		0x6
+#define MSA_MODE_END		0x7
+#define MSA_MODE_SHIFT		5
 
 struct tef6862_state {
 	struct v4l2_subdev sd;
@@ -114,7 +114,7 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 
 	clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
 	pll = 1964 + ((freq - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
-	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
+	i2cmsg[0] = (MSA_MODE_PRESET << MSA_MODE_SHIFT) | WM_SUB_PLLM;
 	i2cmsg[1] = (pll >> 8) & 0xff;
 	i2cmsg[2] = pll & 0xff;
 
-- 
1.8.3.1

