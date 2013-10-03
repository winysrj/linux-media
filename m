Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47935 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3JCV7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 17:59:36 -0400
Received: from avalon.ideasonboard.com (191.Red-2-143-34.dynamicIP.rima-tde.net [2.143.34.191])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7DF9C35A47
	for <linux-media@vger.kernel.org>; Thu,  3 Oct 2013 23:58:59 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l2-fh: Include linux/videodev2.h for enum v4l2_priority definition
Date: Thu,  3 Oct 2013 23:59:30 +0200
Message-Id: <1380837570-7515-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct v4l2_fh has an enum v4l2_priority field. Make sure the enum
definition is available by including linux/videodev2.h.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-fh.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 0d92208..528cdaf 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -28,6 +28,7 @@
 
 #include <linux/fs.h>
 #include <linux/list.h>
+#include <linux/videodev2.h>
 
 struct video_device;
 struct v4l2_ctrl_handler;
-- 
Regards,

Laurent Pinchart

