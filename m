Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0G0Mdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:33:39 -0400
Received: by fxm14 with SMTP id 14so580993fxm.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 05:33:37 -0700 (PDT)
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 2/2] media: video: pvrusb2: remove custom hex_to_bin()
Date: Tue, 27 Jul 2010 15:32:50 +0300
Message-Id: <39e0be58882d4d5fd84e2b70a8fdc38bc1b4fc41.1280233873.git.andy.shevchenko@gmail.com>
In-Reply-To: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com>
References: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com>
In-Reply-To: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com>
References: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mike Isely <isely@pobox.com>
---
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
index e9b11e1..4279ebb 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
@@ -94,8 +94,6 @@ static int debugifc_parse_unsigned_number(const char *buf,unsigned int count,
 					  u32 *num_ptr)
 {
 	u32 result = 0;
-	u32 val;
-	int ch;
 	int radix = 10;
 	if ((count >= 2) && (buf[0] == '0') &&
 	    ((buf[1] == 'x') || (buf[1] == 'X'))) {
@@ -107,17 +105,9 @@ static int debugifc_parse_unsigned_number(const char *buf,unsigned int count,
 	}
 
 	while (count--) {
-		ch = *buf++;
-		if ((ch >= '0') && (ch <= '9')) {
-			val = ch - '0';
-		} else if ((ch >= 'a') && (ch <= 'f')) {
-			val = ch - 'a' + 10;
-		} else if ((ch >= 'A') && (ch <= 'F')) {
-			val = ch - 'A' + 10;
-		} else {
+		int val = hex_to_bin(*buf++);
+		if (val < 0 || val >= radix)
 			return -EINVAL;
-		}
-		if (val >= radix) return -EINVAL;
 		result *= radix;
 		result += val;
 	}
-- 
1.7.1.1

