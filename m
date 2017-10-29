Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59741 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbdJ2NGI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 09:06:08 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] gspca: remove redundant assignment to variable j
Date: Sun, 29 Oct 2017 13:06:07 +0000
Message-Id: <20171029130607.6062-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable j is being set to zero before a loop and also
immediately inside the loop and is not used after the loop.
Hence the first assignment is redundant and can be removed.
Cleans up clang warning:

drivers/media/usb/gspca/gspca.c:1078:2: warning: Value stored
to 'j' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/gspca/gspca.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 0f141762abf1..961343873fd0 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1075,7 +1075,6 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	/* give an index to each format */
 	index = 0;
-	j = 0;
 	for (i = gspca_dev->cam.nmodes; --i >= 0; ) {
 		fmt_tb[index] = gspca_dev->cam.cam_mode[i].pixelformat;
 		j = 0;
-- 
2.14.1
