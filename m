Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1JDTxl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@pobox.com>
Subject: [PATCHv2 5/8] [media] pvrusb2: initialize standards mask before detecting standard
Date: Tue,  4 Oct 2011 16:53:17 -0300
Message-Id: <1317758000-21154-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-4-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
 <1317758000-21154-3-git-send-email-mchehab@redhat.com>
 <1317758000-21154-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 0d029da..ce7ac45 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -230,6 +230,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_QUERYSTD:
 	{
 		v4l2_std_id *std = arg;
+		*std = V4L2_STD_ALL;
 		ret = pvr2_hdw_get_detected_std(hdw, std);
 		break;
 	}
-- 
1.7.6.4

