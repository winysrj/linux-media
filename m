Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38017 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757132AbdIHVIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 17:08:55 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        "Gustavo A . R . Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tuners: mxl5005s: make arrays static const, reduces object code size
Date: Fri,  8 Sep 2017 22:08:51 +0100
Message-Id: <20170908210851.12124-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the arrays RegAddr on the stack, instead make them static
const.  Makes the object code smaller by over 980 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  64923	    304	      0	  65227	   fecb	drivers/media/tuners/mxl5005s.o

After:
   text	   data	    bss	    dec	    hex	filename
  63779	    464	      0	  64243	   faf3	drivers/media/tuners/mxl5005s.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/tuners/mxl5005s.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index dd59c2c0e4a5..20ab7b0171f9 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -3591,10 +3591,11 @@ static u16 MXL_GetInitRegister(struct dvb_frontend *fe, u8 *RegNum,
 	u16 status = 0;
 	int i ;
 
-	u8 RegAddr[] = {
+	static const u8 RegAddr[] = {
 		11, 12, 13, 22, 32, 43, 44, 53, 56, 59, 73,
 		76, 77, 91, 134, 135, 137, 147,
-		156, 166, 167, 168, 25 };
+		156, 166, 167, 168, 25
+	};
 
 	*count = ARRAY_SIZE(RegAddr);
 
@@ -3616,11 +3617,15 @@ static u16 MXL_GetCHRegister(struct dvb_frontend *fe, u8 *RegNum, u8 *RegVal,
 
 /* add 77, 166, 167, 168 register for 2.6.12 */
 #ifdef _MXL_PRODUCTION
-	u8 RegAddr[] = {14, 15, 16, 17, 22, 43, 65, 68, 69, 70, 73, 92, 93, 106,
-	   107, 108, 109, 110, 111, 112, 136, 138, 149, 77, 166, 167, 168 } ;
+	static const u8 RegAddr[] = {
+		14, 15, 16, 17, 22, 43, 65, 68, 69, 70, 73, 92, 93, 106,
+		107, 108, 109, 110, 111, 112, 136, 138, 149, 77, 166, 167, 168
+	};
 #else
-	u8 RegAddr[] = {14, 15, 16, 17, 22, 43, 68, 69, 70, 73, 92, 93, 106,
-	   107, 108, 109, 110, 111, 112, 136, 138, 149, 77, 166, 167, 168 } ;
+	static const u8 RegAddr[] = {
+		14, 15, 16, 17, 22, 43, 68, 69, 70, 73, 92, 93, 106,
+		107, 108, 109, 110, 111, 112, 136, 138, 149, 77, 166, 167, 168
+	};
 	/*
 	u8 RegAddr[171];
 	for (i = 0; i <= 170; i++)
-- 
2.14.1
