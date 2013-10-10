Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:16198 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJHGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 03:06:41 -0400
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.chehab@samsung.com, s.nawrocki@samsung.com
Cc: sw0312.kim@samsung.com
Subject: [PATCH] s5p-jpeg: fix uninitialized use in hdr parse
Date: Thu, 10 Oct 2013 16:06:31 +0900
Message-id: <1381388791-1828-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For hdr parse error, it can return false without any assignments
which cause build warning.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..7db374e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -442,14 +442,14 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 	while (notfound) {
 		c = get_byte(&jpeg_buffer);
 		if (c == -1)
-			break;
+			return false;
 		if (c != 0xff)
 			continue;
 		do
 			c = get_byte(&jpeg_buffer);
 		while (c == 0xff);
 		if (c == -1)
-			break;
+			return false;
 		if (c == 0)
 			continue;
 		length = 0;
-- 
1.7.4.1

