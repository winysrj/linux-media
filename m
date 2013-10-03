Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47888 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3JCVtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 17:49:01 -0400
Received: from avalon.ideasonboard.com (191.Red-2-143-34.dynamicIP.rima-tde.net [2.143.34.191])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C01D035A2D
	for <linux-media@vger.kernel.org>; Thu,  3 Oct 2013 23:48:25 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l2-fh: Add forward declaration for struct file
Date: Thu,  3 Oct 2013 23:48:56 +0200
Message-Id: <1380836936-20914-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pointers to struct file are used as function arguments, but the
structure isn't declared. Add a forward declaration.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-fh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index a62ee18..76aeec7 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,6 +28,7 @@
 
 #include <linux/list.h>
 
+struct file;
 struct video_device;
 struct v4l2_ctrl_handler;
 
-- 
Regards,

Laurent Pinchart

