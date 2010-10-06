Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab0JFI7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:42 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 90FE835DED
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:39 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/14] uvcvideo: Update e-mail address and copyright notices
Date: Wed,  6 Oct 2010 10:59:44 +0200
Message-Id: <1286355592-13603-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c   |    4 ++--
 drivers/media/video/uvc/uvc_driver.c |    7 ++++---
 drivers/media/video/uvc/uvc_isight.c |    2 +-
 drivers/media/video/uvc/uvc_queue.c  |    4 ++--
 drivers/media/video/uvc/uvc_status.c |    4 ++--
 drivers/media/video/uvc/uvc_v4l2.c   |    4 ++--
 drivers/media/video/uvc/uvc_video.c  |    4 ++--
 7 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index d8dc1e1..e7acf55 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_ctrl.c  --  USB Video Class driver - Controls
  *
- *      Copyright (C) 2005-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2010
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 93d78f6..dc035c0 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_driver.c  --  USB Video Class driver
  *
- *      Copyright (C) 2005-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2010
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
@@ -38,7 +38,8 @@
 
 #include "uvcvideo.h"
 
-#define DRIVER_AUTHOR		"Laurent Pinchart <laurent.pinchart@skynet.be>"
+#define DRIVER_AUTHOR		"Laurent Pinchart " \
+				"<laurent.pinchart@ideasonboard.com>"
 #define DRIVER_DESC		"USB Video Class driver"
 #ifndef DRIVER_VERSION
 #define DRIVER_VERSION		"v0.1.0"
diff --git a/drivers/media/video/uvc/uvc_isight.c b/drivers/media/video/uvc/uvc_isight.c
index a9285b5..74bbe8f 100644
--- a/drivers/media/video/uvc/uvc_isight.c
+++ b/drivers/media/video/uvc/uvc_isight.c
@@ -4,7 +4,7 @@
  *	Copyright (C) 2006-2007
  *		Ivan N. Zlatev <contact@i-nz.net>
  *	Copyright (C) 2008-2009
- *		Laurent Pinchart <laurent.pinchart@skynet.be>
+ *		Laurent Pinchart <laurent.pinchart@ideasonboard.com>
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index e9928a4..d27a315 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_queue.c  --  USB Video Class driver - Buffers management
  *
- *      Copyright (C) 2005-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2010
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
index 85019bd..b749277 100644
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_status.c  --  USB Video Class driver - Status endpoint
  *
- *      Copyright (C) 2007-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2009
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 86db326..8cecd1c 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_v4l2.c  --  USB Video Class driver - V4L2 API
  *
- *      Copyright (C) 2005-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2010
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index ef55877..ee5e233 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -1,8 +1,8 @@
 /*
  *      uvc_video.c  --  USB Video Class driver - Video handling
  *
- *      Copyright (C) 2005-2009
- *          Laurent Pinchart (laurent.pinchart@skynet.be)
+ *      Copyright (C) 2005-2010
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
  *      This program is free software; you can redistribute it and/or modify
  *      it under the terms of the GNU General Public License as published by
-- 
1.7.2.2

