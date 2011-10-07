Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37193 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1JGN1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 09:27:01 -0400
Date: Fri, 7 Oct 2011 16:26:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Staging: cx25821: off by on in cx25821_vidioc_s_input()
Message-ID: <20111007132643.GB31424@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If "i" is 2 then when we call cx25821_video_mux() we'd end up going
past the end of the cx25821_boards[dev->board]->input[].

The INPUT() macro obfuscates what's going on in that function so it's
a bit hard to follow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have this hardware, so I can't actually test this.  Please
review this carefully.

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 084fc08..acd7c4b 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1312,7 +1312,7 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 			return err;
 	}
 
-	if (i > 2) {
+	if (i >= 2) {
 		dprintk(1, "%s(): -EINVAL\n", __func__);
 		return -EINVAL;
 	}
