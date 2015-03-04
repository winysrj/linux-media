Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbbCDUNd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 15:13:33 -0500
From: Masatake YAMATO <yamato@redhat.com>
To: linux-media@vger.kernel.org
Cc: yamato@redhat.com
Subject: [PATCH] am437x: include linux/videodev2.h for expanding BASE_VIDIOC_PRIVATE
Date: Thu,  5 Mar 2015 05:13:24 +0900
Message-Id: <1425500004-17467-1-git-send-email-yamato@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In am437x-vpfe.h BASE_VIDIOC_PRIVATE is used for
making the name of ioctl command(VIDIOC_AM437X_CCDC_CFG).
The definition of BASE_VIDIOC_PRIVATE is in linux/videodev2.h.
However, linux/videodev2.h is not included in am437x-vpfe.h.
As the result an application using has to include both
am437x-vpfe.h and linux/videodev2.h.

With this patch, the application can include just am437x-vpfe.h.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 include/uapi/linux/am437x-vpfe.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/am437x-vpfe.h b/include/uapi/linux/am437x-vpfe.h
index 9b03033f..d757743 100644
--- a/include/uapi/linux/am437x-vpfe.h
+++ b/include/uapi/linux/am437x-vpfe.h
@@ -21,6 +21,8 @@
 #ifndef AM437X_VPFE_USER_H
 #define AM437X_VPFE_USER_H
 
+#include <linux/videodev2.h>
+
 enum vpfe_ccdc_data_size {
 	VPFE_CCDC_DATA_16BITS = 0,
 	VPFE_CCDC_DATA_15BITS,
-- 
2.1.0

