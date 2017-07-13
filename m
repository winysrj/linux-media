Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36658 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMPGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:06:30 -0400
From: smklearn <smklearn@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, smklearn@gmail.com
Subject: [PATCH] [media] staging/atomisp: fix minor coding style warnings
Date: Thu, 13 Jul 2017 08:06:21 -0700
Message-Id: <1499958381-11361-1-git-send-email-smklearn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Below were the minor issues flagged by checkpatch.pl:
- WARNING: Block comments use * on subsequent lines
- ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Shy More <smklearn@gmail.com>
---
 .../css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
index 76d9142..856fb6e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
@@ -14,18 +14,18 @@
  */
 #else
 /**
-Support for Intel Camera Imaging ISP subsystem.
-Copyright (c) 2010 - 2015, Intel Corporation.
-
-This program is free software; you can redistribute it and/or modify it
-under the terms and conditions of the GNU General Public License,
-version 2, as published by the Free Software Foundation.
-
-This program is distributed in the hope it will be useful, but WITHOUT
-ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-more details.
-*/
+ * Support for Intel Camera Imaging ISP subsystem.
+ * Copyright (c) 2010 - 2015, Intel Corporation.
+
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
 #endif
 
 #include "system_global.h"
@@ -131,7 +131,7 @@ void ia_css_isys_ibuf_rmgr_release(
 	for (i = 0; i < ibuf_rsrc.num_allocated; i++) {
 		handle = getHandle(i);
 		if ((handle->start_addr == *start_addr)
-		    && ( true == handle->active)) {
+		    && (true == handle->active)) {
 			handle->active = false;
 			ibuf_rsrc.num_active--;
 			break;
-- 
1.9.1
