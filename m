Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34834 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdJ0QUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 12:20:12 -0400
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] radio-raremono: remove redundant initialization of freq
Date: Fri, 27 Oct 2017 17:20:08 +0100
Message-Id: <20171027162008.13749-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable freq is initialized to f->frequency however this value
is never read and freq is later updated; hence the initialization
is redundant and can be removed.

Cleans up clang warning:
drivers/media/radio/radio-raremono.c:257:6: warning: Value stored
to 'freq' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/radio/radio-raremono.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/radio-raremono.c
index 3c0a22a54113..70a2c86774ce 100644
--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -254,7 +254,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
 	struct raremono_device *radio = video_drvdata(file);
-	u32 freq = f->frequency;
+	u32 freq;
 	unsigned band;
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-- 
2.14.1
