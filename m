Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51038 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753572AbZDBRg1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 13:36:27 -0400
Date: Thu, 2 Apr 2009 19:36:40 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mt9t031: use platform power hook
In-Reply-To: <49D4F633.1040806@gmail.com>
Message-ID: <Pine.LNX.4.64.0904021935350.5263@axis700.grange>
References: <Pine.LNX.4.64.0904021149580.5263@axis700.grange>
 <49D4F633.1040806@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Apr 2009, Darius Augulis wrote:

> Guennadi Liakhovetski wrote:
> > Use platform power hook to turn the camera on and off.
> > 
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > ---
> > diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> > index 23f9ce9..2b0927b 100644
> > --- a/drivers/media/video/mt9t031.c
> > +++ b/drivers/media/video/mt9t031.c
> > @@ -141,8 +141,19 @@ static int get_shutter(struct soc_camera_device *icd,
> > u32 *data)
> >   static int mt9t031_init(struct soc_camera_device *icd)
> >  {
> > +	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> > +	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
> >  	int ret;
> >  +	if (icl->power) {
> > +		ret = icl->power(&mt9t031->client->dev, 1);
> > +		if (ret < 0) {
> > +			dev_err(icd->vdev->parent,
> > +				"Platform failed to power-on the camera.\n");
> > +			return ret;
> > +		}
> > +	}
> 
> probably you would have to call icl->reset there too?
> I guess this camera sensor does have a reset pin?

Reset is not implemented on this board, and I do not want to implement 
something that noone can test ATM.

Thanks
Guennadi

> 
> 
> > +
> >  	/* Disable chip output, synchronous option update */
> >  	ret = reg_write(icd, MT9T031_RESET, 1);
> >  	if (ret >= 0)
> > @@ -150,13 +161,23 @@ static int mt9t031_init(struct soc_camera_device *icd)
> >  	if (ret >= 0)
> >  		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
> >  +	if (ret < 0 && icl->power)
> > +		icl->power(&mt9t031->client->dev, 0);
> > +
> >  	return ret >= 0 ? 0 : -EIO;
> >  }
> >   static int mt9t031_release(struct soc_camera_device *icd)
> >  {
> > +	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> > +	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
> > +
> >  	/* Disable the chip */
> >  	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
> > +
> > +	if (icl->power)
> > +		icl->power(&mt9t031->client->dev, 0);
> > +
> >  	return 0;
> >  }
> >  --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
