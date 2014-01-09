Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60004 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaAIMzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 07:55:53 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ4005WHX937A80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Jan 2014 12:55:51 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] s5k5baf: allow to handle arbitrary long i2c sequences
Date: Thu, 09 Jan 2014 13:55:43 +0100
Message-id: <1389272143-22394-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <20140108122709.39263bb9@samsung.com>
References: <20140108122709.39263bb9@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using variable length array in s5k5baf_write_arr_seq
caused an implicit assumption that i2c sequences should be short.
The patch rewrites the function so it can handle sequences
of any length and do not uses variable length array.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Hi Dan and Mauro,

I hope this patch solves the issue.

Regards
Andrzej
---
 drivers/media/i2c/s5k5baf.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 089fba6..3de1287 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -478,25 +478,33 @@ static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
 				  u16 count, const u16 *seq)
 {
 	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
-	__be16 buf[count + 1];
-	int ret, n;
+	__be16 buf[65];
 
 	s5k5baf_i2c_write(state, REG_CMDWR_ADDR, addr);
 	if (state->error)
 		return;
 
+	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
+		 min(2 * count, 64), seq);
+
 	buf[0] = __constant_cpu_to_be16(REG_CMD_BUF);
-	for (n = 1; n <= count; ++n)
-		buf[n] = cpu_to_be16(*seq++);
 
-	n *= 2;
-	ret = i2c_master_send(c, (char *)buf, n);
-	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
-		 min(2 * count, 64), seq - count);
+	while (count > 0) {
+		int n = min_t(int, count, ARRAY_SIZE(buf) - 1);
+		int ret, i;
 
-	if (ret != n) {
-		v4l2_err(c, "i2c_write_seq: error during transfer (%d)\n", ret);
-		state->error = ret;
+		for (i = 1; i <= n; ++i)
+			buf[i] = cpu_to_be16(*seq++);
+
+		i *= 2;
+		ret = i2c_master_send(c, (char *)buf, i);
+		if (ret != i) {
+			v4l2_err(c, "i2c_write_seq: error during transfer (%d)\n", ret);
+			state->error = ret;
+			break;
+		}
+
+		count -= n;
 	}
 }
 
-- 
1.8.3.2

