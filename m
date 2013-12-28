Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34834 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3L1PqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:22 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so4512470eei.28
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:21 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 06/13] libdvbv5: fix eit times
Date: Sat, 28 Dec 2013 16:45:54 +0100
Message-Id: <1388245561-8751-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors/eit.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index d13b14c..e70cf3b 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -155,9 +155,8 @@ void dvb_time(const uint8_t data[5], struct tm *tm)
   tm->tm_mday  = day;
   tm->tm_mon   = month - 1;
   tm->tm_year  = year;
-  tm->tm_isdst = -1;
-  tm->tm_wday  = 0;
-  tm->tm_yday  = 0;
+  tm->tm_isdst = 1; // dst in effect, do not adjust
+  mktime( tm );
 }
 
 
-- 
1.8.3.2

