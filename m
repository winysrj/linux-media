Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48148 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751750Ab2GOR4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 13:56:54 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org, thomas.mair86@gmail.com
Subject: [PATCH] rtl2832.c: minor cleanup
Date: Sun, 15 Jul 2012 19:56:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207151956.47423.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current formulation of the bw_params loop uses the counter j as an index for the first dimension of the
bw_params array which is later incremented by the variable i.
It is evaluated correctly only, because j is initialized to 0 at the beginning of the loop.
I think that explicitly using the index 0 better reflects the intent of the expression.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 rtl2832.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/frontends/rtl2832.c	2012-07-06 05:45:16.000000000 +0200
+++ b/drivers/media/dvb/frontends/rtl2832.c	2012-07-15 19:05:28.428017449 +0200
@@ -589,7 +589,7 @@ static int rtl2832_set_frontend(struct d
 		return -EINVAL;
 	}
 
-	for (j = 0; j < sizeof(bw_params[j]); j++) {
+	for (j = 0; j < sizeof(bw_params[0]); j++) {
 		ret = rtl2832_wr_regs(priv, 0x1c+j, 1, &bw_params[i][j], 1);
 		if (ret)
 			goto err;

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
