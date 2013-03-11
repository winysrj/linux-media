Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4446 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3CKLq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 21/42] go7007: remove current_norm.
Date: Mon, 11 Mar 2013 12:45:59 +0100
Message-Id: <0e04dd3a9d1d705160e8c2718a2f57d6d5a64836.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's deprecated and replaced by g_std. Since this driver already implements
g_std the use of current_norm can just be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 6f14ac5..b470306 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1834,7 +1834,6 @@ static struct video_device go7007_template = {
 	.release	= go7007_vfl_release,
 	.ioctl_ops	= &video_ioctl_ops,
 	.tvnorms	= V4L2_STD_ALL,
-	.current_norm	= V4L2_STD_NTSC,
 };
 
 int go7007_v4l2_init(struct go7007 *go)
-- 
1.7.10.4

