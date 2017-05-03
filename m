Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:35145 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdECNn0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 09:43:26 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 0773720E97
        for <linux-media@vger.kernel.org>; Wed,  3 May 2017 15:43:24 +0200 (CEST)
From: Martin Kepplinger <martink@posteo.de>
To: mchehab@kernel.org
Cc: yamada.masahiro@socionext.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] media: dvb-frontends: drx39xyj: remove obsolete sign extend macros
Date: Wed,  3 May 2017 15:43:09 +0200
Message-Id: <1493818989-18810-1-git-send-email-martink@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DRX_S9TOS16 and DRX_S24TODRXFREQ are simply not used. Furthermore,
sign_extend32() should be used for sign extension. (Also, the comment
describing DRX_S24TODRXFREQ was wrong). So remove these macros.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 4442e47..afa702c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -450,19 +450,6 @@ MACROS
 			((u8)((((u16)x)>>8)&0xFF))
 
 /**
-* \brief Macro to sign extend signed 9 bit value to signed  16 bit value
-*/
-#define DRX_S9TOS16(x) ((((u16)x)&0x100) ? ((s16)((u16)(x)|0xFF00)) : (x))
-
-/**
-* \brief Macro to sign extend signed 9 bit value to signed  16 bit value
-*/
-#define DRX_S24TODRXFREQ(x) ((((u32) x) & 0x00800000UL) ? \
-				 ((s32) \
-				    (((u32) x) | 0xFF000000)) : \
-				 ((s32) x))
-
-/**
 * \brief Macro to convert 16 bit register value to a s32
 */
 #define DRX_U16TODRXFREQ(x)   ((x & 0x8000) ? \
-- 
2.1.4
