Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42743 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbbAESa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 13:30:27 -0500
Date: Mon, 5 Jan 2015 16:29:47 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/5] dvb core: add media controller support for the
 demod
Message-ID: <20150105162947.4ebc553f@concha.lan>
In-Reply-To: <54AAA150.7000109@gmail.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
	<16368e1f9dfb1db65ec6f0d91a38d5233a12542c.1420127255.git.mchehab@osg.samsung.com>
	<54AAA150.7000109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 05 Jan 2015 23:36:00 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> On 2015年01月02日 00:51, Mauro Carvalho Chehab wrote:
> >  /*
> > @@ -416,6 +418,11 @@ struct dvb_frontend {
> >  	struct dvb_frontend_ops ops;
> >  	struct dvb_adapter *dvb;
> >  	struct i2c_client *fe_cl;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	struct media_device *mdev;
> > +	struct media_entity demod_entity;
> > +#endif
> > +
> 
> I understood that this patch was invalidated by the updated patch series:
> "dvb core: add basic suuport for the media controller",
> and now the demod_entity is registered in dvbdev.c::dvb_register_device()
> via dvb_frontend_register(). Is that right?

Yes. 

> And if so,
> Shouldn't only the (tuner) subdevices be registered separately
> in dvb_i2c_attach_tuner(), instead of dvb_i2c_attach_fe()?

No, it seems better to let dmxdev to register. That means that even
the non-converted I2C drivers, plus the non-I2C drivers may benefit
from the Media controller as well.

> (and it would be simpler if "mdev" can be accessed
> like dvb_fe_get_mdev() {return fepriv->dvbdev->mdev;},
> instead of having a cached value in dvb_frontend.)

Yeah, we could map this way, but that would require to add an extra
parameter to the fe register function, with has already too much
parameters. So, as it already uses an struct to pass parameters into
it, I decided to just re-use it.

> sorry if I'm totally wrong,
> I don't have an experience with media controller API.
> 
> regards,
> akihiro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
