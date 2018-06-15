Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33054 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936250AbeFONTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 09:19:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 3/3] media.h: remove __NEED_MEDIA_LEGACY_API
Date: Fri, 15 Jun 2018 15:19:46 +0200
Message-Id: <20180615131946.79802-4-hverkuil@xs4all.nl>
In-Reply-To: <20180615131946.79802-1-hverkuil@xs4all.nl>
References: <20180615131946.79802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The __NEED_MEDIA_LEGACY_API define is 1) ugly and 2) dangerous
since it is all too easy for drivers to define it to get hold of
legacy defines. Instead just define what we need in media-device.c
which is the only place where we need the legacy define
(MEDIA_ENT_T_DEVNODE_UNKNOWN).

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/media-device.c | 13 ++++++++++---
 include/uapi/linux/media.h   |  2 +-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index ae59c3177555..47bb2254fbfd 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -16,9 +16,6 @@
  * GNU General Public License for more details.
  */
 
-/* We need to access legacy defines from linux/media.h */
-#define __NEED_MEDIA_LEGACY_API
-
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/idr.h>
@@ -35,6 +32,16 @@
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
+/*
+ * Legacy defines from linux/media.h. This is the only place we need this
+ * so we just define it here. The media.h header doesn't expose it to the
+ * kernel to prevent it from being used by drivers, but here (and only here!)
+ * we need it to handle the legacy behavior.
+ */
+#define MEDIA_ENT_SUBTYPE_MASK			0x0000ffff
+#define MEDIA_ENT_T_DEVNODE_UNKNOWN		(MEDIA_ENT_F_OLD_BASE | \
+						 MEDIA_ENT_SUBTYPE_MASK)
+
 /* -----------------------------------------------------------------------------
  * Userspace API
  */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5cba24e..86c7dcc9cba3 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -348,7 +348,7 @@ struct media_v2_topology {
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
 
-#if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
+#ifndef __KERNEL__
 
 /*
  * Legacy symbols used to avoid userspace compilation breakages.
-- 
2.17.0
