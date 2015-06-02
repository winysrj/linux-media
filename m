Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbbFBTHY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2015 15:07:24 -0400
From: Laura Abbott <labbott@fedoraproject.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laura Abbott <labbott@fedoraproject.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] v4l2-ioctl: Give more information when device_caps are missing
Date: Tue,  2 Jun 2015 12:07:22 -0700
Message-Id: <1433272042-17818-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the warning for missing device_caps gives a backtrace like so:

[<ffffffff8175c199>] dump_stack+0x45/0x57
[<ffffffff8109ad5a>] warn_slowpath_common+0x8a/0xc0
[<ffffffff8109ae8a>] warn_slowpath_null+0x1a/0x20
[<ffffffffa0237453>] v4l_querycap+0x43/0x80 [videodev]
[<ffffffffa0237734>] __video_do_ioctl+0x2a4/0x320 [videodev]
[<ffffffff812207e5>] ? do_last+0x195/0x1210
[<ffffffffa023a11e>] video_usercopy+0x22e/0x5b0 [videodev]
[<ffffffffa0237490>] ? v4l_querycap+0x80/0x80 [videodev]
[<ffffffffa023a4b5>] video_ioctl2+0x15/0x20 [videodev]
[<ffffffffa0233733>] v4l2_ioctl+0x113/0x150 [videodev]
[<ffffffff81225798>] do_vfs_ioctl+0x2f8/0x4f0
[<ffffffff8113b2d4>] ? __audit_syscall_entry+0xb4/0x110
[<ffffffff81022d7c>] ? do_audit_syscall_entry+0x6c/0x70
[<ffffffff81225a11>] SyS_ioctl+0x81/0xa0
[<ffffffff8113b526>] ? __audit_syscall_exit+0x1f6/0x2a0
[<ffffffff81763549>] system_call_fastpath+0x12/0x17

This indicates that device_caps are missing but doesn't give
much of a clue which driver is actually at fault. Improve
the warning output by showing the capabilities and which
operations set the capabilities.

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa407cb..e509608 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1023,8 +1023,9 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 	 * Drivers MUST fill in device_caps, so check for this and
 	 * warn if it was forgotten.
 	 */
-	WARN_ON(!(cap->capabilities & V4L2_CAP_DEVICE_CAPS) ||
-		!cap->device_caps);
+	WARN(!(cap->capabilities & V4L2_CAP_DEVICE_CAPS) ||
+		!cap->device_caps, "Bad caps for ops %pS, %x %x",
+		ops, cap->capabilities, cap->device_caps);
 	cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;
 
 	return ret;
-- 
2.4.1

