Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34143 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753384AbcL0L0R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 06:26:17 -0500
Received: by mail-oi0-f65.google.com with SMTP id 3so18922935oih.1
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2016 03:26:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <628638bcda35ffe92f931f67560ed01cba970067.1482833176.git.baruch@tkos.co.il>
References: <628638bcda35ffe92f931f67560ed01cba970067.1482833176.git.baruch@tkos.co.il>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 27 Dec 2016 09:26:16 -0200
Message-ID: <CAOMZO5CvmbVmfS8LOYc1J3MDm5dxQmD=aQYr+h6wM2A9d4SPBA@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: fix Freescale firmware location
To: Baruch Siach <baruch@tkos.co.il>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

2016-12-27 8:06 GMT-02:00 Baruch Siach <baruch@tkos.co.il>:
> The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
> by default. Make coda conform with that to ease the update path.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/media/platform/coda/coda-common.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 9e6bdafa16f5..140c02715855 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2078,7 +2078,7 @@ enum coda_platform {
>  static const struct coda_devtype coda_devdata[] = {
>         [CODA_IMX27] = {
>                 .firmware     = {
> -                       "vpu_fw_imx27_TO2.bin",
> +                       "vpu/vpu_fw_imx27_TO2.bin",
>                         "v4l-codadx6-imx27.bin"
>                 },

What about just adding the new path without removing the original one?
This way we avoid breakage for the users that use
"vpu_fw_imx27_TO2.bin" path.
