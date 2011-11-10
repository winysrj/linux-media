Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1KJXev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:34:51 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:34:51 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 02/25] added bsp_host for pctv80e support
Date: Thu, 10 Nov 2011 17:31:22 -0600
Message-Id: <1320967905-7932-3-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/bsp_host.h |   80 ++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/bsp_host.h

diff --git a/drivers/media/dvb/frontends/bsp_host.h b/drivers/media/dvb/frontends/bsp_host.h
new file mode 100644
index 0000000..75a5f7b
--- /dev/null
+++ b/drivers/media/dvb/frontends/bsp_host.h
@@ -0,0 +1,80 @@
+/*
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
+/**
+* \file $Id: bsp_host.h,v 1.3 2009/07/07 14:20:30 justin Exp $
+*
+* \brief Host and OS dependent type definitions, macro's and functions
+*
+*/
+
+#ifndef __DRXBSP_HOST_H__
+#define __DRXBSP_HOST_H__
+/*-------------------------------------------------------------------------
+INCLUDES
+-------------------------------------------------------------------------*/
+#include "bsp_types.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/*-------------------------------------------------------------------------
+TYPEDEFS
+-------------------------------------------------------------------------*/
+
+
+/*-------------------------------------------------------------------------
+DEFINES
+-------------------------------------------------------------------------*/
+
+/*-------------------------------------------------------------------------
+Exported FUNCTIONS
+-------------------------------------------------------------------------*/
+DRXStatus_t DRXBSP_HST_Init(void);
+
+DRXStatus_t DRXBSP_HST_Term(void);
+
+void* DRXBSP_HST_Memcpy(void *to, void *from, u32_t n);
+
+int DRXBSP_HST_Memcmp(void *s1, void *s2, u32_t n);
+
+u32_t DRXBSP_HST_Clock(void);
+
+DRXStatus_t DRXBSP_HST_Sleep(u32_t n);
+
+/*-------------------------------------------------------------------------
+THE END
+-------------------------------------------------------------------------*/
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __DRXBSP_HOST_H__ */
-- 
1.7.5.4

