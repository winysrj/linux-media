Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40236 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032698AbeCAQYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 11:24:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
References: <20180301040939.GA13274@embeddedgus> <CAOMZO5B_UGZ3De1UjUXzU6-wGMgRrRJVWZ8z+a+HoCpwWkeBwg@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 1 Mar 2018 13:24:03 -0300
Message-ID: <CAOMZO5A9KazX=NiaH6Px+=KsBSb2rHrdehtkzXgVFa5gTPjSwg@mail.gmail.com>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve, Phiipp,

On Thu, Mar 1, 2018 at 1:02 PM, Fabio Estevam <festevam@gmail.com> wrote:

> So imx_csi_probe() does not succeed anymore since
> devm_pinctrl_get_select_default() always fails.
>
> Not sure I understand the comments that explain the need for pinctrl
> handling inside the driver.
>
> Can't we just get rid of it like this?

Just tested and if devm_pinctrl_get_select_default() is removed, I am
not able to change the ipu csi pinctrl settings anymore.

I had to ignore devm_pinctrl_get_select_default() error value so that
the driver can probe again:

diff --git a/drivers/staging/media/imx/imx-media-csi.c
b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f8..c40f786 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1797,11 +1797,8 @@ static int imx_csi_probe(struct platform_device *pdev)
         */
        priv->dev->of_node = pdata->of_node;
        pinctrl = devm_pinctrl_get_select_default(priv->dev);
-       if (IS_ERR(pinctrl)) {
-               ret = PTR_ERR(priv->vdev);
-               goto free;
-       }
-
+       if (IS_ERR(pinctrl))
+               dev_dbg(priv->dev, "pintrl_get_select_default() failed\n");
        ret = v4l2_async_register_subdev(&priv->sd);
        if (ret)
                goto free;

Is there a better solution for this issue?
