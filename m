Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53250 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcFNUSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 16:18:38 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] v4l2-ioctl.c: fix warning due wrong check in v4l_cropcap()
Date: Tue, 14 Jun 2016 16:18:17 -0400
Message-Id: <1465935497-30002-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 95dd7b7e30f3 ("[media] v4l2-ioctl.c: improve cropcap compatibility
code") tried to check if both .vidioc_cropcap and .vidioc_g_selection are
NULL ops and warn if that was the case, but unfortunately the logic isn't
correct and instead checks for .vidioc_cropcap == NULL twice.

So the v4l2 core will print the following warning if a driver has the ops
.vidioc_g_selection set but no .vidioc_cropcap callback:

WARNING: CPU: 2 PID: 4058 at drivers/media/v4l2-core/v4l2-ioctl.c:2174 v4l_cropcap+0x188/0x198 [videodev]
[<c010e1ac>] (unwind_backtrace) from [<c010af38>] (show_stack+0x10/0x14)
[<c010af38>] (show_stack) from [<c032481c>] (dump_stack+0x88/0x9c)
[<c032481c>] (dump_stack) from [<c011a82c>] (__warn+0xe8/0x100)
[<c011a82c>] (__warn) from [<c011a8f4>] (warn_slowpath_null+0x20/0x28)
[<c011a8f4>] (warn_slowpath_null) from [<bf04a9ec>] (v4l_cropcap+0x188/0x198 [videodev])
[<bf04a9ec>] (v4l_cropcap [videodev]) from [<bf04c728>] (__video_do_ioctl+0x298/0x30c [videodev])
[<bf04c728>] (__video_do_ioctl [videodev]) from [<bf04c110>] (video_usercopy+0x174/0x4e8 [videodev])
[<bf04c110>] (video_usercopy [videodev]) from [<bf0475c8>] (v4l2_ioctl+0xc4/0xd8 [videodev])
[<bf0475c8>] (v4l2_ioctl [videodev]) from [<c01efa78>] (do_vfs_ioctl+0x9c/0x8e4)
[<c01efa78>] (do_vfs_ioctl) from [<c01f02f4>] (SyS_ioctl+0x34/0x5c)
[<c01f02f4>] (SyS_ioctl) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)

Fixes: 95dd7b7e30f3 ("[media] v4l2-ioctl.c: improve cropcap compatibility code")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 28e5be2c2eef..528390f33b53 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2171,7 +2171,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	 * The determine_valid_ioctls() call already should ensure
 	 * that this can never happen, but just in case...
 	 */
-	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
+	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
 		return -ENOTTY;
 
 	if (ops->vidioc_cropcap)
-- 
2.5.5

