Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47763 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2K2Uv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 15:51:57 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so6492186bkw.19
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 12:51:56 -0800 (PST)
Message-ID: <50B7CAE8.7020104@gmail.com>
Date: Thu, 29 Nov 2012 21:51:52 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Enric Balletbo i Serra <eballetbo@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, s.nawrocki@samsung.com,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Subject: Re: [PATCH] [media] v4l: Add mt9v034 sensor driver
References: <1349433287-28628-1-git-send-email-eballetbo@gmail.com>
In-Reply-To: <1349433287-28628-1-git-send-email-eballetbo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enric,

In general this driver looks good to me. However it seems you're
using it together with the omap3isp driver. Likely Laurent and Sakari
may have some comments on that.

Just one thing I'm unsure about, please see below.

On 10/05/2012 12:34 PM, Enric Balletbo i Serra wrote:
> From: Enric Balletbo i Serra<eballetbo@iseebcn.com>
>
> The MT9V034 is a parallel wide VGA sensor from Aptina (formerly Micron)
> controlled through I2C.
>
> The driver creates a V4L2 subdevice. It currently supports binning and
> cropping, and the gain, auto gain, exposure, auto exposure and test
> pattern controls.
>
> The following patch is based on the MT9V032 driver from Laurent Pinchart
> and was tested on IGEP tech based boards with custom expansion board with
> MT9V034 sensor.
>
> Signed-off-by: Enric Balletbo i Serra<eballetbo@iseebcn.com>
> ---
>   drivers/media/i2c/Kconfig   |   10 +
>   drivers/media/i2c/Makefile  |    1 +
>   drivers/media/i2c/mt9v034.c |  834 +++++++++++++++++++++++++++++++++++++++++++
>   include/media/mt9v034.h     |   15 +
>   4 files changed, 860 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/i2c/mt9v034.c
>   create mode 100644 include/media/mt9v034.h
...
> +static int mt9v034_enum_frame_size(struct v4l2_subdev *subdev,
> +				   struct v4l2_subdev_fh *fh,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	if (fse->index>= 8 || fse->code != V4L2_MBUS_FMT_SBGGR10_1X10)
> +		return -EINVAL;
> +
> +	fse->min_width = MT9V034_WINDOW_WIDTH_DEF / fse->index;
> +	fse->max_width = fse->min_width;
> +	fse->min_height = MT9V034_WINDOW_HEIGHT_DEF / fse->index;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}

Have you actually tested VIDIOC_SUBDEV_ENUM_FRAME_SIZE ioctl with the index
field set to 0 ? Shouldn't (fse->index + 1) be used as a denominator 
instead ?

--

Regards,
Sylwester
