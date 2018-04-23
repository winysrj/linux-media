Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49237 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbeDWNNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:13:50 -0400
Message-ID: <1524489222.3396.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] media: imx-media-csi: Fix inconsistent IS_ERR and
 PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Date: Mon, 23 Apr 2018 15:13:42 +0200
In-Reply-To: <CAOMZO5AfQY+W-64uL-pn=9BwDZLZaO=3T6F-_=zHGYvZGUd-cg@mail.gmail.com>
References: <1523899736-31360-1-git-send-email-festevam@gmail.com>
         <CAOMZO5AfQY+W-64uL-pn=9BwDZLZaO=3T6F-_=zHGYvZGUd-cg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-23 at 08:55 -0300, Fabio Estevam wrote:
> Hi Hans,
> 
> Unfortunately this one missed to be applied into 4.17-rc and now the
> imx-media-csi driver does not probe.
> 
> Please consider applying it for 4.17-rc3 to avoid the regression.
> 
> Thanks
> 
> On Mon, Apr 16, 2018 at 2:28 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > From: From: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > 
> > Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
> > The proper pointer to be passed as argument is pinctrl
> > instead of priv->vdev.
> > 
> > This issue was detected with the help of Coccinelle.
> > 
> > Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> > Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
