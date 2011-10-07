Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34394 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1JGPfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:12 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 4/7] libv4l2subdev and libmediactl are not test programs
Date: Fri,  7 Oct 2011 18:38:05 +0300
Message-Id: <1318001888-18689-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call the libraries libraries rather than test programs.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/mediactl.c   |    2 +-
 src/mediactl.h   |    2 +-
 src/v4l2subdev.c |    2 +-
 src/v4l2subdev.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index dc5b022..a03c19a 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -1,5 +1,5 @@
 /*
- * Media controller test application
+ * Media controller interface library
  *
  * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
  *
diff --git a/src/mediactl.h b/src/mediactl.h
index 5627cd7..9ebad9f 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -1,5 +1,5 @@
 /*
- * Media controller test application
+ * Media controller interface library
  *
  * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
  *
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 0b4793d..80365e6 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -1,5 +1,5 @@
 /*
- * Media controller test application
+ * V4L2 subdev interface library
  *
  * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
  *
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index db85491..d9ab692 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -1,5 +1,5 @@
 /*
- * Media controller test application
+ * V4L2 subdev interface library
  *
  * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
  *
-- 
1.7.2.5

