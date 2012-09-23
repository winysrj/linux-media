Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2IWUVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 16:21:52 -0400
Date: Sun, 23 Sep 2012 22:21:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ov2640: select sensor register bank before applying
 h/v-flip settings
In-Reply-To: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
Message-ID: <Pine.LNX.4.64.1209232217260.31250@axis700.grange>
References: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank

On Sun, 23 Sep 2012, Frank Schäfer wrote:

> We currently don't select the register bank in ov2640_s_ctrl, so we can end up
> writing to DSP register 0x04 instead of sensor register 0x04.
> This happens for example when calling ov2640_s_ctrl after ov2640_s_fmt.

Yes, in principle, I agree, bank switching in the driver is not very... 
consistent and also this specific case looks buggy. But, we have to fix 
your fix.

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Cc: stable@kernel.org
> ---
>  drivers/media/i2c/soc_camera/ov2640.c |    8 ++++++++
>  1 Datei geändert, 8 Zeilen hinzugefügt(+)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 78ac574..e4fc79e 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -683,8 +683,16 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
>  	struct v4l2_subdev *sd =
>  		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
>  	struct i2c_client  *client = v4l2_get_subdevdata(sd);
> +	struct regval_list regval;
> +	int ret;
>  	u8 val;
>  
> +	regval.reg_num = BANK_SEL;
> +	regval.value = BANK_SEL_SENS;
> +	ret = ov2640_write_array(client, &regval);

This doesn't look right to me. ov2640_write_array() keeps writing register 
address - value pairs to the hardware until it encounters an "ENDMARKER," 
which you don't have here, so, it's hard to say what will be written to 
the sensor... Secondly, you only have to write a single register here, for 
this the driver is already using i2c_smbus_write_byte_data() directly, 
please, do the same.

Thanks
Guennadi

> +	if (ret < 0)
> +		return ret;
> +
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
>  		val = ctrl->val ? REG04_VFLIP_IMG : 0x00;
> -- 
> 1.7.10.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
