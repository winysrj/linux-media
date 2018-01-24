Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.194.16]:43101 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932083AbeAXBGP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 20:06:15 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 690CF6DE2
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 18:43:41 -0600 (CST)
Date: Tue, 23 Jan 2018 18:43:40 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and PTR_ERR
Message-ID: <20180124004340.GA25212@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix inconsistent IS_ERR and PTR_ERR in vdic_get_ipu_resources.
The proper pointer to be passed as argument is ch.

This issue was detected with the help of Coccinelle.

Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing IS_ERR_OR_NULL usage")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/staging/media/imx/imx-media-vdic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 433474d..ed35684 100644
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
-- 
2.7.4
