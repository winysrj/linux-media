Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:64466 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753167AbeAQNq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 08:46:27 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH -next] media: rcar_drif: fix error return code in
 rcar_drif_alloc_dmachannels()
Date: Wed, 17 Jan 2018 13:46:23 +0000
Message-ID: <KL1PR0601MB2038BFC24B4118A5AB282650C3E90@KL1PR0601MB2038.apcprd06.prod.outlook.com>
References: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei Yongjun,

Thank you for the patch.

> Subject: [PATCH -next] media: rcar_drif: fix error return code in
> rcar_drif_alloc_dmachannels()
>=20
> Fix to return error code -ENODEV from the dma_request_slave_channel()
> error handling case instead of 0, as done elsewhere in this function.
> rc can be overwrite to 0 by dmaengine_slave_config() in the for loop.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Ramesh Shanmugasundaram <Ramesh.shanmugasundaram@bp.renesas.co=
m>

Thanks,
Ramesh

> ---
>  drivers/media/platform/rcar_drif.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar_drif.c
> b/drivers/media/platform/rcar_drif.c
> index b2e080e..dc7e280 100644
> --- a/drivers/media/platform/rcar_drif.c
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -274,7 +274,7 @@ static int rcar_drif_alloc_dmachannels(struct
> rcar_drif_sdr *sdr)  {
>  	struct dma_slave_config dma_cfg;
>  	unsigned int i;
> -	int ret =3D -ENODEV;
> +	int ret;
>=20
>  	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
>  		struct rcar_drif *ch =3D sdr->ch[i];
> @@ -282,6 +282,7 @@ static int rcar_drif_alloc_dmachannels(struct
> rcar_drif_sdr *sdr)
>  		ch->dmach =3D dma_request_slave_channel(&ch->pdev->dev, "rx");
>  		if (!ch->dmach) {
>  			rdrif_err(sdr, "ch%u: dma channel req failed\n", i);
> +			ret =3D -ENODEV;
>  			goto dmach_error;
>  		}
