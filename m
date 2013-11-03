Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:56863 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab3KCMRF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 07:17:05 -0500
Date: Sun, 3 Nov 2013 13:17:02 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 02/12] tda18271c2dd: Fix description of NXP TDA18271C2
 silicon tuner
Message-ID: <20131103121702.GQ7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103002523.GF7956@parallels.com>
 <20131103072726.51dd0472@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103072726.51dd0472@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Sun, 3 Nov 2013 01:25:23 +0100
> Maik Broemme <mbroemme@parallels.com> escreveu:
> 
> > Added (DD) to NXP TDA18271C2 silicon tuner as this tuner was
> > specifically added for Digital Devices ddbridge driver.
> > 
> > Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> > ---
> >  drivers/media/dvb-frontends/Kconfig | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> > index bddbab4..6f99eb8 100644
> > --- a/drivers/media/dvb-frontends/Kconfig
> > +++ b/drivers/media/dvb-frontends/Kconfig
> > @@ -48,11 +48,11 @@ config DVB_DRXK
> >  	  Say Y when you want to support this frontend.
> >  
> >  config DVB_TDA18271C2DD
> > -	tristate "NXP TDA18271C2 silicon tuner"
> > +	tristate "NXP TDA18271C2 silicon tuner (DD)"
> >  	depends on DVB_CORE && I2C
> >  	default m if !MEDIA_SUBDRV_AUTOSELECT
> >  	help
> > -	  NXP TDA18271 silicon tuner.
> > +	  NXP TDA18271 silicon tuner (Digital Devices driver).
> >  
> >  	  Say Y when you want to support this tuner.
> >  
> 
> The better is to use the other tda18271 driver. This one was added as a
> temporary alternative, as the more complete one were lacking some
> features, and were not working with DRX-K. Well, those got fixed already,
> and we now want to get rid of this duplicated driver.
> 

Agree. Probably the tda18271 will need some extensions to work with
ddbridge and I will see what I can do the next days to get it working.

> Regards,
> Mauro
> -- 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Maik
