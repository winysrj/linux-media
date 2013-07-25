Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63590 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3GYNKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:10:39 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so688402bkc.15
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:10:38 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/4] libdvbv5: Fix copy and paste error in parse_service()
Date: Thu, 25 Jul 2013 15:09:34 +0200
Message-Id: <1374757774-29051-5-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
References: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected by Coverity.

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 99d8fa3..9b6b050 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -787,9 +787,9 @@ static void parse_service(struct dvb_v5_fe_parms *parms, struct service_table *s
 	if (verbose) {
 		if (service_table->provider_name)
 			printf("Provider %s", service_table->provider_name);
-		if (service_table->service_alias)
+		if (service_table->provider_alias)
 			printf("(%s)", service_table->provider_alias);
-		if (service_table->provider_name || service_table->service_alias)
+		if (service_table->provider_name || service_table->provider_alias)
 			printf("\n");
 		if (service_table->service_name)
 			printf("Service %s", service_table->service_name);
-- 
1.8.3.2

