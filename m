Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaE1OhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 10:37:05 -0400
Message-ID: <1401287823.3054.61.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] [media] mt9v032: do not clear reserved bits in read
 mode register
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 28 May 2014 16:37:03 +0200
In-Reply-To: <50047481.fyhejgQsbG@avalon>
References: <1401112775-18981-1-git-send-email-p.zabel@pengutronix.de>
	 <50047481.fyhejgQsbG@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 28.05.2014, 13:30 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Monday 26 May 2014 15:59:35 Philipp Zabel wrote:
> > The read mode register bits 8 and 9 are set and marked as reserved.
> > Don't clear them.
> 
> Good catch. Have you noticed any issue in practice ?

No. I have no idea what (if anything) those bits actually do, though.

> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/i2c/mt9v032.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 33a110a..052e754 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -415,6 +415,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> > int enable) struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
> >  	struct v4l2_rect *crop = &mt9v032->crop;
> > +	unsigned int read_mode;
> >  	unsigned int hbin;
> >  	unsigned int vbin;
> >  	int ret;
> > @@ -425,9 +426,11 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> > int enable) /* Configure the window size and row/column bin */
> >  	hbin = fls(mt9v032->hratio) - 1;
> >  	vbin = fls(mt9v032->vratio) - 1;
> > -	ret = mt9v032_write(client, MT9V032_READ_MODE,
> > -			    hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> > -			    vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);
> > +	read_mode = mt9v032_read(client, MT9V032_READ_MODE);
> 
> Shouldn't you check the return value for errors here ?

Yes, thanks.

> > +	read_mode &= ~0xff; /* bits 0x300 are reserved */
> 
> What about defining an MT9V032_READ_MODE_RESERVED macro set to 0x0300 and 
> using it here ?

I'll do that.

> > +	read_mode |= hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> > +		     vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT;
> > +	ret = mt9v032_write(client, MT9V032_READ_MODE, read_mode);
> 
> I'm tempted to create an mt9v032_write_read_mode function, as the code is 
> getting a bit complex:
> 
> static int mt9v032_write_read_mode(struct mt9v032 *mt9v032, u16 value)
> {
> 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> 	int ret;
> 
> 	ret = mt9v032_read(client, MT9V032_READ_MODE);
> 	if (ret < 0)
> 		return ret;
> 
> 	ret &= ~MT9V032_READ_MODE_RESERVED;
> 	ret |= value;
> 
> 	return mt9v032_write(client, MT9V032_READ_MODE, ret);
> }
>
> But I'll leave that up to you, feel free to ignore the suggestion.

I'd rather convert the driver to use regmap so we don't have to open
code those read-modify-writes everywhere.

regards
Philipp

