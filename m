Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2255 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab1F1L0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/13] v4l2-framework.txt: updated v4l2_fh_init documentation.
Date: Tue, 28 Jun 2011 13:26:01 +0200
Message-Id: <d67715183a6748170f21e9ebb89e954e6228912e.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l2_fh_init now returns void instead of int, updated the doc.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index cf21f7a..312a0e2 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -817,11 +817,7 @@ int my_open(struct file *file)
 
 	...
 
-	ret = v4l2_fh_init(&my_fh->fh, vfd);
-	if (ret) {
-		kfree(my_fh);
-		return ret;
-	}
+	v4l2_fh_init(&my_fh->fh, vfd);
 
 	...
 
@@ -844,7 +840,7 @@ int my_release(struct file *file)
 
 Below is a short description of the v4l2_fh functions used:
 
-int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 
   Initialise the file handle. This *MUST* be performed in the driver's
   v4l2_file_operations->open() handler.
-- 
1.7.1

