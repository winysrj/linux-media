Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaIXMl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] [media] s5p_mfc: use static for some structs
Date: Wed, 24 Sep 2014 09:41:39 -0300
Message-Id: <5b874048f59a9688a47e15b026d3318d1b32f9bf.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-mfc/s5p_mfc.c:1334:28: warning: symbol 'mfc_buf_size_v5' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1341:25: warning: symbol 'buf_size_v5' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1347:26: warning: symbol 'mfc_buf_align_v5' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1360:28: warning: symbol 'mfc_buf_size_v6' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1368:25: warning: symbol 'buf_size_v6' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1374:26: warning: symbol 'mfc_buf_align_v6' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1392:28: warning: symbol 'mfc_buf_size_v7' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1400:25: warning: symbol 'buf_size_v7' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1406:26: warning: symbol 'mfc_buf_align_v7' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1419:28: warning: symbol 'mfc_buf_size_v8' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1427:25: warning: symbol 'buf_size_v8' was not declared. Should it be static?
drivers/media/platform/s5p-mfc/s5p_mfc.c:1433:26: warning: symbol 'mfc_buf_align_v8' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d95769f99901..165bc86c5962 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1331,20 +1331,20 @@ static const struct dev_pm_ops s5p_mfc_pm_ops = {
 			   NULL)
 };
 
-struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
+static struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
 	.h264_ctx	= MFC_H264_CTX_BUF_SIZE,
 	.non_h264_ctx	= MFC_CTX_BUF_SIZE,
 	.dsc		= DESC_BUF_SIZE,
 	.shm		= SHARED_BUF_SIZE,
 };
 
-struct s5p_mfc_buf_size buf_size_v5 = {
+static struct s5p_mfc_buf_size buf_size_v5 = {
 	.fw	= MAX_FW_SIZE,
 	.cpb	= MAX_CPB_SIZE,
 	.priv	= &mfc_buf_size_v5,
 };
 
-struct s5p_mfc_buf_align mfc_buf_align_v5 = {
+static struct s5p_mfc_buf_align mfc_buf_align_v5 = {
 	.base = MFC_BASE_ALIGN_ORDER,
 };
 
@@ -1357,7 +1357,7 @@ static struct s5p_mfc_variant mfc_drvdata_v5 = {
 	.fw_name[0]	= "s5p-mfc.fw",
 };
 
-struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
+static struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
 	.dev_ctx	= MFC_CTX_BUF_SIZE_V6,
 	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V6,
 	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V6,
@@ -1365,13 +1365,13 @@ struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
 	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V6,
 };
 
-struct s5p_mfc_buf_size buf_size_v6 = {
+static struct s5p_mfc_buf_size buf_size_v6 = {
 	.fw	= MAX_FW_SIZE_V6,
 	.cpb	= MAX_CPB_SIZE_V6,
 	.priv	= &mfc_buf_size_v6,
 };
 
-struct s5p_mfc_buf_align mfc_buf_align_v6 = {
+static struct s5p_mfc_buf_align mfc_buf_align_v6 = {
 	.base = 0,
 };
 
@@ -1389,7 +1389,7 @@ static struct s5p_mfc_variant mfc_drvdata_v6 = {
 	.fw_name[1]     = "s5p-mfc-v6-v2.fw",
 };
 
-struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
+static struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
 	.dev_ctx	= MFC_CTX_BUF_SIZE_V7,
 	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V7,
 	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V7,
@@ -1397,13 +1397,13 @@ struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
 	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V7,
 };
 
-struct s5p_mfc_buf_size buf_size_v7 = {
+static struct s5p_mfc_buf_size buf_size_v7 = {
 	.fw	= MAX_FW_SIZE_V7,
 	.cpb	= MAX_CPB_SIZE_V7,
 	.priv	= &mfc_buf_size_v7,
 };
 
-struct s5p_mfc_buf_align mfc_buf_align_v7 = {
+static struct s5p_mfc_buf_align mfc_buf_align_v7 = {
 	.base = 0,
 };
 
@@ -1416,7 +1416,7 @@ static struct s5p_mfc_variant mfc_drvdata_v7 = {
 	.fw_name[0]     = "s5p-mfc-v7.fw",
 };
 
-struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
+static struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
 	.dev_ctx	= MFC_CTX_BUF_SIZE_V8,
 	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V8,
 	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V8,
@@ -1424,13 +1424,13 @@ struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
 	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V8,
 };
 
-struct s5p_mfc_buf_size buf_size_v8 = {
+static struct s5p_mfc_buf_size buf_size_v8 = {
 	.fw	= MAX_FW_SIZE_V8,
 	.cpb	= MAX_CPB_SIZE_V8,
 	.priv	= &mfc_buf_size_v8,
 };
 
-struct s5p_mfc_buf_align mfc_buf_align_v8 = {
+static struct s5p_mfc_buf_align mfc_buf_align_v8 = {
 	.base = 0,
 };
 
-- 
1.9.3

