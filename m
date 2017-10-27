Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64748 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdJ0Kh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 06:37:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: alan@linux.intel.com, andriy.shevchenko@intel.com
Subject: [PATCH 1/1] staging: atomisp: Add videobuf2 switch to TODO
Date: Fri, 27 Oct 2017 13:37:16 +0300
Message-Id: <1509100636-13822-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp driver uses the videobuf1 framework for buffer management. The
framework is being removed; switch to videobuf2 needs to be made. There
are only a handful of remaining non-staging drivers using videobuf1.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/atomisp/TODO | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/atomisp/TODO b/drivers/staging/media/atomisp/TODO
index 447cb59..255ce36 100644
--- a/drivers/staging/media/atomisp/TODO
+++ b/drivers/staging/media/atomisp/TODO
@@ -48,6 +48,8 @@
 10. Use LED flash API for flash LED drivers such as LM3554 (which already
     has a LED class driver).
 
+11. Switch from videobuf1 to videobuf2. Videobuf1 is being removed!
+
 Limitations:
 
 1. To test the patches, you also need the ISP firmware
-- 
2.7.4
