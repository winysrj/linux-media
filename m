Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36538 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbaIRLWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 07:22:38 -0400
Date: Thu, 18 Sep 2014 08:22:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] si2157: change command for sleep
Message-ID: <20140918082233.16ce4a37@recife.lan>
In-Reply-To: <54097579.6000507@iki.fi>
References: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
	<54097579.6000507@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 05 Sep 2014 11:34:01 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka Olli
> 
> I ran some PM tests for that patch set, using PCTV 292e, which is em28xx 
> + Si2168 B40 + Si2157 A30. Here is results:
> 
> current impementation
> -------------------------------------
> cold plugin     40 mA
> streaming      235 mA
> sleeping        42 mA
> 
> si2157: change command for sleep
> -------------------------------------
> cold plugin     40 mA
> streaming      235 mA
> sleeping        60 mA
> 
> So it increases sleep power usage surprisingly much, almost 20mA from 
> the USB, nominal 5V.
> 
> It is also funny that you will not lose firmware for Si2168 when sleep 
> with command 13, but that Si2157 tuner behaves differently.
> 
> I think I will still apply that, it is just firmware download time vs. 
> current use in sleep.

IMHO, the best is to keep it saving more power. Ok, it will take more
time to wake up but so what? If someone is putting the machine to sleep,
it is because he/she wants to save power.

So, IMHO, we should keep the default behavior as-is. Nothing prevents
that we would add a modprobe parameter or to use some other method that
would allow the user to choose between those two different ways.

Regards,
Mauro

> 
> Antti
> 
> 
> On 08/25/2014 09:07 PM, Olli Salonen wrote:
> > Instead of sending command 13 to the tuner, send command 16 when sleeping. This
> > behaviour is observed when using manufacturer provided binary-only Linux driver
> > for TechnoTrend CT2-4400 (Windows driver does not do power management).
> >
> > The issue with command 13 is that firmware loading is necessary after that.
> > This is not an issue with tuners that do not require firmware, but resuming
> > from sleep on an Si2158 takes noticeable time as firmware is loaded on resume.
> >
> > Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> > ---
> >   drivers/media/tuners/si2157.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> > index efb5cce..c84f7b8 100644
> > --- a/drivers/media/tuners/si2157.c
> > +++ b/drivers/media/tuners/si2157.c
> > @@ -197,9 +197,10 @@ static int si2157_sleep(struct dvb_frontend *fe)
> >
> >   	s->active = false;
> >
> > -	memcpy(cmd.args, "\x13", 1);
> > -	cmd.wlen = 1;
> > -	cmd.rlen = 0;
> > +	/* standby */
> > +	memcpy(cmd.args, "\x16\x00", 2);
> > +	cmd.wlen = 2;
> > +	cmd.rlen = 1;
> >   	ret = si2157_cmd_execute(s, &cmd);
> >   	if (ret)
> >   		goto err;
> >
> 
