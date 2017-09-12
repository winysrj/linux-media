Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37676 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdILJLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 05:11:20 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Frank Schaefer <fschaefer.oss@googlemail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ov2640: make array reset_seq static, reduces object code size
Date: Tue, 12 Sep 2017 10:11:15 +0100
Message-Id: <20170912091115.29043-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array reset_seq on the stack, instead make it
static.  Makes the object code smaller by over 50 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  11737	   6000	     64	  17801	   4589	drivers/media/i2c/ov2640.o

After:
   text	   data	    bss	    dec	    hex	filename
  11582	   6096	     64	  17742	   454e	drivers/media/i2c/ov2640.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/ov2640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index e6d0c1f64f0b..c290fbdc2336 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -685,7 +685,7 @@ static int ov2640_mask_set(struct i2c_client *client,
 static int ov2640_reset(struct i2c_client *client)
 {
 	int ret;
-	const struct regval_list reset_seq[] = {
+	static const struct regval_list reset_seq[] = {
 		{BANK_SEL, BANK_SEL_SENS},
 		{COM7, COM7_SRST},
 		ENDMARKER,
-- 
2.14.1
