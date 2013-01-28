Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3A1OTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:19:55 -0500
Date: Mon, 28 Jan 2013 17:19:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org, Ross Cohen <rcohen@snurgle.org>,
	kernel-janitors@vger.kernel.org
Subject: [media] staging: go7007: fix test for V4L2_STD_SECAM
Message-ID: <20130128141942.GC24528@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current test doesn't make a lot of sense.  It's likely to be true,
which is what we would want in most cases.  From looking at how this is
handled in other drivers,  I think "&" was intended instead of "*".
It's an easy mistake to make because they are next to each other on the
keyboard.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
index 8810c1e..891cde7 100644
--- a/drivers/staging/media/go7007/wis-saa7113.c
+++ b/drivers/staging/media/go7007/wis-saa7113.c
@@ -141,7 +141,7 @@ static int wis_saa7113_command(struct i2c_client *client,
 		} else if (dec->norm & V4L2_STD_PAL) {
 			write_reg(client, 0x0e, 0x01);
 			write_reg(client, 0x10, 0x48);
-		} else if (dec->norm * V4L2_STD_SECAM) {
+		} else if (dec->norm & V4L2_STD_SECAM) {
 			write_reg(client, 0x0e, 0x50);
 			write_reg(client, 0x10, 0x48);
 		}
