Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2IWVXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 17:23:04 -0400
Date: Sun, 23 Sep 2012 23:23:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ov2640: simplify single register writes
In-Reply-To: <505F6BAF.90307@googlemail.com>
Message-ID: <Pine.LNX.4.64.1209232316160.31250@axis700.grange>
References: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com>
 <1348424926-12864-3-git-send-email-fschaefer.oss@googlemail.com>
 <Pine.LNX.4.64.1209232239210.31250@axis700.grange> <505F6BAF.90307@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 23 Sep 2012, Frank Schäfer wrote:

> Am 23.09.2012 23:43, schrieb Guennadi Liakhovetski:
> > On Sun, 23 Sep 2012, Frank Schäfer wrote:
> >
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>  drivers/media/i2c/soc_camera/ov2640.c |   17 ++++++++---------
> >>  1 Datei geändert, 8 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)
> >>
> >> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> >> index 182d5a1..e71bf4c 100644
> >> --- a/drivers/media/i2c/soc_camera/ov2640.c
> >> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> >> @@ -639,17 +639,19 @@ static struct ov2640_priv *to_ov2640(const struct i2c_client *client)
> >>  			    subdev);
> >>  }
> >>  
> >> +static int ov2640_write_single(struct i2c_client *client, u8  reg, u8 val)
> >> +{
> >> +	dev_vdbg(&client->dev, "write: 0x%02x, 0x%02x", reg, val);
> >> +	return i2c_smbus_write_byte_data(client, reg, val);
> >> +}
> > Well, I'm not convinced. I don't necessarily see it as a simplification. 
> > You replace one perfectly ok function with another one with exactly the 
> > same parameters. Ok, you also hide a debug printk() in your wrapper, but 
> > that's not too useful either, IMHO.
> 
> Sure, at the moment this is not really needed. But that will change in
> the future, when we need to do more single writes / can't use static
> register sequences.

Why won't you be able to just use i2c_smbus_write_byte_data() directly 
with those your sequences? Ok, if you just dislike the long name, and if 
you have a number of them, I might buy that as a valid reason:-) And yes, 
it'd be good to add such a helper function in a separate patch, preceding 
the actual functional changes. But then I'd probably suggest to name, that 
offers an even greater saving of your monitor real estate and is more 
similar to what other drivers use, something like ov2640_reg_write() and 
also add an ov2640_reg_read() for symmetry.

Thanks
Guennadi

> A good example is the powerline frequency filter control, which I'm
> currently experimenting with.
> But if you don't want to take it at the moment, it's ok for me.
> 
> 
> > Besides, you're missing more calls to 
> > i2c_smbus_write_byte_data() in ov2640_mask_set(), ov2640_s_register() and 
> > ov2640_video_probe(). So, I'd just drop it.
> 
> I skipped that because of the different debug output (which could of
> course be improved).
> 
> Regrads,
> Frank
> 
> > Thanks
> > Guennadi
> >
> >> +
> >>  static int ov2640_write_array(struct i2c_client *client,
> >>  			      const struct regval_list *vals)
> >>  {
> >>  	int ret;
> >>  
> >>  	while ((vals->reg_num != 0xff) || (vals->value != 0xff)) {
> >> -		ret = i2c_smbus_write_byte_data(client,
> >> -						vals->reg_num, vals->value);
> >> -		dev_vdbg(&client->dev, "array: 0x%02x, 0x%02x",
> >> -			 vals->reg_num, vals->value);
> >> -
> >> +		ret = ov2640_write_single(client, vals->reg_num, vals->value);
> >>  		if (ret < 0)
> >>  			return ret;
> >>  		vals++;
> >> @@ -704,13 +706,10 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
> >>  	struct v4l2_subdev *sd =
> >>  		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
> >>  	struct i2c_client  *client = v4l2_get_subdevdata(sd);
> >> -	struct regval_list regval;
> >>  	int ret;
> >>  	u8 val;
> >>  
> >> -	regval.reg_num = BANK_SEL;
> >> -	regval.value = BANK_SEL_SENS;
> >> -	ret = ov2640_write_array(client, &regval);
> >> +	ret = ov2640_write_single(client, BANK_SEL, BANK_SEL_SENS);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> >> -- 
> >> 1.7.10.4
> >>
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
