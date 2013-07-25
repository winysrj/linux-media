Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55000 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3GYNKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:10:36 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so679640bkc.1
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:10:35 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] xc3082: Fix use after free in free_firmware()
Date: Thu, 25 Jul 2013 15:09:31 +0200
Message-Id: <1374757774-29051-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
References: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected by Coverity Scanner.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 utils/xc3028-firmware/firmware-tool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/xc3028-firmware/firmware-tool.c b/utils/xc3028-firmware/firmware-tool.c
index b2e9de4..a7850df 100644
--- a/utils/xc3028-firmware/firmware-tool.c
+++ b/utils/xc3028-firmware/firmware-tool.c
@@ -86,13 +86,13 @@ static struct firmware* alloc_firmware(void) {
 
 static void free_firmware(struct firmware *f) {
 	free(f->name);
-	free(f->desc);
 	if(f->desc) {
 		unsigned int i = 0;
 		for(i = 0; i < f->nr_desc; ++ i) {
 			free(f->desc[i].data);
 		}
 	}
+	free(f->desc);
 	free(f);
 }
 
-- 
1.8.3.2

