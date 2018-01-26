Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44920 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751906AbeAZMna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 07:43:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] v4l2-compat-ioctl32.c: don't copy back the result for certain errors
Date: Fri, 26 Jan 2018 13:43:26 +0100
Message-Id: <20180126124327.16653-12-hverkuil@xs4all.nl>
In-Reply-To: <20180126124327.16653-1-hverkuil@xs4all.nl>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some ioctls need to copy back the result even if the ioctl returned
an error. However, don't do this for the error codes -ENOTTY, -EFAULT
and -ENOIOCTLCMD. It makes no sense in those cases.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 790473b45a21..2aa9b43daf60 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -966,6 +966,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		set_fs(old_fs);
 	}
 
+	if (err == -ENOTTY || err == -EFAULT || err == -ENOIOCTLCMD)
+		return err;
+
 	/* Special case: even after an error we need to put the
 	   results back for these ioctls since the error_idx will
 	   contain information on which control failed. */
-- 
2.15.1
