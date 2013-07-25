Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55312 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3GYNKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:10:37 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so689267bkc.29
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:10:36 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] libdvbv5: Fix reallocation in parse_lcn
Date: Thu, 25 Jul 2013 15:09:32 +0200
Message-Id: <1374757774-29051-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
References: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected by Coverity.

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 lib/libdvbv5/descriptors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 73338d8..99d8fa3 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -758,7 +758,7 @@ static void parse_lcn(struct nit_table *nit_table,
 	for (i = 0; i < dlen; i+= 4, p+= 4) {
 		struct lcn_table **lcn = &nit_table->lcn;
 
-		*lcn = realloc(*lcn, (n + 1) * sizeof(*lcn));
+		*lcn = realloc(*lcn, (n + 1) * sizeof(**lcn));
 		(*lcn)[n].service_id = p[0] << 8 | p[1];
 		(*lcn)[n].lcn = (p[2] << 8 | p[3]) & 0x3ff;
 		nit_table->lcn_len++;
-- 
1.8.3.2

