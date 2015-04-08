Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35358 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbbDHMjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 08:39:15 -0400
Date: Wed, 8 Apr 2015 13:35:54 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] media: cxd2099: move pre-init values out of init()
Message-ID: <20150408123554.GA17914@biggie>
References: <20150208205536.GA31543@turing>
 <20150408080903.1fdc7c4e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150408080903.1fdc7c4e@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 08, 2015 at 08:09:03AM -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 8 Feb 2015 20:55:36 +0000
> luisbg <luis@debethencourt.com> escreveu:
> 
> > Improve code readability by moving out all pre-init values from the init
> > function.
> > 
> > Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> > ---
> >  drivers/staging/media/cxd2099/cxd2099.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> > index 657ea48..bafe36f 100644
> > --- a/drivers/staging/media/cxd2099/cxd2099.c
> > +++ b/drivers/staging/media/cxd2099/cxd2099.c
> > @@ -300,7 +300,6 @@ static int init(struct cxd *ci)
> >  	int status;
> >  
> >  	mutex_lock(&ci->lock);
> > -	ci->mode = -1;
> >  	do {
> >  		status = write_reg(ci, 0x00, 0x00);
> >  		if (status < 0)
> > @@ -420,7 +419,6 @@ static int init(struct cxd *ci)
> >  		status = write_regm(ci, 0x09, 0x08, 0x08);
> >  		if (status < 0)
> >  			break;
> > -		ci->cammode = -1;
> >  		cam_mode(ci, 0);
> >  	} while (0);
> >  	mutex_unlock(&ci->lock);
> > @@ -711,6 +709,8 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
> >  
> >  	ci->en = en_templ;
> >  	ci->en.data = ci;
> > +	ci->mode = -1;
> > +	ci->cammode = -1;
> 
> This actually changes the logic, as, cammode is == -1 only if the
> do {} while loop succeeds.
> 
> Also, calling cam_mode(ci, 0) will change cammode to 0. Btw, for
> it to work, ci->mode should be initialized earlier.
> 
> So, this patch looks very wrong on my eyes, except if you found
> a real bug on it.
> 
> Have you tested it on a real device? What bug does it fix?
> 
> Regards,
> Mauro
> 

Apologies. You are right and this patch is completely wrong.

I submitted this while reading the code of a few drivers to learn from them.
I should've retracted it before you spent time reviewing it. Sorry for that.

Thanks,
Luis

> >  	init(ci);
> >  	dev_info(&i2c->dev, "Attached CXD2099AR at %02x\n", ci->cfg.adr);
> >  	return &ci->en;
