Return-path: <mchehab@pedra>
Received: from mail.phytec.de ([217.6.246.34]:45353 "EHLO root.phytec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab1ESLHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 07:07:22 -0400
Subject: Re: [PATCH 2/2] mt9m111: fix pixel clock
From: Teresa Gamez <T.Gamez@phytec.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1105181309320.16324@axis700.grange>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
	 <1302098515-12176-2-git-send-email-t.gamez@phytec.de>
	 <Pine.LNX.4.64.1105181309320.16324@axis700.grange>
Date: Thu, 19 May 2011 13:07:58 +0200
Message-ID: <1305803278.28630.100.camel@lws-gamez>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Mittwoch, den 18.05.2011, 13:12 +0200 schrieb Guennadi Liakhovetski:
> Hi Teresa
> 
> I've verified the mt9v022 patch - finally I have noticed the difference, 
> it does look correct! As for this one, how about this version of your 
> patch:

Great! Thank you.

> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index 53fa2a7..ebebed9 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -315,10 +315,20 @@ static int mt9m111_setup_rect(struct i2c_client *client,
>  static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
>  {
>  	int ret;
> +	u16 mask = MT9M111_OUTFMT_PROCESSED_BAYER | MT9M111_OUTFMT_RGB |
> +		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_SWAP_RGB_EVEN |
> +		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
> +		MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr |
> +		MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
>  
> -	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
> +	ret = reg_read(OUTPUT_FORMAT_CTRL2_A);
> +	if (ret >= 0)
> +		ret = reg_write(OUTPUT_FORMAT_CTRL2_A, (ret & ~mask) | outfmt);
>  	if (!ret)
> -		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, outfmt);
> +		ret = reg_read(OUTPUT_FORMAT_CTRL2_B);
> +	if (ret >= 0)
> +		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, (ret & ~mask) | outfmt);
> +
>  	return ret;
>  }
>  
> 
> It reduces the number of I2C accesses and avoids writing some not 
> necessarily desired value to the register. Does this look ok to you? Could 
> you maybe test - I've got no mt9m111 cameras.
> 

Yes, this looks good. And I tested it successfully with a mt9m131.

Tested-by: Teresa Gámez <t.gamez@phytec.de>

Teresa

> Thanks
> Guennadi
> 
> On Wed, 6 Apr 2011, Teresa Gámez wrote:
> 
> > This camera driver supports only rising edge, which is the default
> > setting of the device. The function mt9m111_setup_pixfmt() overwrites
> > this setting. So the driver actually uses falling edge.
> > This patch corrects that.
> > 
> > Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
> > ---
> >  drivers/media/video/mt9m111.c |   14 ++++++++++++--
> >  1 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index 53fa2a7..4040a96 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> > @@ -315,10 +315,20 @@ static int mt9m111_setup_rect(struct i2c_client *client,
> >  static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
> >  {
> >  	int ret;
> > +	u16 mask = MT9M111_OUTFMT_PROCESSED_BAYER | MT9M111_OUTFMT_RGB |
> > +		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_SWAP_RGB_EVEN |
> > +		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
> > +		MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr |
> > +		MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
> >  
> > -	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
> > +	ret = reg_clear(OUTPUT_FORMAT_CTRL2_A, mask);
> >  	if (!ret)
> > -		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, outfmt);
> > +		ret = reg_set(OUTPUT_FORMAT_CTRL2_A, outfmt);
> > +	if (!ret)
> > +		ret = reg_clear(OUTPUT_FORMAT_CTRL2_B, mask);
> > +	if (!ret)
> > +		ret = reg_set(OUTPUT_FORMAT_CTRL2_B, outfmt);
> > +
> >  	return ret;
> >  }
> >  
> > -- 
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


