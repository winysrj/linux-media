Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:58974 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758818AbZCMIVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 04:21:32 -0400
From: Philippe =?iso-8859-15?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: Guennadi Liakhovetski <lg@denx.de>
Subject: Re: [PATCH] mt9t031 bugfix
Date: Fri, 13 Mar 2009 09:21:10 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Longchamp Valentin <valentin.longchamp@epfl.ch>
References: <200903061037.51684.philippe.retornaz@epfl.ch> <Pine.LNX.4.64.0903121754130.4896@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903121754130.4896@axis700.grange>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200903130921.11037.philippe.retornaz@epfl.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Thursday 12 March 2009 18:02:19 Guennadi Liakhovetski, vous avez �crit�:
> On Fri, 6 Mar 2009, Philippe Rétornaz wrote:

> > - The clock polarity is inverted in mt9t031_set_bus_param(), use the
> > correct one.
> >
> > diff --git a/drivers/media/video/mt9t031.c
> > b/drivers/media/video/mt9t031.c index acc1fa9..d846110 100644
> > --- a/drivers/media/video/mt9t031.c
> > +++ b/drivers/media/video/mt9t031.c
> > @@ -144,8 +144,6 @@ static int mt9t031_init(struct soc_camera_device
> > *icd) int ret;
> >
> >  	/* Disable chip output, synchronous option update */
> > -	dev_dbg(icd->vdev->parent, "%s\n", __func__);
> > -
> >  	ret = reg_write(icd, MT9T031_RESET, 1);
> >  	if (ret >= 0)
> >  		ret = reg_write(icd, MT9T031_RESET, 0);
> > @@ -186,9 +184,9 @@ static int mt9t031_set_bus_param(struct
> > soc_camera_device *icd, return -EINVAL;
> >
> >  	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> > -		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> > -	else
> >  		reg_clear(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> > +	else
> > +		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
>
> Why do you think this is the correct one? According to the "Pin
> Description" Table (Table 3 on page 8 in my copy), indeed, it says
>
> <quote>
> Pixel clock: pixel data outputs are valid during falling edge of this
> clock.
> </quote>
>
> which _probably_ should refer to the default configuration, which is
> R10=0, i.e., non-inverted pixclk. In this case you are right. However, in
> Figure "Pixel Color Pattern Detail (Top Right Corner)" (Figure 5 on page
> 10) you see the first pixel green in a red row, and this is what I seem to
> be getting with the current driver, after applying your patch I'm getting
> a red pixel at the start. Are you basing your patch only on Table 3 or you
> verified it practically somehow?

Yes, it has been verified practically on an imx31 with an mt9t031. Without the 
patch, the image color is more or less wrong (some lines/pixels are randomly 
wrong). With the patch, it's working. 

According to page 11, "Output data timing":

"Dout data is valid on the falling edge of PIXCLK in default mode."

The register R10 has a default value of 0x0, so it seems that R10.15 == 0 mean 
falling edge, and 1 mean rising. I've verified with an oscilloscope, with the 
last bit set in register R10, the data are latched on the falling edge, so 
they are valid on the rising edge.

But you're right that the mismatch with the bayer pattern is confusing. Maybe 
the column start is setup wrongly ? 


Thanks
Philippe
