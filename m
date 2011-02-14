Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1BNVt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:49:59 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELnxs3007380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:49:59 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1ELnvgE030711
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:49:58 -0500
Date: Mon, 14 Feb 2011 19:49:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/14] [media] cx88: use unlocked_ioctl for cx88-video
Message-ID: <20110214194943.5171fb1b@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cx88-video has locks. don't use the locked ioctl version, as
it is not needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 508dabb..e2fc455 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1672,7 +1672,7 @@ static const struct v4l2_file_operations video_fops =
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1722,7 +1722,7 @@ static const struct v4l2_file_operations radio_fops =
 	.owner         = THIS_MODULE,
 	.open          = video_open,
 	.release       = video_release,
-	.ioctl         = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-- 
1.7.1


