Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44429 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdIELDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 07:03:42 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pan Bian <bianpan2016@163.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx25840: make array stds static const, reduces object code size
Date: Tue,  5 Sep 2017 12:03:32 +0100
Message-Id: <20170905110332.15324-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array syds on the stack, instead make it static const.
Makes the object code smaller by over 280 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  81451	  12784	    704	  94939	  172db	cx25840-core.o

   text	   data	    bss	    dec	    hex	filename
  81070	  12880	    704	  94654	  171be	cx25840-core.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 39f51daa7558..f38bf819d805 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1745,7 +1745,7 @@ static int cx25840_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	v4l2_std_id stds[] = {
+	static const v4l2_std_id stds[] = {
 		/* 0000 */ V4L2_STD_UNKNOWN,
 
 		/* 0001 */ V4L2_STD_NTSC_M,
-- 
2.14.1
