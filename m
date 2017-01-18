Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38601 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755937AbdARLbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 06:31:40 -0500
Message-ID: <1484739029.2356.7.camel@pengutronix.de>
Subject: Re: [PATCH v3] [media] coda: add Freescale firmware compatibility
 location
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Date: Wed, 18 Jan 2017 12:30:29 +0100
In-Reply-To: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
References: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

On Sun, 2017-01-15 at 12:33 +0200, Baruch Siach wrote:
> The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
> by default. Make coda look there for firmware files to ease the update path.
> 
> Cc: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v3: adjust the number of firmware locations in coda_devtype (kbuild test robot)
> 
> v2: add compatibility path; don't change existing path (Fabio)
> ---
>  drivers/media/platform/coda/coda-common.c | 4 ++++
>  drivers/media/platform/coda/coda.h        | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 9e6bdafa16f5..ce0d00f3f3ba 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2079,6 +2079,7 @@ static const struct coda_devtype coda_devdata[] = {
>  	[CODA_IMX27] = {
>  		.firmware     = {
>  			"vpu_fw_imx27_TO2.bin",
> +			"vpu/vpu_fw_imx27_TO2.bin",
>  			"v4l-codadx6-imx27.bin"
>  		},
>  		.product      = CODA_DX6,
> @@ -2092,6 +2093,7 @@ static const struct coda_devtype coda_devdata[] = {
>  	[CODA_IMX53] = {
>  		.firmware     = {
>  			"vpu_fw_imx53.bin",
> +			"vpu/vpu_fw_imx53.bin",
>  			"v4l-coda7541-imx53.bin"
>  		},
>  		.product      = CODA_7541,
> @@ -2106,6 +2108,7 @@ static const struct coda_devtype coda_devdata[] = {
>  	[CODA_IMX6Q] = {
>  		.firmware     = {
>  			"vpu_fw_imx6q.bin",
> +			"vpu/vpu_fw_imx6q.bin",
>  			"v4l-coda960-imx6q.bin"
>  		},
>  		.product      = CODA_960,
> @@ -2120,6 +2123,7 @@ static const struct coda_devtype coda_devdata[] = {
>  	[CODA_IMX6DL] = {
>  		.firmware     = {
>  			"vpu_fw_imx6d.bin",
> +			"vpu/vpu_fw_imx6d.bin",
>  			"v4l-coda960-imx6dl.bin"
>  		},
>  		.product      = CODA_960,
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 53f96661683c..8490bcb1fde2 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -50,7 +50,7 @@ enum coda_product {
>  struct coda_video_device;
>  
>  struct coda_devtype {
> -	char			*firmware[2];
> +	char			*firmware[3];
>  	enum coda_product	product;
>  	const struct coda_codec	*codecs;
>  	unsigned int		num_codecs;

To increase the number of firmware paths, coda_fw_callback has to be
modified, too. Otherwise it will just ignore firmware[2]:

 static void coda_fw_callback(const struct firmware *fw, void *context)
 {
 	struct coda_dev *dev = context;
 	struct platform_device *pdev = dev->plat_dev;
 	int i, ret;

-	if (!fw && dev->firmware == 1) {
+	if (!fw && dev->firmware == 2) {
 		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
 		goto put_pm;
 	}
 	if (!fw) {
-		dev->firmware = 1;
+		dev->firmware++;
 		coda_firmware_request(dev);
 		return;
 	}
-	if (dev->firmware == 1) {
+	if (dev->firmware > 0) {
 		/*                                                                                                                            
 		 * Since we can't suppress warnings for failed asynchronous
 		 * firmware requests, report that the fallback firmware was
 		 * found.
 		 */
 		dev_info(&pdev->dev, "Using fallback firmware %s\n",
 			 dev->devtype->firmware[dev->firmware]);
 	}

regards
Philipp

