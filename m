Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4233 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754048AbdCILz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 06:55:26 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id B26472071E
        for <linux-media@vger.kernel.org>; Thu,  9 Mar 2017 13:54:52 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Document the practice of symmetrically calling s_power(dev, 0/1)
Date: Thu,  9 Mar 2017 13:54:45 +0200
Message-Id: <1489060485-15618-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The caller must always call the s_power() op symmetrically powering the
device on and off. This is the practice albeit it was not documented. A
lot of sub-device drivers rely on it, so document it accordingly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-subdev.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0ab1c5d..b4e521d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -172,8 +172,10 @@ struct v4l2_subdev_io_pin_config {
  *
  * @s_register: callback for %VIDIOC_G_REGISTER ioctl handler code.
  *
- * @s_power: puts subdevice in power saving mode (on == 0) or normal operation
- *	mode (on == 1).
+ * @s_power: Puts subdevice in power saving mode (on == 0) or normal operation
+ *	mode (on == 1). The caller is responsible for calling the op
+ *	symmetrically, i.e. calling s_power(dev, 1) once requires later calling
+ *	s_power(dev, 0) once.
  *
  * @interrupt_service_routine: Called by the bridge chip's interrupt service
  *	handler, when an interrupt status has be raised due to this subdev,
-- 
2.7.4
