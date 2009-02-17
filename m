Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752483AbZBQSGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 13:06:20 -0500
Date: Tue, 17 Feb 2009 19:05:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] mt9m111: Call icl->reset() on mt9m111_reset().
In-Reply-To: <87prhhrnja.fsf@free.fr>
Message-ID: <alpine.DEB.2.00.0902171905200.6986@axis700.grange>
References: <20090217112339.f959035b.ospite@studenti.unina.it> <87prhhrnja.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Feb 2009, Robert Jarzmik wrote:

> Antonio Ospite <ospite@studenti.unina.it> writes:
> 
> > Call icl->reset() on mt9m111_reset().
> >
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> >
> > diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> > index c043f62..92dd7f3 100644
> > --- a/drivers/media/video/mt9m111.c
> > +++ b/drivers/media/video/mt9m111.c
> > @@ -393,6 +393,8 @@ static int mt9m111_disable(struct soc_camera_device *icd)
> >  
> >  static int mt9m111_reset(struct soc_camera_device *icd)
> >  {
> > +	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> > +	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
> >  	int ret;
> >  
> >  	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
> > @@ -401,6 +403,10 @@ static int mt9m111_reset(struct soc_camera_device *icd)
> >  	if (!ret)
> >  		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
> >  				| MT9M111_RESET_RESET_SOC);
> > +
> > +	if (icl->reset)
> > +		icl->reset(&mt9m111->client->dev);
> > +
> >  	return ret;
> >  }
> >  
> 
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Guennadi, would you queue that up for next, please ?

Queued.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
