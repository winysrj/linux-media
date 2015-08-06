Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:17549 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753522AbbHFIT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 04:19:59 -0400
Message-ID: <55C318A6.5090005@atmel.com>
Date: Thu, 6 Aug 2015 16:19:50 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] v4l: atmel-isi: Remove unused variable
References: <1438420976-7899-1-git-send-email-laurent.pinchart@ideasonboard.com> <1438420976-7899-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438420976-7899-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 8/1/2015 5:22 PM, Laurent Pinchart wrote:
> Fix a compilation warning by removing an unused local variable in the
> probe function.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/platform/soc_camera/atmel-isi.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 9c900d9569e0..a2e50a734fa3 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -920,7 +920,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
>   	struct atmel_isi *isi;
>   	struct resource *regs;
>   	int ret, i;
> -	struct device *dev = &pdev->dev;

After a further check, I find this patch should be squashed with the 
[PATCH 3/4].
Since 'dev' is used by platform data in atmel_isi_probe() function by 
following code:

	pdata = dev->platform_data;
	if ((!pdata || !pdata->data_width_flags) && !pdev->dev.of_node) {
		dev_err(&pdev->dev,
			"No config available for Atmel ISI\n");
		return -EINVAL;
	}

So if you agree with it, I will squash this patch with
     [PATCH 3/4] Remove support for platform data
in my tree. Does it sound ok for you?

Best Regards,
Josh Wu

>   	struct soc_camera_host *soc_host;
>   	struct isi_platform_data *pdata;
>   

