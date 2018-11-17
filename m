Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46588 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbeKQVld (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 16:41:33 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.20] vicodec: fix memchr() kernel oops
Message-ID: <b40429df-bae0-a4ea-0b6a-1388fe99a1af@xs4all.nl>
Date: Sat, 17 Nov 2018 12:25:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The size passed to memchr is too large as it assumes the search
starts at the start of the buffer, but it can start at an offset.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.19 and up
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b292cff26c86..013cdebecbc4 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -304,7 +304,8 @@ static int job_ready(void *priv)
 		for (; p < p_out + sz; p++) {
 			u32 copy;

-			p = memchr(p, magic[ctx->comp_magic_cnt], sz);
+			p = memchr(p, magic[ctx->comp_magic_cnt],
+				   p_out + sz - p);
 			if (!p) {
 				ctx->comp_magic_cnt = 0;
 				break;
