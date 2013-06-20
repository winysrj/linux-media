Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3467 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab3FTNpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/15] saa6752hs.h: drop empty header.
Date: Thu, 20 Jun 2013 15:44:26 +0200
Message-Id: <1371735871-2658-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c |  1 -
 include/media/saa6752hs.h                   | 26 --------------------------
 2 files changed, 27 deletions(-)
 delete mode 100644 include/media/saa6752hs.h

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index a0af5c7..0a9047e 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 
-#include <media/saa6752hs.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
 
diff --git a/include/media/saa6752hs.h b/include/media/saa6752hs.h
deleted file mode 100644
index 3b8686e..0000000
--- a/include/media/saa6752hs.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
-    saa6752hs.h - definition for saa6752hs MPEG encoder
-
-    Copyright (C) 2003 Andrew de Quincey <adq@lidskialf.net>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.8.3.1

