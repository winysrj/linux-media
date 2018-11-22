Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:59654 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731714AbeKVTgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 14:36:04 -0500
Subject: Re: [PATCH v2 2/2] media: video-i2c: add Melexis MLX90640 thermal
 camera support
To: Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
References: <20181122035229.3630-1-matt.ranostay@konsulko.com>
 <20181122035229.3630-3-matt.ranostay@konsulko.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4e408e8a-414b-a6cd-37c6-ce3a378c6e25@xs4all.nl>
Date: Thu, 22 Nov 2018 09:57:28 +0100
MIME-Version: 1.0
In-Reply-To: <20181122035229.3630-3-matt.ranostay@konsulko.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/2018 04:52 AM, Matt Ranostay wrote:
> Add initial support for MLX90640 thermal cameras which output an 32x24
> greyscale pixel image along with 2 rows of coefficent data.
> 
> Because of this the data outputed is really 32x26 and needs the two rows
> removed after using the coefficent information to generate processed
> images in userspace.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
>  .../bindings/media/i2c/melexis,mlx90640.txt   |  20 ++++
>  drivers/media/i2c/Kconfig                     |   1 +
>  drivers/media/i2c/video-i2c.c                 | 110 +++++++++++++++++-
>  3 files changed, 130 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> new file mode 100644
> index 000000000000..060d2b7a5893
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> @@ -0,0 +1,20 @@
> +* Melexis MLX90640 FIR Sensor
> +
> +Melexis MLX90640 FIR sensor support which allows recording of thermal data
> +with 32x24 resolution excluding 2 lines of coefficient data that is used by
> +userspace to render processed frames.

So this means that the image doesn't conform to V4L2_PIX_FMT_Y12!

I missed that the first time around.

You have three options here:

1) Create a new V4L2_PIX_FMT define + documentation describing the format that
   this device produces.

2) Split off the image from the meta data and create a new META_CAPTURE device
   node. For the META device node you would again have to document the format

3) Split off the image from the meta data and store the meta data in a V4L2
   control, which again has to be documented.

I'm leaning towards 1 since that's easiest to implement. But the key is that
you should document those two lines. The datasheet is publicly available,
so you can refer to it for details.

Those extra two lines return addresses 0x700-0x73f, right? Is it even sufficient
to calculate the relevant data from just those lines? Looking at 11.2.2 there
is a whole calculation that should be done that is also dependent on the eeprom
values, which are not exported.

I wonder if it isn't the job of the driver to do all the calculations. It has
all the information it needs and looking at the datasheet it seems all the
calculations are integer based, so it shouldn't be too difficult. This would
be a fourth option.

BTW, did we document somewhere what the panasonic device returns? It returns
Y12 data, but what does that data mean? In order to use this in userspace you
need to be able to convert it to temperatures, so how is that done?

Regards,

	Hans

> +
> +Required Properties:
> + - compatible : Must be "melexis,mlx90640"
> + - reg : i2c address of the device
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		mlx90640@33 {
> +			compatible = "melexis,mlx90640";
> +			reg = <0x33>;
> +		};
> +		...
> +	};
