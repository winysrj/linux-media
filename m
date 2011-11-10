Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39871 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab1KJXfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:06 -0500
Received: by iage36 with SMTP id e36so3521161iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:06 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 13/25] added drx_driver_version header for pctv80e support
Date: Thu, 10 Nov 2011 17:31:33 -0600
Message-Id: <1320967905-7932-14-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/drx_driver_version.h |   82 ++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/drx_driver_version.h

diff --git a/drivers/media/dvb/frontends/drx_driver_version.h b/drivers/media/dvb/frontends/drx_driver_version.h
new file mode 100644
index 0000000..b6a37d8
--- /dev/null
+++ b/drivers/media/dvb/frontends/drx_driver_version.h
@@ -0,0 +1,82 @@
+/*
+ *******************************************************************************
+ * WARNING - THIS FILE HAS BEEN GENERATED - DO NOT CHANGE
+ *
+ * Filename:        drx_driver_version.h
+ * Generated on:    Mon Jan 18 12:09:23 2010
+ * Generated by:    IDF:x 1.3.0
+ * Generated from:  ../../../device/drxj/version
+ * Output start:    [entry point]
+ *
+ * filename         last modified               re-use
+ *
+  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
+  All rights reserved.
+
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions are met:
+
+  * Redistributions of source code must retain the above copyright notice,
+    this list of conditions and the following disclaimer.
+  * Redistributions in binary form must reproduce the above copyright notice,
+    this list of conditions and the following disclaimer in the documentation
+	and/or other materials provided with the distribution.
+  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
+    nor the names of its contributors may be used to endorse or promote
+	products derived from this software without specific prior written
+	permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+  POSSIBILITY OF SUCH DAMAGE.
+*/
+
+/* -----------------------------------------------------
+ * version.idf      Mon Jan 18 11:56:10 2010    -
+ *
+ */
+
+#ifndef __DRX_DRIVER_VERSION__H__
+#define __DRX_DRIVER_VERSION__H__ INCLUDED
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#ifdef _REGISTERTABLE_
+#include <registertable.h>
+extern RegisterTable_t drx_driver_version[];
+extern RegisterTableInfo_t drx_driver_version_info[];
+#endif /* _REGISTERTABLE_ */
+
+
+/*
+ *==============================================================================
+ * VERSION
+ * version@/var/cvs/projects/drxj.cvsroot/hostcode/drxdriver/device/drxj
+ *==============================================================================
+ */
+
+#define VERSION__A      0x0
+#define   VERSION_MAJOR 1
+#define   VERSION_MINOR 0
+#define   VERSION_PATCH 56
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __DRX_DRIVER_VERSION__H__ */
+
+/*
+ * End of file (drx_driver_version.h)
+ *******************************************************************************
+ */
-- 
1.7.5.4

