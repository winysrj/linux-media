Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47638 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967516AbeBNLyU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:54:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v4.1 01/14] media: v4l2-ioctl.c: don't copy back the result for -ENOTTY
Date: Wed, 14 Feb 2018 12:54:06 +0100
Message-Id: <20180214115419.28156-2-hverkuil@xs4all.nl>
In-Reply-To: <20180214115419.28156-1-hverkuil@xs4all.nl>
References: <20180214115419.28156-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 181a4a2d5a0a7b43cab08a70710d727e7764ccdd upstream.

If the ioctl returned -ENOTTY, then don't bother copying
back the result as there is no point.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa407cb5f830..7004477e7ffc 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2552,8 +2552,11 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 
 	/* Handles IOCTL */
 	err = func(file, cmd, parg);
-	if (err == -ENOIOCTLCMD)
+	if (err == -ENOTTY || err == -ENOIOCTLCMD) {
 		err = -ENOTTY;
+		goto out;
+	}
+
 	if (err == 0) {
 		if (cmd == VIDIOC_DQBUF)
 			trace_v4l2_dqbuf(video_devdata(file)->minor, parg);
-- 
2.15.1
