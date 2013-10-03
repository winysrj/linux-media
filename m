Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47919 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3JCVz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 17:55:58 -0400
Received: from avalon.ideasonboard.com (191.Red-2-143-34.dynamicIP.rima-tde.net [2.143.34.191])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D5FE35A47
	for <linux-media@vger.kernel.org>; Thu,  3 Oct 2013 23:55:20 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l2-fh: Include linux/fs.h for struct file definition
Date: Thu,  3 Oct 2013 23:55:52 +0200
Message-Id: <1380837352-29950-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-fh.h dereferences struct file, the structure must thus be defined.
Pull in its definition by including linux/fs.h.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-fh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index a62ee18..0d92208 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -26,6 +26,7 @@
 #ifndef V4L2_FH_H
 #define V4L2_FH_H
 
+#include <linux/fs.h>
 #include <linux/list.h>
 
 struct video_device;
-- 
Regards,

Laurent Pinchart

