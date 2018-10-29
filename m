Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59797 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729613AbeJ2TDe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 15:03:34 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix error handling of kthread_run
Message-ID: <b7aa301d-fab2-03ff-df1e-9d5344134f24@xs4all.nl>
Date: Mon, 29 Oct 2018 11:15:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kthread_run returns an error pointer, but elsewhere in the code dev->kthread_vid_cap/out
is checked against NULL.

If kthread_run returns an error, then set the pointer to NULL.

I chose this method over changing all kthread_vid_cap/out tests elsewhere since this
is more robust.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: syzbot+53d5b2df0d9744411e2e@syzkaller.appspotmail.com
---
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index f06003bb8e42..2a92e5aac9ed 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -865,8 +865,11 @@ int vivid_start_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
 			"%s-vid-cap", dev->v4l2_dev.name);

 	if (IS_ERR(dev->kthread_vid_cap)) {
+		int err = PTR_ERR(dev->kthread_vid_cap);
+
+		dev->kthread_vid_cap = NULL;
 		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
-		return PTR_ERR(dev->kthread_vid_cap);
+		return err;
 	}
 	*pstreaming = true;
 	vivid_grab_controls(dev, true);
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index 9981e7548019..488590594150 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -236,8 +236,11 @@ int vivid_start_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
 			"%s-vid-out", dev->v4l2_dev.name);

 	if (IS_ERR(dev->kthread_vid_out)) {
+		int err = PTR_ERR(dev->kthread_vid_out);
+
+		dev->kthread_vid_out = NULL;
 		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
-		return PTR_ERR(dev->kthread_vid_out);
+		return err;
 	}
 	*pstreaming = true;
 	vivid_grab_controls(dev, true);
