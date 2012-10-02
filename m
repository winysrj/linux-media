Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39393 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2JBI5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:57:36 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 3/3] fsl-viu: fix compiler warning.
Date: Tue,  2 Oct 2012 10:57:20 +0200
Message-Id: <72ee06310ede2a3f842528fc1ed0025ab15ff8a3.1349168132.git.hans.verkuil@cisco.com>
In-Reply-To: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
References: <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/fsl-viu.c: In function 'vidioc_s_fbuf':
drivers/media/platform/fsl-viu.c:867:32: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]

This is fall-out from this commit:

commit e6eb28c2207b9397d0ab56e238865a4ee95b7ef9
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Tue Sep 4 10:26:45 2012 -0300

    [media] v4l2: make vidioc_s_fbuf const

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 897250b..31ac4dc 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -864,7 +864,7 @@ int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *
 {
 	struct viu_fh  *fh = priv;
 	struct viu_dev *dev = fh->dev;
-	struct v4l2_framebuffer *fb = arg;
+	const struct v4l2_framebuffer *fb = arg;
 	struct viu_fmt *fmt;
 
 	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
-- 
1.7.10.4

