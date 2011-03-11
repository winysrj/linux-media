Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:41356 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1CKSdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 13:33:10 -0500
Date: Fri, 11 Mar 2011 19:33:05 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
CC: <linux-media@vger.kernel.org>, <rjkm@metzlerbros.de>
Mime-Version: 1.0
Message-ID: <419PcksGF8800S02.1299868385@web02.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
To: Issa Gorissen <flop.m@usa.net>Cc: linux-media@vger.kernel.org,
rjkm@metzlerbros.de
Subject: Re: [PATCH] Ngene cam device name

> On 03/10/2011 04:29 PM, Issa Gorissen wrote:
> > As the cxd20099 driver is in staging due to abuse of the sec0 device,
this
> > patch renames it to cam0. The sec0 device is not in use and can be
removed
> 
> That doesn't solve anything. Besides, your patch doesn't even do what
> you describe.
> 
> Wouldn't it be possible to extend the current CA API? If not, shouldn't
> a new API be created that covers both old and new requirements?
> 
> It's rather unintuitive that some CAMs appear as ca0, while others as cam0.
> 
> If it was that easy to fix, it wouldn't be in staging today.
> 
> Regards,
> Andreas


Yes indeed, this patch is missing the update of dnames arrays in dvbdev.c

Now, according to Mauro comments, he has put this code into staging because of
the usage of sec0 name for a cam device.

Please comment on Oliver's explanations from this thread

http://www.mail-archive.com/linux-media@vger.kernel.org/msg26901.html


Thx
--
Issa


> 
> > Signed-off-by: Issa Gorissen <flop.m@usa.net>
> > ---
> >  drivers/media/dvb/dvb-core/dvbdev.h  |    2 +-
> >  drivers/media/dvb/ngene/ngene-core.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-core/dvbdev.h 
> > b/drivers/media/dvb/dvb-core/dvbdev.h
> > index fcc6ae9..dcac27d 100644
> > --- a/drivers/media/dvb/dvb-core/dvbdev.h
> > +++ b/drivers/media/dvb/dvb-core/dvbdev.h
> > @@ -40,7 +40,7 @@
> >  
> >  #define DVB_DEVICE_VIDEO      0
> >  #define DVB_DEVICE_AUDIO      1
> > -#define DVB_DEVICE_SEC        2
> > +#define DVB_DEVICE_CAM        2
> >  #define DVB_DEVICE_FRONTEND   3
> >  #define DVB_DEVICE_DEMUX      4
> >  #define DVB_DEVICE_DVR        5
> > diff --git a/drivers/media/dvb/ngene/ngene-core.c 
> > b/drivers/media/dvb/ngene/ngene-core.c
> > index 175a0f6..6be2d7c 100644
> > --- a/drivers/media/dvb/ngene/ngene-core.c
> > +++ b/drivers/media/dvb/ngene/ngene-core.c
> > @@ -1523,7 +1523,7 @@ static int init_channel(struct ngene_channel *chan)
> >                 set_transfer(&chan->dev->channel[2], 1);
> >                 dvb_register_device(adapter, &chan->ci_dev,
> >                                     &ngene_dvbdev_ci, (void *) chan,
> > -                                   DVB_DEVICE_SEC);
> > +                                   DVB_DEVICE_CAM);
> >                 if (!chan->ci_dev)
> >                         goto err;
> >         }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


