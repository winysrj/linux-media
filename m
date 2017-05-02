Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:59935 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdEBOxL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 10:53:11 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] [media] pxa_camera: Fix a call with an uninitialized device pointer
References: <cover.1493612057.git.petr.cvek@tul.cz>
        <81365c5e-d102-12ba-777f-47c758416cd8@tul.cz>
Date: Tue, 02 May 2017 16:53:09 +0200
In-Reply-To: <81365c5e-d102-12ba-777f-47c758416cd8@tul.cz> (Petr Cvek's
        message of "Mon, 1 May 2017 06:21:57 +0200")
Message-ID: <87shknz4x6.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> In 'commit 295ab497d6357 ("[media] media: platform: pxa_camera: make
> printk consistent")' a pointer to the device structure in
> mclk_get_divisor() was changed to pcdev_to_dev(pcdev). The pointer used
> by pcdev_to_dev() is still uninitialized during the call to
> mclk_get_divisor() as it happens in v4l2_device_register() at the end
> of the probe. The dev_warn and dev_dbg caused a line in the log:
>
> 	(NULL device *): Limiting master clock to 26000000
>
> Fix this by using an initialized pointer from the platform_device
> (as before the old patch).
>
> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
Right, would be good to add to the commit message :
Fixes: 295ab497d635 ("[media] media: platform: pxa_camera: make printk consistent")

And :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert

> ---
>  drivers/media/platform/pxa_camera.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 79fd7269d1e6..c8466c63be22 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -1124,7 +1124,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
>  	/* mclk <= ciclk / 4 (27.4.2) */
>  	if (mclk > lcdclk / 4) {
>  		mclk = lcdclk / 4;
> -		dev_warn(pcdev_to_dev(pcdev),
> +		dev_warn(&pdev->dev,
>  			 "Limiting master clock to %lu\n", mclk);
>  	}
>  
> @@ -1135,7 +1135,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
>  	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
>  		pcdev->mclk = lcdclk / (2 * (div + 1));
>  
> -	dev_dbg(pcdev_to_dev(pcdev), "LCD clock %luHz, target freq %luHz, divisor %u\n",
> +	dev_dbg(&pdev->dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
>  		lcdclk, mclk, div);
>  
>  	return div;
