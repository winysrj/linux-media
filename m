Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43209 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbeC1SNS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:13:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH for v3.18 18/18] media: v4l2-compat-ioctl32: initialize a reserved field
Date: Wed, 28 Mar 2018 15:12:37 -0300
Message-Id: <d8a647b26822fb0a86f6ee7dff4d6eb1e85e1398.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The get_v4l2_create32() function is missing a logic with
would be cleaning a reserved field, causing v4l2-compliance
to complain:

 Buffer ioctls (Input 0):
		fail: v4l2-test-buffers.cpp(506): check_0(crbufs.reserved, sizeof(crbufs.reserved))
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index c76438dd3ead..ca0a43ad4ec8 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -247,7 +247,8 @@ static int get_v4l2_create32(struct v4l2_create_buffers __user *kp,
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
 	    copy_in_user(kp, up,
-			 offsetof(struct v4l2_create_buffers32, format)))
+			 offsetof(struct v4l2_create_buffers32, format)) ||
+	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
 		return -EFAULT;
 	return __get_v4l2_format32(&kp->format, &up->format,
 				   aux_buf, aux_space);
-- 
2.14.3
