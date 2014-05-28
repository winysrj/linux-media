Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32822 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaE1OhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 10:37:11 -0400
Message-ID: <1401287829.3054.62.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 28 May 2014 16:37:09 +0200
In-Reply-To: <1867770.8O19CuciQj@avalon>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
	 <1867770.8O19CuciQj@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 28.05.2014, 13:43 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
>
> On Monday 26 May 2014 16:03:05 Philipp Zabel wrote:
> > From the looks of it, mt9v022 and mt9v032 are very similar,
> > as are mt9v024 and mt9v034. With minimal changes it is possible
> > to support mt9v02[24] with the same driver.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/i2c/mt9v032.c | 56 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 42 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 052e754..617b77f 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
[...]
> > @@ -426,11 +446,9 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> > int enable) /* Configure the window size and row/column bin */
> >  	hbin = fls(mt9v032->hratio) - 1;
> >  	vbin = fls(mt9v032->vratio) - 1;
> > -	read_mode = mt9v032_read(client, MT9V032_READ_MODE);
> > -	read_mode &= ~0xff; /* bits 0x300 are reserved, on MT9V024 */
> > -	read_mode |= hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> > -		     vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT;
> > -	ret = mt9v032_write(client, MT9V032_READ_MODE, read_mode);
> > +	ret = mt9v032_write(client, MT9V032_READ_MODE,
> > +			    hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> > +			    vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);
> 
> Doesn't this change completely reverse one of your previous patches ? Is it 
> needed, or is it included here by mistake ?

That was by mistake. It answers the question whether or not the mt9v02x
sensors work without this change, though: Clearing those two bits
doesn't seem to hurt.

> >  	if (ret < 0)
> >  		return ret;
> > 
> > @@ -902,6 +920,12 @@ static int mt9v032_probe(struct i2c_client *client,
> >  	mt9v032->pdata = pdata;
> >  	mt9v032->model = (const void *)did->driver_data;
> > 
> > +	/* Keep defective pixel correction enabled on MT9V024 */
> > +	ret = mt9v032_read(client, MT9V032_CHIP_CONTROL);
> > +	if (ret < 0)
> > +		return ret;
> > +	mt9v032->chip_control = ret & MT9V024_CHIP_CONTROL_DEF_PIX_CORRECT;
> 
> On the MT9V034 bit 9 is marked as reserved according to revision A of the 
> datasheet, defaults to 1 after power-up and must be written to 0 for proper 
> operation. This could thus break operation on the MT9V034. I don't have a copy 
> of the MT9V022 register reference manual to check what happens on that chip 
> though.

I have seen this described as defect pixel correction enable bit on
mt9v022 in this document:
http://www.videologyinc.com/media/products/application%20notes/APN-24B752XA.pdf

The mt9v02x sensors still seem to work without this bit enabled.
I could split this out into a separate patch.

> > +
> >  	v4l2_ctrl_handler_init(&mt9v032->ctrls, 10);
> > 
> >  	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
> > @@ -1015,6 +1039,10 @@ static int mt9v032_remove(struct i2c_client *client)
> >  }
> > 
> >  static const struct i2c_device_id mt9v032_id[] = {
> > +	{ "mt9v022", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_COLOR] },
> > +	{ "mt9v022m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_MONO] },
> > +	{ "mt9v024", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_COLOR] },
> > +	{ "mt9v024m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_MONO] },
> >  	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_COLOR] },
> >  	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_MONO] },
> >  	{ "mt9v034", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V034_COLOR] },

regards
Philipp

