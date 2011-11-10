Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab1KJXfj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:39 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:39 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 20/25] added drxj_options header for pctv80e support
Date: Thu, 10 Nov 2011 17:31:40 -0600
Message-Id: <1320967905-7932-21-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/drxj_options.h |   65 ++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/drxj_options.h

diff --git a/drivers/media/dvb/frontends/drxj_options.h b/drivers/media/dvb/frontends/drxj_options.h
new file mode 100644
index 0000000..962bd61
--- /dev/null
+++ b/drivers/media/dvb/frontends/drxj_options.h
@@ -0,0 +1,65 @@
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
+* \file $Id: drxj_options.h,v 1.5 2009/10/05 21:32:49 dingtao Exp $
+*
+* \brief DRXJ optional settings
+*
+* \author Tao Ding
+*/
+
+/* Note: Please add preprocessor DRXJ_OPTIONS_H for drxj.c to include this file */
+#ifndef __DRXJ_OPTIONS_H__
+#define __DRXJ_OPTIONS_H__
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* #define DRXJ_DIGITAL_ONLY     */
+/* #define DRXJ_VSB_ONLY         */
+/* #define DRXJ_SIGNAL_ACCUM_ERR */
+/* #define MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH   0x03  */
+/* #define MPEG_PARALLEL_OUTPUT_PIN_DRIVE_STRENGTH 0x04  */
+/* #define MPEG_OUTPUT_CLK_DRIVE_STRENGTH    0x05  */
+/* #define OOB_CRX_DRIVE_STRENGTH            0x04  */
+/* #define OOB_DRX_DRIVE_STRENGTH            0x05  */
+/* #define DRXJ_QAM_MAX_WAITTIME             1000  */
+/* #define DRXJ_QAM_FEC_LOCK_WAITTIME        200   */
+/* #define DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME  250   */
+
+/*-------------------------------------------------------------------------
+THE END
+-------------------------------------------------------------------------*/
+#ifdef __cplusplus
+}
+#endif
+#endif /* __DRXJ_OPTIONS_H__ */
-- 
1.7.5.4

