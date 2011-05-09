Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:52798 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EIJPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 05:15:54 -0400
Subject: Re: [PATCH v2 2/5] drxd: Fix warning caused by new entries in an
 enum
From: Steve Kerrison <steve@stevekerrison.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4DC714EC.2060606@linuxtv.org>
References: <4DC6BF28.8070006@redhat.com>
	 <1304882240-23044-3-git-send-email-steve@stevekerrison.com>
	 <4DC714EC.2060606@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:15:48 +0100
Message-ID: <1304932548.2920.33.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Andreas,

> I'd prefer returning -EINVAL for unsupported parameters.
>
> [snip]
> 
> I already had a patch for this, but forgot to submit it together with
> the frontend.h bits.

That seems reasonable. Do I need to do anything with this? I'm happy for
Mauro to scrub my drxd and mxl patches and use yours instead.

> Btw., "status = status;" looks odd.

Heh, yes it does. I wonder if that was put in to deal with an "unused
variable" compiler warning before the switch statement had a default
case? Otherwise, perhaps it's from the department of redundancy
department.

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Mon, 2011-05-09 at 00:10 +0200, Andreas Oberritter wrote:
> On 05/08/2011 09:17 PM, Steve Kerrison wrote:
> > Additional bandwidth modes have been added in frontend.h
> > drxd_hard.c had no default case so the compiler was warning about
> > a non-exhausive switch statement.
> > 
> > This has been fixed by making the default behaviour the same as
> > BANDWIDTH_AUTO, with the addition of a printk to notify if this
> > ever happens.
> > 
> > Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> > ---
> >  drivers/media/dvb/frontends/drxd_hard.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
> > index 30a78af..b3b0704 100644
> > --- a/drivers/media/dvb/frontends/drxd_hard.c
> > +++ b/drivers/media/dvb/frontends/drxd_hard.c
> > @@ -2325,6 +2325,10 @@ static int DRX_Start(struct drxd_state *state, s32 off)
> >  		   InitEC and ResetEC
> >  		   functions */
> >  		switch (p->bandwidth) {
> > +		default:
> > +			printk(KERN_INFO "drxd: Unsupported bandwidth mode %u, reverting to default\n",
> > +				p->bandwidth);
> > +			/* Fall back to auto */
> 
> I'd prefer returning -EINVAL for unsupported parameters.
> 
> >  		case BANDWIDTH_AUTO:
> >  		case BANDWIDTH_8_MHZ:
> >  			/* (64/7)*(8/8)*1000000 */
> 
> I already had a patch for this, but forgot to submit it together with the frontend.h bits.
> 
> From 73d630b57f584d7e35cac5e27149cbc564aedde2 Mon Sep 17 00:00:00 2001
> From: Andreas Oberritter <obi@linuxtv.org>
> Date: Fri, 8 Apr 2011 16:39:20 +0000
> Subject: [PATCH 2/2] DVB: drxd_hard: handle new bandwidths by returning -EINVAL
> 
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> ---
>  drivers/media/dvb/frontends/drxd_hard.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
> index 30a78af..53319f4 100644
> --- a/drivers/media/dvb/frontends/drxd_hard.c
> +++ b/drivers/media/dvb/frontends/drxd_hard.c
> @@ -2348,6 +2348,9 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>  			status = Write16(state,
>  					 FE_AG_REG_IND_DEL__A, 71, 0x0000);
>  			break;
> +		default:
> +			status = -EINVAL;
> +			break;
>  		}
>  		status = status;
>  		if (status < 0)

