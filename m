Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35033 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZJZLOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 07:14:00 -0400
Received: by ewy4 with SMTP id 4so3470101ewy.37
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 04:14:04 -0700 (PDT)
Message-ID: <4AE586F2.9060501@gmail.com>
Date: Mon, 26 Oct 2009 12:24:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, m-karicheri2@ti.com
Subject: [PATCH] V4L/DVB: keep index within bound in vpfe_cropcap()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If vpfe_dev->std_index equals ARRAY_SIZE(vpfe_standards), that is
one too large

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 402ce43..6b31e59 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1577,7 +1577,7 @@ static int vpfe_cropcap(struct file *file, void *priv,
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
 
-	if (vpfe_dev->std_index > ARRAY_SIZE(vpfe_standards))
+	if (vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
 		return -EINVAL;
 
 	memset(crop, 0, sizeof(struct v4l2_cropcap));
