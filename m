Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab2JBKUS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 06:20:18 -0400
Date: Tue, 2 Oct 2012 07:19:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
Message-ID: <20121002071958.2844e5da@redhat.com>
In-Reply-To: <CAOcJUbwGnm=jDkvqcJeQWr4ShraGbSNO9fGgkRgwr+18=h6H8g@mail.gmail.com>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAOcJUbwGnm=jDkvqcJeQWr4ShraGbSNO9fGgkRgwr+18=h6H8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Oct 2012 21:43:51 -0400
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
> > New drxk firmware download does not work with tda18271. Actual
> > reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
> > will work as it does not do as much I/O during attach than tda18271.
> >
> > Root of cause is tuner I/O during drx-k asynchronous firmware
> > download. request_firmware_nowait()... :-/
> >
> > Cc: Michael Krufky <mkrufky@linuxtv.org>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >  drivers/media/usb/em28xx/em28xx-dvb.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > index 770a5af..fd750d4 100644
> > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -1122,9 +1122,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >
> >                 if (dvb->fe[0]) {
> >                         /* attach tuner */
> > -                       if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> > -                                       &dev->i2c_adap,
> > -                                       &em28xx_cxd2820r_tda18271_config)) {
> > +                       if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
> > +                                       &dev->i2c_adap, 0x60)) {
> >                                 dvb_frontend_detach(dvb->fe[0]);
> >                                 result = -EINVAL;
> >                                 goto out_free;
> > --
> > 1.7.11.4
> >
> 
> 
> utterly ridiculous.  I understand why Antti is making this patch, so I
> cannot blame him for it, but this whole idea of asynchronous firmware
> load instead of allowing the bridge driver to orchestrate things is a
> major problem -- THAT is what needs fixing.  let's fix the ACTUAL
> problem.
> 
> (if we have to merge this for the short-term, i understand... i just
> reiterate - we set a horrible president by merging a second tda18271
> driver)

It is not ridiculous: this bug affects Kernel 3.6, so it needs a quick fix.
This is very likely the quickest clean fix for this issue, and changes
only one statement.

So, it can be applied without any hash upstream.

After having this fix applied, a better solution can be developed for Kernel
3.8 (as it is likely too late for 3.7).

Regards,
Mauro
