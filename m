Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51035 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1JVUZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Oct 2011 16:25:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH V2] v4l: use i2c_smbus_read_word_swapped
Date: Sat, 22 Oct 2011 10:57:50 +0200
Cc: linux-media@vger.kernel.org, khali@linux-fr.org,
	kernel@pengutronix.de, robert.jarzmik@free.fr
References: <20111021144652.6aa97c8f@endymion.delvare> <1319203825-23247-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1319203825-23247-1-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110221057.51218.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

Thanks for the patch.

On Friday 21 October 2011 15:30:25 Jonathan Cameron wrote:
> Function ensures that error codes don't get mangled.
> Dependant on:
> i2c: boilerplate function for byte swapped  smbus_write/read_word_data
> which is working it's way through the i2c tree.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> Acked-by: Jean Delvare <khali@linux-fr.org>

For the mt9v032 driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The mt9t001 and mt9p031 drivers should be fixed similarly. I'll send a patch.

> ---
> 
> V2: Stray line removed as per Jean's comment.  Thanks Jean.
> 
> Dependency due to go upstream during next merge window.
> 
>  drivers/media/video/mt9m001.c |    5 ++---
>  drivers/media/video/mt9m111.c |    7 +++----
>  drivers/media/video/mt9t031.c |    5 ++---
>  drivers/media/video/mt9v022.c |    5 ++---
>  drivers/media/video/mt9v032.c |    8 ++++----
>  5 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index 4da9cca..862a300 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -102,14 +102,13 @@ static struct mt9m001 *to_mt9m001(const struct
> i2c_client *client)
> 
>  static int reg_read(struct i2c_client *client, const u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> -	return data < 0 ? data : swab16(data);
> +	return i2c_smbus_read_word_swapped(client, reg);
>  }
> 
>  static int reg_write(struct i2c_client *client, const u8 reg,
>  		     const u16 data)
>  {
> -	return i2c_smbus_write_word_data(client, reg, swab16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
> 
>  static int reg_set(struct i2c_client *client, const u8 reg,
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index a357aa8..41b3029 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -210,7 +210,7 @@ static int reg_page_map_set(struct i2c_client *client,
> const u16 reg) if (page > 2)
>  		return -EINVAL;
> 
> -	ret = i2c_smbus_write_word_data(client, MT9M111_PAGE_MAP, swab16(page));
> +	ret = i2c_smbus_write_word_swapped(client, MT9M111_PAGE_MAP, page);
>  	if (!ret)
>  		lastpage = page;
>  	return ret;
> @@ -222,7 +222,7 @@ static int mt9m111_reg_read(struct i2c_client *client,
> const u16 reg)
> 
>  	ret = reg_page_map_set(client, reg);
>  	if (!ret)
> -		ret = swab16(i2c_smbus_read_word_data(client, reg & 0xff));
> +		ret = i2c_smbus_read_word_swapped(client, reg & 0xff);
> 
>  	dev_dbg(&client->dev, "read  reg.%03x -> %04x\n", reg, ret);
>  	return ret;
> @@ -235,8 +235,7 @@ static int mt9m111_reg_write(struct i2c_client *client,
> const u16 reg,
> 
>  	ret = reg_page_map_set(client, reg);
>  	if (!ret)
> -		ret = i2c_smbus_write_word_data(client, reg & 0xff,
> -						swab16(data));
> +		ret = i2c_smbus_write_word_swapped(client, reg & 0xff, data);
>  	dev_dbg(&client->dev, "write reg.%03x = %04x -> %d\n", reg, data, ret);
>  	return ret;
>  }
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index 30547cc..e4ac238 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -81,14 +81,13 @@ static struct mt9t031 *to_mt9t031(const struct
> i2c_client *client)
> 
>  static int reg_read(struct i2c_client *client, const u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> -	return data < 0 ? data : swab16(data);
> +	return i2c_smbus_read_word_swapped(client, reg);
>  }
> 
>  static int reg_write(struct i2c_client *client, const u8 reg,
>  		     const u16 data)
>  {
> -	return i2c_smbus_write_word_data(client, reg, swab16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
> 
>  static int reg_set(struct i2c_client *client, const u8 reg,
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index 51b0fcc..d5272d9 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -116,14 +116,13 @@ static struct mt9v022 *to_mt9v022(const struct
> i2c_client *client)
> 
>  static int reg_read(struct i2c_client *client, const u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> -	return data < 0 ? data : swab16(data);
> +	return i2c_smbus_read_word_swapped(client, reg);
>  }
> 
>  static int reg_write(struct i2c_client *client, const u8 reg,
>  		     const u16 data)
>  {
> -	return i2c_smbus_write_word_data(client, reg, swab16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
> 
>  static int reg_set(struct i2c_client *client, const u8 reg,
> diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
> index c64e1dc..7906929 100644
> --- a/drivers/media/video/mt9v032.c
> +++ b/drivers/media/video/mt9v032.c
> @@ -138,10 +138,10 @@ static struct mt9v032 *to_mt9v032(struct v4l2_subdev
> *sd)
> 
>  static int mt9v032_read(struct i2c_client *client, const u8 reg)
>  {
> -	s32 data = i2c_smbus_read_word_data(client, reg);
> +	s32 data = i2c_smbus_read_word_swapped(client, reg);
>  	dev_dbg(&client->dev, "%s: read 0x%04x from 0x%02x\n", __func__,
> -		swab16(data), reg);
> -	return data < 0 ? data : swab16(data);
> +		data, reg);
> +	return data;
>  }
> 
>  static int mt9v032_write(struct i2c_client *client, const u8 reg,
> @@ -149,7 +149,7 @@ static int mt9v032_write(struct i2c_client *client,
> const u8 reg, {
>  	dev_dbg(&client->dev, "%s: writing 0x%04x to 0x%02x\n", __func__,
>  		data, reg);
> -	return i2c_smbus_write_word_data(client, reg, swab16(data));
> +	return i2c_smbus_write_word_swapped(client, reg, data);
>  }
> 
>  static int mt9v032_set_chip_control(struct mt9v032 *mt9v032, u16 clear,
> u16 set)

-- 
Regards,

Laurent Pinchart
