Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4811 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1HZMAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 7/8] pwc: add support for VIDIOC_LOG_STATUS.
Date: Fri, 26 Aug 2011 14:00:12 +0200
Message-Id: <3d076640f292760cb464668d0dbeae9ddad75be7.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pwc/pwc-v4l.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index d15ae89..bdc369c 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1078,6 +1078,14 @@ static int pwc_enum_frameintervals(struct file *file, void *fh,
 	return 0;
 }
 
+static int pwc_log_status(struct file *file, void *priv)
+{
+	struct pwc_device *pdev = video_drvdata(file);
+
+	v4l2_ctrl_handler_log_status(&pdev->ctrl_handler, PWC_NAME);
+	return 0;
+}
+
 static long pwc_default(struct file *file, void *fh, bool valid_prio,
 			int cmd, void *arg)
 {
@@ -1101,6 +1109,7 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_dqbuf			    = pwc_dqbuf,
 	.vidioc_streamon		    = pwc_streamon,
 	.vidioc_streamoff		    = pwc_streamoff,
+	.vidioc_log_status		    = pwc_log_status,
 	.vidioc_enum_framesizes		    = pwc_enum_framesizes,
 	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
 	.vidioc_default		    = pwc_default,
-- 
1.7.5.4

