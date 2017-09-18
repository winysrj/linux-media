Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12532 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbdIRSo5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 14:44:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: alan@linux.intel.com
Subject: [PATCH 1/1] staging: media: MAINTAINERS: Add entry for atomisp driver
Date: Mon, 18 Sep 2017 21:41:40 +0300
Message-Id: <1505760100-30944-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the maintainers entry to the atomisp staging media driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb930eb..3e25df3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12469,6 +12469,13 @@ L:	stable@vger.kernel.org
 S:	Supported
 F:	Documentation/process/stable-kernel-rules.rst
 
+STAGING - ATOMISP DRIVER
+M:	Alan Cox <alan@linux.intel.com>
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/media/atomisp/
+
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
-- 
2.7.4
