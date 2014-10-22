Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:15967 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaJVKKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:10:14 -0400
Message-ID: <5447827E.2070200@cisco.com>
Date: Wed, 22 Oct 2014 12:10:06 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 3/5] [media] vivid: convert to platform device
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de> <1413972221-13669-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/22/2014 12:03 PM, Philipp Zabel wrote:
> For contiguous DMA buffer allocation, a struct is needed that
> DMA buffers can be associated with.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice! I was planning something like that myself.

Regards,

	Hans

> ---
>   drivers/media/platform/vivid/vivid-core.c | 37 +++++++++++++++++++++++++++++--
>   1 file changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 2c61a62..c79d60d 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -26,6 +26,7 @@
>   #include <linux/vmalloc.h>
>   #include <linux/font.h>
>   #include <linux/mutex.h>
> +#include <linux/platform_device.h>
>   #include <linux/videodev2.h>
>   #include <linux/v4l2-dv-timings.h>
>   #include <media/videobuf2-vmalloc.h>
> @@ -152,6 +153,7 @@ module_param(no_error_inj, bool, 0444);
>   MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
>
>   static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
> +static struct platform_device *vivid_pdev;
>
>   const struct v4l2_rect vivid_min_rect = {
>   	0, 0, MIN_WIDTH, MIN_HEIGHT
> @@ -1288,7 +1290,7 @@ free_dev:
>      will succeed. This is limited to the maximum number of devices that
>      videodev supports, which is equal to VIDEO_NUM_DEVICES.
>    */
> -static int __init vivid_init(void)
> +static int vivid_probe(struct platform_device *pdev)
>   {
>   	const struct font_desc *font = find_font("VGA8x16");
>   	int ret = 0, i;
> @@ -1323,7 +1325,7 @@ static int __init vivid_init(void)
>   	return ret;
>   }
>
> -static void __exit vivid_exit(void)
> +static int vivid_remove(struct platform_device *pdev)
>   {
>   	struct vivid_dev *dev;
>   	unsigned i;
> @@ -1384,6 +1386,37 @@ static void __exit vivid_exit(void)
>   		kfree(dev);
>   		vivid_devs[i] = NULL;
>   	}
> +
> +	return 0;
> +}
> +
> +struct platform_driver vivid_driver = {
> +	.probe = vivid_probe,
> +	.remove = vivid_remove,
> +	.driver = {
> +		.name = "vivid",
> +	},
> +};
> +
> +static int __init vivid_init(void)
> +{
> +	int ret;
> +
> +	vivid_pdev = platform_device_register_simple("vivid", -1, NULL, 0);
> +	if (IS_ERR(vivid_pdev))
> +		return PTR_ERR(vivid_pdev);
> +
> +	ret = platform_driver_register(&vivid_driver);
> +	if (ret != 0)
> +		platform_device_unregister(vivid_pdev);
> +
> +	return ret;
> +}
> +
> +static void __exit vivid_exit(void)
> +{
> +	platform_device_unregister(vivid_pdev);
> +	platform_driver_unregister(&vivid_driver);
>   }
>
>   module_init(vivid_init);
>

