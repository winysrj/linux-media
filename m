Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46007 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZEOShm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:37:42 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIbdBW023813
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:37:44 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 5/9] ccdc types used across ccdc modules for vpfe capture driver
Date: Fri, 15 May 2009 14:37:37 -0400
Message-Id: <1242412657-11451-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

common types used across CCDC modules

This has the common types used by all ccdc hw modules

This has the comments incorporated from the previous review

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 include/media/davinci/ccdc_types.h |   43 ++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 include/media/davinci/ccdc_types.h

diff --git a/include/media/davinci/ccdc_types.h b/include/media/davinci/ccdc_types.h
new file mode 100644
index 0000000..5773874
--- /dev/null
+++ b/include/media/davinci/ccdc_types.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2008-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ **************************************************************************/
+#ifndef _CCDC_TYPES_H
+#define _CCDC_TYPES_H
+enum ccdc_pixfmt {
+	CCDC_PIXFMT_RAW,
+	CCDC_PIXFMT_YCBCR_16BIT,
+	CCDC_PIXFMT_YCBCR_8BIT
+};
+
+enum ccdc_frmfmt {
+	CCDC_FRMFMT_PROGRESSIVE,
+	CCDC_FRMFMT_INTERLACED
+};
+
+/* PIXEL ORDER IN MEMORY from LSB to MSB */
+/* only applicable for 8-bit input mode  */
+enum ccdc_pixorder {
+	CCDC_PIXORDER_YCBYCR,
+	CCDC_PIXORDER_CBYCRY,
+};
+
+enum ccdc_buftype {
+	CCDC_BUFTYPE_FLD_INTERLEAVED,
+	CCDC_BUFTYPE_FLD_SEPARATED
+};
+#endif
-- 
1.6.0.4

