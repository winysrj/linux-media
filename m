Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47922 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935258AbcJ0OqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:46:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 9378720699
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 13:52:28 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: videodev2: Include linux/time.h for timeval and timespec structs
Date: Thu, 27 Oct 2016 13:50:51 +0300
Message-Id: <1477565451-3621-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct timeval and struct timespec are defined in linux/time.h. Explicitly
include the header if __KERNEL__ is defined.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4364ce6..bbab50c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -61,6 +61,7 @@
 #endif
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
+#include <linux/time.h>
 #include <linux/types.h>
 #include <linux/v4l2-common.h>
 #include <linux/v4l2-controls.h>
-- 
2.7.4

