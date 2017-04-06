Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:10891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757108AbdDFNNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 09:13:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 6/8] v4l: media/drv-intf/soc_mediabus.h: include dependent header file
Date: Thu,  6 Apr 2017 16:12:08 +0300
Message-Id: <1491484330-12040-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media/drv-intf/soc_mediabus.h does depend on struct v4l2_mbus_config which
is defined in media/v4l2-mediabus.h. Include it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/drv-intf/soc_mediabus.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/media/drv-intf/soc_mediabus.h b/include/media/drv-intf/soc_mediabus.h
index 2ff7737..0449788 100644
--- a/include/media/drv-intf/soc_mediabus.h
+++ b/include/media/drv-intf/soc_mediabus.h
@@ -14,6 +14,8 @@
 #include <linux/videodev2.h>
 #include <linux/v4l2-mediabus.h>
 
+#include <media/v4l2-mediabus.h>
+
 /**
  * enum soc_mbus_packing - data packing types on the media-bus
  * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM, one
-- 
2.7.4
