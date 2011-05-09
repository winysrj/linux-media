Return-path: <mchehab@gaivota>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:43782 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab1EITyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:16 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 13/16] tm6000: change from ioctl to unlocked_ioctl
Date: Mon,  9 May 2011 21:54:01 +0200
Message-Id: <1304970844-20955-13-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

change from ioctl to unlocked_ioctl


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index ea5ad6c..2d83204 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1666,10 +1666,10 @@ static struct video_device tm6000_template = {
 };
 
 static const struct v4l2_file_operations radio_fops = {
-	.owner	  = THIS_MODULE,
-	.open	  = tm6000_open,
-	.release  = tm6000_release,
-	.ioctl	  = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= tm6000_open,
+	.release	= tm6000_release,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-- 
1.7.4.2

