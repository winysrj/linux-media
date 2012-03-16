Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56081 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162056Ab2CPXgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:21 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 7/7] marvell-cam: Demote the "release" print to debug level
Date: Fri, 16 Mar 2012 17:14:56 -0600
Message-Id: <1331939696-12482-8-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We've spammed enough logfiles at this point.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 036db27..996ac34 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1567,7 +1567,7 @@ static int mcam_v4l_release(struct file *filp)
 {
 	struct mcam_camera *cam = filp->private_data;
 
-	cam_err(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
+	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n", frames,
 			singles, delivered);
 	mutex_lock(&cam->s_mutex);
 	(cam->users)--;
-- 
1.7.9.3

