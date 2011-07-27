Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43720 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1G0WHp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 18:07:45 -0400
Received: by wwe5 with SMTP id 5so1861516wwe.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 15:07:43 -0700 (PDT)
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <4E3061CF.2080009@redhat.com>
References: <4E2E0788.3010507@iki.fi>  <4E3061CF.2080009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 23:07:31 +0100
Message-ID: <1311804451.9058.20.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-07-27 at 16:06 -0300, Mauro Carvalho Chehab wrote:
> Em 25-07-2011 21:17, Antti Palosaari escreveu:
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >  drivers/media/dvb/dvb-usb/dvb-usb-dvb.c  |   85 +++++++++++++++++++++++-------
> >  drivers/media/dvb/dvb-usb/dvb-usb-init.c |    4 ++
> >  drivers/media/dvb/dvb-usb/dvb-usb.h      |   11 +++-
> >  3 files changed, 78 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> > index d8c0bd9..5e34df7 100644
> > --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> > +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> > @@ -162,8 +162,11 @@ static int dvb_usb_fe_wakeup(struct dvb_frontend *fe)
> > 
> >      dvb_usb_device_power_ctrl(adap->dev, 1);
> > 
> > -    if (adap->fe_init)
> > -        adap->fe_init(fe);
> > +    if (adap->props.frontend_ctrl)
> > +        adap->props.frontend_ctrl(fe, 1);
> > +
> > +    if (adap->fe_init[fe->id])
> > +        adap->fe_init[fe->id](fe);
> > 
> >      return 0;
> >  }
> > @@ -172,45 +175,89 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
> >  {
> >      struct dvb_usb_adapter *adap = fe->dvb->priv;
> > 
> > -    if (adap->fe_sleep)
> > -        adap->fe_sleep(fe);
> > +    if (adap->fe_sleep[fe->id])
> > +        adap->fe_sleep[fe->id](fe);
> > +
> > +    if (adap->props.frontend_ctrl)
> > +        adap->props.frontend_ctrl(fe, 0);
> > 
> >      return dvb_usb_device_power_ctrl(adap->dev, 0);
> >  }
> > 
> >  int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
> >  {
> > +    int ret, i, x;
> > +
> > +    memset(adap->fe, 0, sizeof(adap->fe));
> > +
> >      if (adap->props.frontend_attach == NULL) {
> > -        err("strange: '%s' #%d doesn't want to attach a frontend.",adap->dev->desc->name, adap->id);
> > +        err("strange: '%s' #%d doesn't want to attach a frontend.",
> > +            adap->dev->desc->name, adap->id);
> > +
> >          return 0;
> >      }
> > 
> > -    /* re-assign sleep and wakeup functions */
> > -    if (adap->props.frontend_attach(adap) == 0 && adap->fe[0] != NULL) {
> > -        adap->fe_init  = adap->fe[0]->ops.init;  adap->fe[0]->ops.init  = dvb_usb_fe_wakeup;
> > -        adap->fe_sleep = adap->fe[0]->ops.sleep; adap->fe[0]->ops.sleep = dvb_usb_fe_sleep;
> > +    /* register all given adapter frontends */
> > +    if (adap->props.num_frontends)
> > +        x = adap->props.num_frontends - 1;
> > +    else
> > +        x = 0;
> > +
> > +    for (i = 0; i <= x; i++) {
> > +        ret = adap->props.frontend_attach(adap);
> > +        if (ret || adap->fe[i] == NULL) {
> > +            /* only print error when there is no FE at all */
> > +            if (i == 0)
> > +                err("no frontend was attached by '%s'",
> > +                    adap->dev->desc->name);
> 
> This doesn't seem right. One thing is to accept adap->fe[1] to be
> NULL. Another thing is to accept an error at the attach. IMO, the
> logic should be something like:
> 
> 	if (ret < 0)
> 		return ret;
> 
> 	if (!i && !adap->fe[0]) {
> 		err("no adapter!");
> 		return -ENODEV;
> 	}
> 
> > +
> > +            return 0;
> > +        }
> > 
> > -        if (dvb_register_frontend(&adap->dvb_adap, adap->fe[0])) {
> > -            err("Frontend registration failed.");
> > -            dvb_frontend_detach(adap->fe[0]);
> > -            adap->fe[0] = NULL;
> > -            return -ENODEV;
> > +        adap->fe[i]->id = i;
> > +
> > +        /* re-assign sleep and wakeup functions */
> > +        adap->fe_init[i] = adap->fe[i]->ops.init;
> > +        adap->fe[i]->ops.init  = dvb_usb_fe_wakeup;
> > +        adap->fe_sleep[i] = adap->fe[i]->ops.sleep;
> > +        adap->fe[i]->ops.sleep = dvb_usb_fe_sleep;
> > +
> > +        if (dvb_register_frontend(&adap->dvb_adap, adap->fe[i])) {
> > +            err("Frontend %d registration failed.", i);
> > +            dvb_frontend_detach(adap->fe[i]);
> 
> There is a special case here: for DRX-K, we can't call dvb_frontend_detach().
> as just one drxk_attach() returns the two pointers. While this is not fixed,
> we need to add some logic here to check if the adapter were attached.
> 
> > +            adap->fe[i] = NULL;
> > +            /* In error case, do not try register more FEs,
> > +             * still leaving already registered FEs alive. */
> 
> I think that the proper thing to do is to detach everything, if one of
> the attach fails. There isn't much sense on keeping the device partially
> initialized.
> 
>From memory, I recall the existing code doesn't detach the frontend even
if the device driver forces an error. So, the device driver must detach
the frontend first.

The trouble is that dvb-usb is becoming dated as new drivers tend to
work around it. No one likes to touch it, out of fear of breaking
existing drivers.

I think perhaps some kind of legacy wrapper is needed here, with the
moving of dvb-usb to its own core, so more development work can be done.

Regards

Malcolm

