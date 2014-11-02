Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35677 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKBMDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:03:51 -0500
Received: by mail-pd0-f177.google.com with SMTP id v10so9886538pde.36
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 04:03:51 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] v4l-utils/libdvbv5: fix memory leak in dvb_guess_user_country()
Date: Sun,  2 Nov 2014 21:03:37 +0900
Message-Id: <1414929817-11834-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/countries.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/libdvbv5/countries.c b/lib/libdvbv5/countries.c
index 7acdcc7..9e68ea6 100644
--- a/lib/libdvbv5/countries.c
+++ b/lib/libdvbv5/countries.c
@@ -395,13 +395,13 @@ enum dvb_country_t dvb_guess_user_country(void)
 		if (! buf || strlen(buf) < 2)
 			continue;
 
-		buf = strdup(buf);
-		pbuf= buf;
-
 		if (! strncmp(buf, "POSIX", MIN(strlen(buf), 5)) ||
 		    ! (strncmp(buf, "en", MIN(strlen(buf), 2)) && !isalpha(buf[2])) )
 			continue;
 
+		buf = strdup(buf);
+		pbuf= buf;
+
 		// assuming 'language_country.encoding@variant'
 
 		// country after '_', if given
-- 
2.1.3

