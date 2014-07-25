Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:33012 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbaGYOVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 3/9] s5p-jpeg: return error immediately after get_byte fails
Date: Fri, 25 Jul 2014 16:20:47 +0200
Message-id: <1406298053-30184-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
References: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacek Anaszewski <j.anaszewski@samsung.com>

When parsing JPEG header s5p_jpeg_parse_hdr function should return
immediately in case there was an error while reading a byte.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 126199e..a3f8862 100644
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

