Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:32998 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbF3OfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 10:35:06 -0400
Received: by pdjd13 with SMTP id d13so7313682pdj.0
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2015 07:35:04 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] v4l-utils/contrib/gconv: fix wrong conversion to ARIB-STD-B24
Date: Tue, 30 Jun 2015 23:34:00 +0900
Message-Id: <1435674840-27470-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Some symbol characters were not encoded correctly, though decoding was OK.
Since v4l-utils/libdvbv5 does not use encoding into ARIB-STD-B24,
the bug should not affect libdvbv5,
but this fix supports some other applications.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 contrib/gconv/arib-std-b24.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/contrib/gconv/arib-std-b24.c b/contrib/gconv/arib-std-b24.c
index fa3ced4..b9d7588 100644
--- a/contrib/gconv/arib-std-b24.c
+++ b/contrib/gconv/arib-std-b24.c
@@ -1555,15 +1555,12 @@ find_extsym_idx (uint32_t ch)
 	goto next;							      \
       }									      \
 									      \
-    /* prefer KANJI(>= 0x7521) or EXTRA_SYMBOLS over JISX0213_{1,2} */	      \
+    /* KANJI shares some chars with EXTRA_SYMBOLS, but prefer extra symbols*/ \
     r = find_extsym_idx (ch);						      \
     if (r >= 0)								      \
       {									      \
 	ch = ucs4_to_extsym[r][1];					      \
-	if ((ch & 0xff00) >= 0x7a00)					      \
-	  r = out_kanji (&st, ch, &outptr, outend);			      \
-	else								      \
-	  r = out_extsym (&st, ch, &outptr, outend);			      \
+	r = out_extsym (&st, ch, &outptr, outend);			      \
 	goto next;							      \
       }									      \
 									      \
-- 
2.4.4

