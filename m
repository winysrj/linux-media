Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39486 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaJJIrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 04:47:18 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND800CXK0ESOQA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Oct 2014 17:47:16 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr
Date: Fri, 10 Oct 2014 10:46:49 +0200
Message-id: <1412930809-28722-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize components variable in order to avoid
the possibility of using it uninitialized.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e66acbc..91dc351 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -893,7 +893,7 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			       unsigned long buffer, unsigned long size,
 			       struct s5p_jpeg_ctx *ctx)
 {
-	int c, components, notfound;
+	int c, components = 0, notfound;
 	unsigned int height, width, word, subsampling = 0;
 	long length;
 	struct s5p_jpeg_buffer jpeg_buffer;
-- 
1.7.9.5

