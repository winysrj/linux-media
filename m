Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:33931 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdK1Jxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 04:53:50 -0500
Date: Tue, 28 Nov 2017 10:53:47 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Riccardo Schirone <sirmy15@gmail.com>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: add missing blank line after declarations
 in atomisp-ov5693
Message-ID: <20171128095347.GE675@w540>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171127214413.10749-2-sirmy15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171127214413.10749-2-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Riccardo,

On Mon, Nov 27, 2017 at 10:44:10PM +0100, Riccardo Schirone wrote:
> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>

No patch can be accepted without a commit message. I know subject is
self-explanatory here, but please add some lines eg. reporting
checkpatch warnings.

Thanks
   j

> ---
>  drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> index 3e7c3851280f..387c65be10f4 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> @@ -82,6 +82,7 @@ static int ad5823_i2c_write(struct i2c_client *client, u8 reg, u8 val)
>  {
>  	struct i2c_msg msg;
>  	u8 buf[2];
> +
>  	buf[0] = reg;
>  	buf[1] = val;
>  	msg.addr = AD5823_VCM_ADDR;
> @@ -98,6 +99,7 @@ static int ad5823_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
>  {
>  	struct i2c_msg msg[2];
>  	u8 buf[2];
> +
>  	buf[0] = reg;
>  	buf[1] = 0;
>
> @@ -228,6 +230,7 @@ static int vcm_detect(struct i2c_client *client)
>  	int i, ret;
>  	struct i2c_msg msg;
>  	u16 data0 = 0, data;
> +
>  	for (i = 0; i < 4; i++) {
>  		msg.addr = VCM_ADDR;
>  		msg.flags = I2C_M_RD;
> @@ -690,6 +693,7 @@ static long ov5693_s_exposure(struct v4l2_subdev *sd,
>  	/* we should not accept the invalid value below */
>  	if (analog_gain == 0) {
>  		struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
>  		v4l2_err(client, "%s: invalid value\n", __func__);
>  		return -EINVAL;
>  	}
> @@ -722,6 +726,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
>  	int ret;
>  	int i;
>  	u8 *b = buf;
> +
>  	dev->otp_size = 0;
>  	for (i = 1; i < OV5693_OTP_BANK_MAX; i++) {
>  		/*set bank NO and OTP read mode. */
> @@ -984,6 +989,7 @@ static int ov5693_t_focus_abs(struct v4l2_subdev *sd, s32 value)
>  static int ov5693_t_focus_rel(struct v4l2_subdev *sd, s32 value)
>  {
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	return ov5693_t_focus_abs(sd, dev->focus + value);
>  }
>
> @@ -1033,6 +1039,7 @@ static int ov5693_q_focus_abs(struct v4l2_subdev *sd, s32 *value)
>  static int ov5693_t_vcm_slew(struct v4l2_subdev *sd, s32 value)
>  {
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	dev->number_of_steps = value;
>  	dev->vcm_update = true;
>  	return 0;
> @@ -1041,6 +1048,7 @@ static int ov5693_t_vcm_slew(struct v4l2_subdev *sd, s32 value)
>  static int ov5693_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
>  {
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	dev->number_of_steps = value;
>  	dev->vcm_update = true;
>  	return 0;
> @@ -1563,6 +1571,7 @@ static int ov5693_set_fmt(struct v4l2_subdev *sd,
>  	struct camera_mipi_info *ov5693_info = NULL;
>  	int ret = 0;
>  	int idx;
> +
>  	if (format->pad)
>  		return -EINVAL;
>  	if (!fmt)
> @@ -1599,6 +1608,7 @@ static int ov5693_set_fmt(struct v4l2_subdev *sd,
>  	ret = startup(sd);
>  	if (ret) {
>  		int i = 0;
> +
>  		dev_err(&client->dev, "ov5693 startup err, retry to power up\n");
>  		for (i = 0; i < OV5693_POWER_UP_RETRY_NUM; i++) {
>  			dev_err(&client->dev,
> @@ -1655,6 +1665,7 @@ static int ov5693_get_fmt(struct v4l2_subdev *sd,
>  {
>  	struct v4l2_mbus_framefmt *fmt = &format->format;
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	if (format->pad)
>  		return -EINVAL;
>
> @@ -1818,6 +1829,7 @@ static int ov5693_s_parm(struct v4l2_subdev *sd,
>  			struct v4l2_streamparm *param)
>  {
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	dev->run_mode = param->parm.capture.capturemode;
>
>  	mutex_lock(&dev->input_lock);
> @@ -1907,6 +1919,7 @@ static int ov5693_remove(struct i2c_client *client)
>  {
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  	struct ov5693_device *dev = to_ov5693_sensor(sd);
> +
>  	dev_dbg(&client->dev, "ov5693_remove...\n");
>
>  	dev->platform_data->csi_cfg(sd, 0);
> --
> 2.14.3
>
