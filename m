Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43139 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751527AbdCHKik (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 05:38:40 -0500
Subject: Re: [PATCH] [media] coda: restore original firmware locations
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170301153625.16249-1-p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <39366381-61a4-ec56-e94d-e60173d3b5f9@xs4all.nl>
Date: Wed, 8 Mar 2017 11:38:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170301153625.16249-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/17 16:36, Philipp Zabel wrote:
> Recently, an unfinished patch was merged that added a third entry to the
> beginning of the array of firmware locations without changing the code
> to also look at the third element, thus pushing an old firmware location
> off the list.
>
> Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
> Cc: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-common.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index eb6548f46cbac..e1a2e8c70db01 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2128,6 +2128,9 @@ static int coda_firmware_request(struct coda_dev *dev)
>  {
>  	char *fw = dev->devtype->firmware[dev->firmware];
>
> +	if (dev->firmware >= ARRAY_SIZE(dev->devtype->firmware))
> +		return -EINVAL;
> +

Move the fw assignment after this 'if'. Otherwise it's reading from undefined memory
if dev->firmware >= ARRAY_SIZE(dev->devtype->firmware).

Regards,

	Hans

>  	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
>  		coda_product_name(dev->devtype->product));
>
> @@ -2142,16 +2145,16 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	struct platform_device *pdev = dev->plat_dev;
>  	int i, ret;
>
> -	if (!fw && dev->firmware == 1) {
> -		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
> -		goto put_pm;
> -	}
>  	if (!fw) {
> -		dev->firmware = 1;
> -		coda_firmware_request(dev);
> +		dev->firmware++;
> +		ret = coda_firmware_request(dev);
> +		if (ret < 0) {
> +			v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
> +			goto put_pm;
> +		}
>  		return;
>  	}
> -	if (dev->firmware == 1) {
> +	if (dev->firmware > 0) {
>  		/*
>  		 * Since we can't suppress warnings for failed asynchronous
>  		 * firmware requests, report that the fallback firmware was
>
