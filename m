Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaCCLLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 06:11:31 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 35/79] [media] drx-j: remove drxj_options.h
Date: Mon,  3 Mar 2014 07:06:29 -0300
Message-Id: <1393841233-24840-36-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is empty (actually, all commented there). So, remove it.

We should latter remove those macros too, or convert them into
a struct to allow dynamically enable the options during device
probing time.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |  4 --
 .../media/dvb-frontends/drx39xyj/drxj_options.h    | 65 ----------------------
 2 files changed, 69 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/drxj_options.h

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 668ac1a07959..c04745202c49 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -40,10 +40,6 @@ INCLUDE FILES
 #include "drxj.h"
 #include "drxj_map.h"
 
-#ifdef DRXJ_OPTIONS_H
-#include "drxj_options.h"
-#endif
-
 /*============================================================================*/
 /*=== DEFINES ================================================================*/
 /*============================================================================*/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_options.h b/drivers/media/dvb-frontends/drx39xyj/drxj_options.h
deleted file mode 100644
index f3902868eaad..000000000000
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_options.h
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
-  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
-  All rights reserved.
-
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions are met:
-
-  * Redistributions of source code must retain the above copyright notice,
-    this list of conditions and the following disclaimer.
-  * Redistributions in binary form must reproduce the above copyright notice,
-    this list of conditions and the following disclaimer in the documentation
-	and/or other materials provided with the distribution.
-  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
-    nor the names of its contributors may be used to endorse or promote
-	products derived from this software without specific prior written
-	permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-  POSSIBILITY OF SUCH DAMAGE.
-*/
-
-/**
-* \file $Id: drxj_options.h,v 1.5 2009/10/05 21:32:49 dingtao Exp $
-*
-* \brief DRXJ optional settings
-*
-* \author Tao Ding
-*/
-
-/* Note: Please add preprocessor DRXJ_OPTIONS_H for drxj.c to include this file */
-#ifndef __DRXJ_OPTIONS_H__
-#define __DRXJ_OPTIONS_H__
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/* #define DRXJ_DIGITAL_ONLY     */
-/* #define DRXJ_VSB_ONLY         */
-/* #define DRXJ_SIGNAL_ACCUM_ERR */
-/* #define MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH   0x03  */
-/* #define MPEG_PARALLEL_OUTPUT_PIN_DRIVE_STRENGTH 0x04  */
-/* #define MPEG_OUTPUT_CLK_DRIVE_STRENGTH    0x05  */
-/* #define OOB_CRX_DRIVE_STRENGTH            0x04  */
-/* #define OOB_DRX_DRIVE_STRENGTH            0x05  */
-/* #define DRXJ_QAM_MAX_WAITTIME             1000  */
-/* #define DRXJ_QAM_FEC_LOCK_WAITTIME        200   */
-/* #define DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME  250   */
-
-/*-------------------------------------------------------------------------
-THE END
--------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
-#endif				/* __DRXJ_OPTIONS_H__ */
-- 
1.8.5.3

