Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2IWVdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 17:33:38 -0400
Date: Sun, 23 Sep 2012 23:33:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] ov2640: select sensor register bank before applying
 h/v-flip settings
In-Reply-To: <1348431394-30951-1-git-send-email-fschaefer.oss@googlemail.com>
Message-ID: <Pine.LNX.4.64.1209232326090.31250@axis700.grange>
References: <1348431394-30951-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 23 Sep 2012, Frank Schäfer wrote:

> We currently don't select the register bank in ov2640_s_ctrl, so we can end up
> writing to DSP register 0x04 instead of sensor register 0x04.
> This happens for example when calling ov2640_s_ctrl after ov2640_s_fmt.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Cc: stable@kernel.org

Ok, if Linus decides to release 3.6 tomorrow, I anyway don't think it'd be 
reasonable to try to convince him to pull this hours before the release:-) 
So, I'll wait for those other 2 fixes from Peter Senna / coccinelle and 
submit a normal fixes pull request some time tomorrow. Just wondering:

> ---
>  drivers/media/i2c/soc_camera/ov2640.c |    5 +++++
>  1 Datei geändert, 5 Zeilen hinzugefügt(+)

are we soon going to see this line in all possible languages / alphabets / 
logographic systems? ;-)

Thanks
Guennadi

> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 78ac574..d2d298b 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -684,6 +684,11 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
>  		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
>  	struct i2c_client  *client = v4l2_get_subdevdata(sd);
>  	u8 val;
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, BANK_SEL, BANK_SEL_SENS);
> +	if (ret < 0)
> +		return ret;
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
> -- 
> 1.7.10.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
