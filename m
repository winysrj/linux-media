Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab2HGQm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:59 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 10/11] saa7127: use %*ph to print small buffers
Date: Tue,  7 Aug 2012 19:43:10 +0300
Message-Id: <1344357792-18202-10-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/saa7127.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/video/saa7127.c b/drivers/media/video/saa7127.c
index 39c90b0..8ecb656 100644
--- a/drivers/media/video/saa7127.c
+++ b/drivers/media/video/saa7127.c
@@ -364,10 +364,7 @@ static int saa7127_set_vps(struct v4l2_subdev *sd, const struct v4l2_sliced_vbi_
 	state->vps_data[2] = data->data[9];
 	state->vps_data[3] = data->data[10];
 	state->vps_data[4] = data->data[11];
-	v4l2_dbg(1, debug, sd, "Set VPS data %02x %02x %02x %02x %02x\n",
-		state->vps_data[0], state->vps_data[1],
-		state->vps_data[2], state->vps_data[3],
-		state->vps_data[4]);
+	v4l2_dbg(1, debug, sd, "Set VPS data %*ph\n", 5, state->vps_data);
 	saa7127_write(sd, 0x55, state->vps_data[0]);
 	saa7127_write(sd, 0x56, state->vps_data[1]);
 	saa7127_write(sd, 0x57, state->vps_data[2]);
-- 
1.7.10.4

