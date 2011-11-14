Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44293 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab1KNWfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 17:35:24 -0500
Received: by bke11 with SMTP id 11so6425611bke.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 14:35:22 -0800 (PST)
Message-ID: <4EC197A6.3090101@gmail.com>
Date: Mon, 14 Nov 2011 23:35:18 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Heungjun Kim <riverful.kim@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 4/5] m5mols: Add boot flag for not showing the msg of
 I2C error
References: <1319182554-10645-1-git-send-email-riverful.kim@samsung.com> <1319182554-10645-4-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1319182554-10645-4-git-send-email-riverful.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi HeungJun,

Sorry for late review. Please see my comments below..

On 10/21/2011 09:35 AM, HeungJun, Kim wrote:
> In M-5MOLS sensor, the I2C error can be occured before sensor booting done,
> becase I2C interface is not stabilized although the sensor have done already
> for booting, so the right value is deliver through I2C interface. In case,
> it needs to make the I2C error msg not to be printed.
> 
> Signed-off-by: HeungJun, Kim<riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   drivers/media/video/m5mols/m5mols.h      |    2 ++
>   drivers/media/video/m5mols/m5mols_core.c |   17 +++++++++++++----
>   2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
> index 75f7984..0d7e202 100644
> --- a/drivers/media/video/m5mols/m5mols.h
> +++ b/drivers/media/video/m5mols/m5mols.h
> @@ -175,6 +175,7 @@ struct m5mols_version {
>    * @ver: information of the version
>    * @cap: the capture mode attributes
>    * @power: current sensor's power status
> + * @boot: "true" means the M-5MOLS sensor done ARM Booting

How about making this "booting" instead (the opposite meaning) ? Also there is
no need for quotation marks.

>    * @ctrl_sync: true means all controls of the sensor are initialized
>    * @int_capture: true means the capture interrupt is issued once
>    * @lock_ae: true means the Auto Exposure is locked
> @@ -210,6 +211,7 @@ struct m5mols_info {
>   	struct m5mols_version ver;
>   	struct m5mols_capture cap;
>   	bool power;
> +	bool boot;
>   	bool issue;
>   	bool ctrl_sync;
>   	bool lock_ae;
> diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
> index 24e66ad..0aae868 100644
> --- a/drivers/media/video/m5mols/m5mols_core.c
> +++ b/drivers/media/video/m5mols/m5mols_core.c
> @@ -138,6 +138,7 @@ static u32 m5mols_swap_byte(u8 *data, u8 length)
>   static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
>   {
>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
>   	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
>   	u8 category = I2C_CATEGORY(reg);
>   	u8 cmd = I2C_COMMAND(reg);
> @@ -168,8 +169,10 @@ static int m5mols_read(struct v4l2_subdev *sd, u32 size, u32 reg, u32 *val)
> 
>   	ret = i2c_transfer(client->adapter, msg, 2);
>   	if (ret<  0) {
> -		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
> -			 size, category, cmd, ret);
> +		if (info->boot)
> +			v4l2_err(sd,
> +				"read failed: cat:%02x cmd:%02x ret:%d\n",
> +				category, cmd, ret);
>   		return ret;

To avoid dodgy indentation, this could be for instance rewritten as:

   	ret = i2c_transfer(client->adapter, msg, 2);
   	if (ret == 2)
		return 0;

	if (!info->booting)
		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
			 size, category, cmd, ret);

  	return ret < 0 ? ret : -EIO;

>   	}
> 
> @@ -232,6 +235,7 @@ int m5mols_read_u32(struct v4l2_subdev *sd, u32 reg, u32 *val)
>   int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
>   {
>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
>   	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
>   	u8 category = I2C_CATEGORY(reg);
>   	u8 cmd = I2C_COMMAND(reg);
> @@ -263,8 +267,10 @@ int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
> 
>   	ret = i2c_transfer(client->adapter, msg, 1);
>   	if (ret<  0) {
> -		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
> -			size, category, cmd, ret);
> +		if (info->boot)
> +			v4l2_err(sd,
> +				"write failed: cat:%02x cmd:%02x ret:%d\n",
> +				category, cmd, ret);

Ditto.

>   		return ret;
>   	}
> 
> @@ -778,6 +784,7 @@ int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
>    */
>   static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
>   {
> +	struct m5mols_info *info = to_m5mols(sd);
>   	int ret;
> 
>   	/* Execute ARM boot sequence */
> @@ -786,6 +793,8 @@ static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
>   		ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
>   	if (!ret)
>   		ret = m5mols_timeout_interrupt(sd, REG_INT_MODE, 2000);
> +	if (!ret)
> +		info->boot = true;

If you move this line after the check below, there is no need for "if (!ret)".

>   	if (ret<  0)
>   		return ret;
> 

--
Regards,
Sylwester
