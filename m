Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYLpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:45:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: a.andreyanau@sam-solutions.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9p031 camera driver issue
Date: Thu, 25 Apr 2013 13:45:17 +0200
Message-ID: <2367258.ZkP6tu2Tsn@avalon>
In-Reply-To: <517787DC.5070309@sam-solutions.com>
References: <517787DC.5070309@sam-solutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrei,

On Wednesday 24 April 2013 10:21:00 Andrei Andreyanau wrote:
> Hi, Guennadi!
> I have found interesting issue with mt9p031 camera driver.
> As far as I got the value of hblank in the kernel driver is not
> calculated correctly. According to the datasheet, the minimum horizontal
> blanking value should be calculated using the following formula:
> 346 x (Row_Bin + 1) + 64 + (Wdc / 2)
> If I'm right, it should look like in the code attached.

Row_Bin is ybin, not xbin. Furthermore, the Row_Bin value starts at 0, while 
the ybin value starts at 1. I thus I believe the driver code is correct.

> Also I wonder why it is decided to use the default value for vblank,
> when it's said that is also should be calculated like this:
> vblank = max(8, SW - H) + 1,
> where SW - shutter width, H - output image height.

That could be fixed, indeed.

> Also, there might be an issue with the calculation of xskip/yskip within
> the same function (mt9p031_set_params).
> 
> xskip = DIV_ROUND_CLOSEST(crop->width, format->width);
> yskip = DIV_ROUND_CLOSEST(crop->height, format->height);
> 
> As far as I got, these values are calculated using the predefined macros,
> that rounds the calculated value to the nearest integer number. I faced
> with the problem, that these values rounded correctly when the result
> is > 1 (e.g. 1,5 will be rounded to 1).
> But what concerns the value 0,8 it will be rounded to 0 by this function
> (DIV_ROUND_CLOSEST). Could you please confirm this issue?

The format rectangle should always be smaller than or equal to the crop 
rectangle, so the xskip and yskip values should never be smaller than 1. If 
that happens, it's a driver bug.

> Signed-off-by: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index e328332..838b300 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -368,7 +368,7 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
>  	/* Blanking - use minimum value for horizontal blanking and default
>  	 * value for vertical blanking.
>  	 */
> -	hblank = 346 * ybin + 64 + (80 >> min_t(unsigned int, xbin, 3));
> +	hblank = 346 * (xbin + 1) + 64 + ((80 >> clamp_t(unsigned int, xbin,
> 0, 3)) / 2);
>  	vblank = MT9P031_VERTICAL_BLANK_DEF;
> 
>  	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank - 1);

-- 
Regards,

Laurent Pinchart
