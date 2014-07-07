Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57752 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaGGQct (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 12:32:49 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 2/9] s5p-jpeg: return error immediately after get_byte fails
Date: Mon, 07 Jul 2014 18:32:03 +0200
Message-id: <1404750730-22996-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When parsing JPEG header s5p_jpeg_parse_hdr function
should return immediately in case there was an error
while reading a byte.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 7d604f2..df3aaa9 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -906,14 +906,14 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
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
1.7.9.5

