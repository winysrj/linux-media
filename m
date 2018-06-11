Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:47942 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932375AbeFKJlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:41:52 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: increase max width/height to 2592
Date: Mon, 11 Jun 2018 11:41:19 +0200
Message-ID: <1528710079-7944-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DCMI can capture 5Mp raw frames, increase limit accordingly.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 68da9ec..c55e6b5 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -90,14 +90,9 @@ enum state {
 };
 
 #define MIN_WIDTH	16U
-#define MAX_WIDTH	2048U
+#define MAX_WIDTH	2592U
 #define MIN_HEIGHT	16U
-#define MAX_HEIGHT	2048U
-
-#define MIN_JPEG_WIDTH	16U
-#define MAX_JPEG_WIDTH	2592U
-#define MIN_JPEG_HEIGHT	16U
-#define MAX_JPEG_HEIGHT	2592U
+#define MAX_HEIGHT	2592U
 
 #define TIMEOUT_MS	1000
 
@@ -844,14 +839,8 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
 	}
 
 	/* Limit to hardware capabilities */
-	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
-		pix->width = clamp(pix->width, MIN_JPEG_WIDTH, MAX_JPEG_WIDTH);
-		pix->height =
-			clamp(pix->height, MIN_JPEG_HEIGHT, MAX_JPEG_HEIGHT);
-	} else {
-		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
-		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
-	}
+	pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
+	pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
 
 	/* No crop if JPEG is requested */
 	do_crop = dcmi->do_crop && (pix->pixelformat != V4L2_PIX_FMT_JPEG);
-- 
1.9.1
