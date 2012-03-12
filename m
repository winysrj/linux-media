Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53766 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2CLOCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 10:02:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH] media: Initialize the media core with subsys_initcall()
Date: Mon, 12 Mar 2012 15:02:47 +0100
Message-Id: <1331560967-32396-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
References: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media-related drivers living outside drivers/media/ (such as the UVC
gadget driver in drivers/usb/gadget/) rely on the media core being
initialized before they're probed. As drivers/usb/ is linked before
drivers/media/, this is currently not the case and will lead to crashes
if the drivers are not compiled as modules.

Register media_devnode_init() as a subsys_initcall() instead of
module_init() to fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-devnode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Bhupesh, do you plan to send a pull request with your "V4L/v4l2-dev: Make
'videodev_init' as a subsys initcall" patch, or would you like me to take it
in my tree ? I'd like both patches to go in at the same time, with this one
coming first to avoid any risk of bisection issue.

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7b42ace..421cf73 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -312,7 +312,7 @@ static void __exit media_devnode_exit(void)
 	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
 }
 
-module_init(media_devnode_init)
+subsys_initcall(media_devnode_init);
 module_exit(media_devnode_exit)
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
-- 
Regards,

Laurent Pinchart

