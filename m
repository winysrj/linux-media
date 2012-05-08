Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2EHQ4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 12:56:19 -0400
Date: Tue, 8 May 2012 18:56:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] V4L: marvell-ccic: (cosmetic) remove redundant variable
 assignment
Message-ID: <Pine.LNX.4.64.1205081853430.7085@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "ret = 0" assignment in mcam_vidioc_s_fmt_vid_cap() is redundant,
because at that location "ret" is anyway guaranteed to be == 0.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 996ac34..ce2b7b4 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1356,7 +1356,6 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 			goto out;
 	}
 	mcam_set_config_needed(cam, 1);
-	ret = 0;
 out:
 	mutex_unlock(&cam->s_mutex);
 	return ret;
-- 
1.7.2.5

