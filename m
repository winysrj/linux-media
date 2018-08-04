Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48574 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727592AbeHDOqI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:46:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv17 02/34] uapi/linux/media.h: add request API
Date: Sat,  4 Aug 2018 14:44:54 +0200
Message-Id: <20180804124526.46206-3-hverkuil@xs4all.nl>
In-Reply-To: <20180804124526.46206-1-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Define the public request API.

This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
and two ioctls that operate on a request in order to queue the
contents of the request to the driver and to re-initialize the
request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/uapi/linux/media.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 36f76e777ef9..cf77f00a0f2d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -364,11 +364,23 @@ struct media_v2_topology {
 
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
+ * These ioctls are called on the request file descriptor as returned
+ * by MEDIA_IOC_REQUEST_ALLOC.
+ */
+#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
+#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
 
 #ifndef __KERNEL__
 
-- 
2.18.0
