Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49170 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3ACPpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:45:22 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2001EF3RJLA20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:21 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002B73RD7GA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:21 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/5] s5p-fimc: Avoid possible NULL pointer dereference in
 set_fmt op
Date: Thu, 03 Jan 2013 16:45:06 +0100
Message-id: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes following issue found with a static analysis tool:
Pointer 'ffmt' returned from call to function 'fimc_capture_try_format'
at line 1522 may be NULL and may be dereferenced at line 1535.

Although it shouldn't happen in practice, add the NULL pointer check
to be on the safe side.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 95e6a78..aad0850 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -1561,5 +1561,9 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 		*mf = fmt->format;
 		return 0;
 	}
+	/* There must be a bug in the driver if this happens */
+	if (WARN_ON(ffmt == NULL))
+		return -EINVAL;
+
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);

--
1.7.9.5

