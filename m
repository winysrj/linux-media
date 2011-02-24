Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60994 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1BXOjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:39:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 24 Feb 2011 15:33:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/7] s5p-fimc: Prevent oops when i2c adapter is not available
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1298558034-10768-3-git-send-email-s.nawrocki@samsung.com>
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Prevent invalid pointer dereference on error path.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 10d6426..2d8002c 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -98,7 +98,7 @@ static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 			continue;
 
 		sd = fimc_subdev_register(fimc, isp_info);
-		if (sd) {
+		if (!IS_ERR_OR_NULL(sd)) {
 			vid_cap->sd = sd;
 			vid_cap->input_index = i;
 
-- 
1.7.4.1
