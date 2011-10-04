Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1JDTxa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:30 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94JrU8S027652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 4 Oct 2011 15:53:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2 3/8] [media] v4l2-ioctl: Fill the default value for VIDIOC_QUERYSTD
Date: Tue,  4 Oct 2011 16:53:15 -0300
Message-Id: <1317758000-21154-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-2-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According with the V4L2 API spec:

	"When detection is not possible or fails, the set must contain
	 all standards supported by the current video input or output."

The V4L2 core has the mask with all supported standards already. So,
apply it. Driver and subdevs can then just remove standards from the
mask, as they're able of detecting audio, video and frames frequency.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/v4l2-ioctl.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 21c49dc..24fd433 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1109,6 +1109,14 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_querystd)
 			break;
+		/*
+		 * If nothing detected, it should return all supported
+		 * Drivers just need to mask the std argument, in order
+		 * to remove the standards that don't apply from the mask.
+		 * This means that tuners, audio and video decoders can join
+		 * their efforts to improve the standards detection
+		 */
+		*p = vfd->tvnorms;
 		ret = ops->vidioc_querystd(file, fh, arg);
 		if (!ret)
 			dbgarg(cmd, "detected std=%08Lx\n",
-- 
1.7.6.4

