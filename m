Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753838AbeAOIMK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 03:12:10 -0500
Date: Mon, 15 Jan 2018 11:11:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: staging/imx: Checking the right variable in
 vdic_get_ipu_resources()
Message-ID: <20180115081147.upana3zubsxp4vvd@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently changed this error handling around but missed this error
pointer check.  We're testing "priv->vdi_in_ch_n" instead of "ch" so the
error handling can't be triggered.

Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing IS_ERR_OR_NULL usage")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 433474d58e3e..ed356844cdf6 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -177,7 +177,7 @@ static int vdic_get_ipu_resources(struct vdic_priv *priv)
 		priv->vdi_in_ch = ch;
 
 		ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_NEXT);
-		if (IS_ERR(priv->vdi_in_ch_n)) {
+		if (IS_ERR(ch)) {
 			err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
 			ret = PTR_ERR(ch);
 			goto out_err_chan;
