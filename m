Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaGKPT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:19:58 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00G9ZZX92160@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:19:57 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 2/9] s5p-jpeg: return error immediately after get_byte fails
Date: Fri, 11 Jul 2014 17:19:43 +0200
Message-id: <1405091990-28567-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
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

