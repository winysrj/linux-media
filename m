Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41696 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0LMLw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 06:52:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH] v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
Date: Mon, 13 Dec 2010 12:53:15 +0100
Message-Id: <1292241195-11915-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The later makes extensive use of structures defined in the former.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-ctrls.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Hans, if you're OK with this patch, can you please apply it to your tree and
push it for 2.6.38 ?

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
Regards,

Laurent Pinchart

