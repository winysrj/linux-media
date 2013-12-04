Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3LDA41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:27 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 87003363D2
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:38 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/25] v4l: omap4iss: Remove double semicolon at end of line
Date: Wed,  4 Dec 2013 01:56:04 +0100
Message-Id: <1386118585-12449-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 0a7137b..7763b8d 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1039,7 +1039,7 @@ static int iss_video_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct iss_video_fh *vfh = to_iss_video_fh(file->private_data);
 
-	return vb2_mmap(&vfh->queue, vma);;
+	return vb2_mmap(&vfh->queue, vma);
 }
 
 static struct v4l2_file_operations iss_video_fops = {
-- 
1.8.3.2

