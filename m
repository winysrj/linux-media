Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48353 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbeEUIzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 01/36] uapi/linux/media.h: add request API
Date: Mon, 21 May 2018 11:54:26 +0300
Message-Id: <20180521085501.16861-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Define the public request API.

This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
and two ioctls that operate on a request in order to queue the
contents of the request to the driver and to re-initialize the
request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/media.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c7e9a5cba24ed..32883d4d22b22 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -342,11 +342,23 @@ struct media_v2_topology {
 
 /* ioctls */
 
+struct __attribute__ ((packed)) media_request_alloc {
+	__s32 fd;
+};
+
 #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
+
+/*
+ * These ioctls are called from the request file descriptor as returned
+ * by MEDIA_IOC_REQUEST_ALLOC.
+ */
+#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
+#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
 
 #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
 
-- 
2.11.0
