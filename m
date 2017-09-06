Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42823 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754787AbdIFNaS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 09:30:18 -0400
From: Colin King <colin.king@canonical.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ov9640: make const arrays res_x/y static const, reduces object code size
Date: Wed,  6 Sep 2017 14:30:16 +0100
Message-Id: <20170906133016.17950-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the arrays res_x and resy_y on the stack, instead make them
static const.  Makes the object code smaller by over 160 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  10509	   2800	     64	  13373	   343d	ov9640.o

After:
   text	   data	    bss	    dec	    hex	filename
  10184	   2960	     64	  13208	   3398	ov9640.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/soc_camera/ov9640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 0146d1f7aacb..dafea6d90ad9 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -335,8 +335,8 @@ static void ov9640_res_roundup(u32 *width, u32 *height)
 {
 	int i;
 	enum { QQCIF, QQVGA, QCIF, QVGA, CIF, VGA, SXGA };
-	int res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
-	int res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
+	static const int res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
+	static const int res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
 
 	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
 		if (res_x[i] >= *width && res_y[i] >= *height) {
-- 
2.14.1
