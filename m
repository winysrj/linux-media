Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9512 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab1FBKN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:13:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 02 Jun 2011 12:12:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/7] s5p-fimc: Use pix_mp for the color format lookup
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307009524-1208-7-git-send-email-s.nawrocki@samsung.com>
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With multi-planar formats fmt.pix_mp member of struct v4l2_format
should be used rather than fmt.pix. Fix find_fmt() function to do
the right thing.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 85b47a3..873a879 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -841,7 +841,7 @@ struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask)
 
 	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
 		fmt = &fimc_formats[i];
-		if (fmt->fourcc == f->fmt.pix.pixelformat &&
+		if (fmt->fourcc == f->fmt.pix_mp.pixelformat &&
 		   (fmt->flags & mask))
 			break;
 	}
-- 
1.7.5.2

