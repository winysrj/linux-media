Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47001 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728310AbeGZI0a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 04:26:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: vicodec: current -> cur
Message-ID: <ebadbba0-1ecf-d727-50cd-6228cca529f6@xs4all.nl>
Date: Thu, 26 Jul 2018 09:11:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'current' is also defined in asm-generic/current.h.

When compiling this driver for older kernels with the media_build system,
this header is included via compat.h and it no longer compiles. Rename
current to cur.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index e880a6c5747f..2d047646f614 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -555,7 +555,7 @@ static int var_inter(const s16 *old, const s16 *new)
 	return ret;
 }

-static int decide_blocktype(const u8 *current, const u8 *reference,
+static int decide_blocktype(const u8 *cur, const u8 *reference,
 			    s16 *deltablock, unsigned int stride,
 			    unsigned int input_step)
 {
@@ -566,7 +566,7 @@ static int decide_blocktype(const u8 *current, const u8 *reference,
 	int vari;
 	int vard;

-	fill_encoder_block(current, tmp, stride, input_step);
+	fill_encoder_block(cur, tmp, stride, input_step);
 	fill_encoder_block(reference, old, 8, 1);
 	vari = var_intra(tmp);
