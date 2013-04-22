Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56908 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3DVMTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:19:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 18/24] V4L2: mt9p031: power down the sensor if no supported device has been detected
Date: Mon, 22 Apr 2013 14:19:13 +0200
Message-ID: <1756723.mDdT6UkUyR@avalon>
In-Reply-To: <1366320945-21591-19-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <1366320945-21591-19-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Thursday 18 April 2013 23:35:39 Guennadi Liakhovetski wrote:
> The mt9p031 driver first accesses the I2C device in its .registered()
> method. While doing that it furst powers the device up, but if probing

s/furst/first/

> fails, it doesn't power the chip back down. This patch fixes that bug.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> ---
>  drivers/media/i2c/mt9p031.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index eb2de22..70f4525 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -844,7 +844,7 @@ static int mt9p031_registered(struct v4l2_subdev
> *subdev) ret = mt9p031_power_on(mt9p031);
>  	if (ret < 0) {
>  		dev_err(&client->dev, "MT9P031 power up failed\n");
> -		return ret;
> +		goto done;

Not here. If power on fails, there's no need to power off.

>  	}
> 
>  	/* Read out the chip version register */
> @@ -852,13 +852,15 @@ static int mt9p031_registered(struct v4l2_subdev
> *subdev) if (data != MT9P031_CHIP_VERSION_VALUE) {
>  		dev_err(&client->dev, "MT9P031 not detected, wrong version "
>  			"0x%04x\n", data);
> -		return -ENODEV;
> +		ret = -ENODEV;
>  	}
> 
> +done:
>  	mt9p031_power_off(mt9p031);
> 
> -	dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
> -		 client->addr);
> +	if (!ret)
> +		dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
> +			 client->addr);
> 
>  	return ret;
>  }

It would be easier to just move the power off line right after the 
mt9p031_read() call and leave the rest unchanged.

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 28cf95b..8de84c0 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -849,18 +849,18 @@ static int mt9p031_registered(struct v4l2_subdev 
*subdev)
 
        /* Read out the chip version register */
        data = mt9p031_read(client, MT9P031_CHIP_VERSION);
+       mt9p031_power_off(mt9p031);
+
        if (data != MT9P031_CHIP_VERSION_VALUE) {
                dev_err(&client->dev, "MT9P031 not detected, wrong version "
                        "0x%04x\n", data);
                return -ENODEV;
        }
 
-       mt9p031_power_off(mt9p031);
-
        dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
                 client->addr);
 
-       return ret;
+       return 0;
 }
 
 static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh 
*fh)

If you're happy with that there's no need to resubmit, I'll apply the patch to 
my tree for v3.11.

-- 
Regards,

Laurent Pinchart

