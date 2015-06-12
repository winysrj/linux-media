Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41904 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbbFLGbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:31:21 -0400
Message-ID: <557A7CAD.20700@xs4all.nl>
Date: Fri, 12 Jun 2015 08:31:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 03/15] media: adv7180: add of match table
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-4-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> From: Ben Dooks <ben.dooks@codethink.co.uk>
> 
> Add a proper of match id for use when the device is being bound via
> device tree, to avoid having to use the i2c old-style binding of the
> device.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Signed-off-by: William.Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/i2c/adv7180.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index a493c0b..09a96df 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -25,6 +25,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
>  #include <media/v4l2-ioctl.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
> @@ -1324,11 +1325,21 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
>  #define ADV7180_PM_OPS NULL
>  #endif
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id adv7180_of_id[] = {
> +	{ .compatible = "adi,adv7180", },
> +	{ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, adv7180_of_id);
> +#endif
> +
>  static struct i2c_driver adv7180_driver = {
>  	.driver = {
>  		   .owner = THIS_MODULE,
>  		   .name = KBUILD_MODNAME,
>  		   .pm = ADV7180_PM_OPS,
> +		   .of_match_table = of_match_ptr(adv7180_of_id),
>  		   },
>  	.probe = adv7180_probe,
>  	.remove = adv7180_remove,
> 

