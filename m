Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35469 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbbFFBxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 21:53:36 -0400
Date: Sat, 6 Jun 2015 07:23:27 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] [media] s5k5baf: Convert use of __constant_cpu_to_be16 to
 cpu_to_be16
Message-ID: <20150606015327.GA15272@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In little endian cases, macro cpu_to_be16 unfolds to __swab16 which
provides special case for constants. In big endian cases,
__constant_cpu_to_be16 and cpu_to_be16 expand directly to the
same expression. So, replace __constant_cpu_to_be16 with
cpu_to_be16 with the goal of getting rid of the definition of
__constant_cpu_to_be16 completely.

The semantic patch that performs this transformation is as follows:

@@expression x;@@

- __constant_cpu_to_be16(x)
+ cpu_to_be16(x)

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/media/i2c/s5k5baf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 297ef04..7a43b55 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -491,7 +491,7 @@ static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
 	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
 		 min(2 * count, 64), seq);
 
-	buf[0] = __constant_cpu_to_be16(REG_CMD_BUF);
+	buf[0] = cpu_to_be16(REG_CMD_BUF);
 
 	while (count > 0) {
 		int n = min_t(int, count, ARRAY_SIZE(buf) - 1);
-- 
1.9.1

