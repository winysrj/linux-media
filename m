Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1A0MbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:31:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v1 3/8] v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
Date: Thu, 27 Jan 2011 13:31:07 +0100
Message-Id: <1296131472-30045-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131472-30045-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1296131472-30045-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The later makes extensive use of structures defined in the former.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-ctrls.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9b7bea9..3b133b7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -23,6 +23,7 @@
 
 #include <linux/list.h>
 #include <linux/device.h>
+#include <linux/videodev2.h>
 
 /* forward references */
 struct v4l2_ctrl_handler;
-- 
1.7.3.4

