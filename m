Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725757AbeKOFJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 00:09:48 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: v4l: constify v4l2_ioctls[]
Date: Wed, 14 Nov 2018 11:04:49 -0800
Message-Id: <20181114190449.259520-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

v4l2_ioctls[] is never modified, so mark it 'const'.
This way it gets placed in .rodata.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c63746968fa3d..fc23455820336 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2586,7 +2586,7 @@ DEFINE_V4L_STUB_FUNC(enum_dv_timings)
 DEFINE_V4L_STUB_FUNC(query_dv_timings)
 DEFINE_V4L_STUB_FUNC(dv_timings_cap)
 
-static struct v4l2_ioctl_info v4l2_ioctls[] = {
+static const struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
 	IOCTL_INFO(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
 	IOCTL_INFO(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, 0),
-- 
2.19.1.930.g4563a0d9d0-goog
