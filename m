Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34284 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752477AbdBCVNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 16:13:16 -0500
Received: by mail-ot0-f195.google.com with SMTP id 73so3613348otj.1
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2017 13:13:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1cZged-0003B4-EY@www.linuxtv.org>
References: <E1cZged-0003B4-EY@www.linuxtv.org>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 3 Feb 2017 19:13:14 -0200
Message-ID: <CAOMZO5BTNZdmK4ENOGqeKwDM7h0-WzTWFOk54FS+yV-nTuaWmQ@mail.gmail.com>
Subject: Re: [git:media_tree/master] [media] coda: add Freescale firmware
 compatibility location
To: linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linuxtv-commits@linuxtv.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 3, 2017 at 2:23 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued:
>
> Subject: [media] coda: add Freescale firmware compatibility location
> Author:  Baruch Siach <baruch@tkos.co.il>
> Date:    Sun Jan 15 08:33:53 2017 -0200
>
> The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
> by default. Make coda look there for firmware files to ease the update path.
>
> Cc: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
>  drivers/media/platform/coda/coda-common.c | 4 ++++
>  drivers/media/platform/coda/coda.h        | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> ---
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index a918b294adef..eb6548f46cba 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2221,6 +2221,7 @@ static const struct coda_devtype coda_devdata[] = {
>         [CODA_IMX27] = {
>                 .firmware     = {
>                         "vpu_fw_imx27_TO2.bin",
> +                       "vpu/vpu_fw_imx27_TO2.bin",
>                         "v4l-codadx6-imx27.bin"
>                 },
>                 .product      = CODA_DX6,
> @@ -2234,6 +2235,7 @@ static const struct coda_devtype coda_devdata[] = {
>         [CODA_IMX53] = {
>                 .firmware     = {
>                         "vpu_fw_imx53.bin",
> +                       "vpu/vpu_fw_imx53.bin",
>                         "v4l-coda7541-imx53.bin"
>                 },
>                 .product      = CODA_7541,
> @@ -2248,6 +2250,7 @@ static const struct coda_devtype coda_devdata[] = {
>         [CODA_IMX6Q] = {
>                 .firmware     = {
>                         "vpu_fw_imx6q.bin",
> +                       "vpu/vpu_fw_imx6q.bin",
>                         "v4l-coda960-imx6q.bin"
>                 },
>                 .product      = CODA_960,
> @@ -2262,6 +2265,7 @@ static const struct coda_devtype coda_devdata[] = {
>         [CODA_IMX6DL] = {
>                 .firmware     = {
>                         "vpu_fw_imx6d.bin",
> +                       "vpu/vpu_fw_imx6d.bin",
>                         "v4l-coda960-imx6dl.bin"
>                 },
>                 .product      = CODA_960,
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 7ed79eb774e7..4b831c91ae4a 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -50,7 +50,7 @@ enum coda_product {
>  struct coda_video_device;
>
>  struct coda_devtype {
> -       char                    *firmware[2];
> +       char                    *firmware[3];
>         enum coda_product       product;
>         const struct coda_codec *codecs;
>         unsigned int            num_codecs;

I think there was an issue pointed out by Philipp on this patch.
