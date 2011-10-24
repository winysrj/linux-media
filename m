Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:42304 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab1JXI0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 04:26:36 -0400
Message-ID: <4EA52143.50806@cam.ac.uk>
Date: Mon, 24 Oct 2011 09:26:43 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, khali@linux-fr.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] v4l: mt9p031/mt9t001: Use i2c_smbus_{read|write}_word_swapped()
References: <20111021144652.6aa97c8f@endymion.delvare> <1319203825-23247-1-git-send-email-jic23@cam.ac.uk> <201110221057.54573.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110221057.54573.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/22/11 09:57, Laurent Pinchart wrote:
> The MT9P031 and MT9T001 sensors transfer 16-bit data on the I2C bus in
> swapped order. Let the I2C core handle byte order by using the
> i2c_smbus_{read|write}_word_swapped() functions.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/media/video/mt9p031.c |    5 ++---
>  drivers/media/video/mt9t001.c |    5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> index 5cfa39f..aa01c4b 100644
> --- a/drivers/media/video/mt9p031.c
> +++ b/drivers/media/video/mt9p031.c
> @@ -131,13 +131,12 @@ static struct mt9p031 *to_mt9p031(struct v4l2_subdev *sd)
>  
>  static int mt9p031_read(struct i2c_client *client, u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> -	return data < 0 ? data : be16_to_cpu(data);
> +	return i2c_smbus_read_word_swapped(client, reg);
>  }
>  
>  static int mt9p031_write(struct i2c_client *client, u8 reg, u16 data)
>  {
> -	return i2c_smbus_write_word_data(client, reg, cpu_to_be16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
>  
>  static int mt9p031_set_output_control(struct mt9p031 *mt9p031, u16 clear,
> diff --git a/drivers/media/video/mt9t001.c b/drivers/media/video/mt9t001.c
> index cac1416..2ea6a08 100644
> --- a/drivers/media/video/mt9t001.c
> +++ b/drivers/media/video/mt9t001.c
> @@ -132,13 +132,12 @@ static inline struct mt9t001 *to_mt9t001(struct v4l2_subdev *sd)
>  
>  static int mt9t001_read(struct i2c_client *client, u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> -	return data < 0 ? data : be16_to_cpu(data);
> +	return i2c_smbus_read_word_swapped(client, reg);
>  }
>  
>  static int mt9t001_write(struct i2c_client *client, u8 reg, u16 data)
>  {
> -	return i2c_smbus_write_word_data(client, reg, cpu_to_be16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
>  
>  static int mt9t001_set_output_control(struct mt9t001 *mt9t001, u16 clear,

