Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:62663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0L0LlL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:41:11 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBfBYw014371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:41:11 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iO001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:41:09 -0500
Date: Mon, 27 Dec 2010 09:38:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] [media] omap_vout: Remove an obsolete comment
Message-ID: <20101227093829.4a5d60ca@gaivota>
In-Reply-To: <cover.1293449547.git.mchehab@redhat.com>
References: <cover.1293449547.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This comment mentions a field that doesn't exist, and talks about
videodev.h that got removed. So, it doesn't make any sense to keep
it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 15f8793..83de97a 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2230,7 +2230,6 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 
 	strlcpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
 
-	/* need to register for a VID_HARDWARE_* ID in videodev.h */
 	vfd->fops = &omap_vout_fops;
 	vfd->v4l2_dev = &vout->vid_dev->v4l2_dev;
 	mutex_init(&vout->lock);
-- 
1.7.3.4

