Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:60409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1EZGV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 02:21:58 -0400
Date: Thu, 26 May 2011 08:21:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Hans Petter Selasky <hselasky@c2i.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Make code more readable by not using the return value
 of the WARN() macro. Set ret variable in an undefined case.
In-Reply-To: <4DDD98D2.4000402@redhat.com>
Message-ID: <Pine.LNX.4.64.1105260819110.9307@axis700.grange>
References: <201105231307.53836.hselasky@c2i.net> <Pine.LNX.4.64.1105232019560.30305@axis700.grange>
 <201105232104.08895.hselasky@c2i.net> <4DDD98D2.4000402@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 25 May 2011, Mauro Carvalho Chehab wrote:

> Em 23-05-2011 16:04, Hans Petter Selasky escreveu:
> > On Monday 23 May 2011 20:22:02 Guennadi Liakhovetski wrote:
> >> Please, inline patches. Otherwise, this is what one gets, when replying.
> >>
> >> On Mon, 23 May 2011, Hans Petter Selasky wrote:
> >>> --HPS
> >>
> >> In any case, just throwing in my 2 cents - no idea how not using the
> >> return value of WARN() makes code more readable. On the contrary, using it
> >> is a standard practice. This patch doesn't seem like an improvement to me.
> > 
> > There is no strong reason for the WARN() part, you may ignore that, but the 
> > ret = 0, part is still valid. Should I generate a new patch or can you handle 
> > this?
> Em 23-05-2011 08:07, Hans Petter Selasky escreveu:
> > --HPS
> > 
> > 
> > dvb-usb-0005.patch
> > 
> > 
> > From 94b88b92763f9309018ba04c200a8842ce1ff0ed Mon Sep 17 00:00:00 2001
> > From: Hans Petter Selasky <hselasky@c2i.net>
> > Date: Mon, 23 May 2011 13:07:08 +0200
> > Subject: [PATCH] Make code more readable by not using the return value of the WARN() macro. Set ret variable in an undefined case.
> > 
> > Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> > ---
> >  drivers/media/video/sr030pc30.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
> > index c901721..6cc64c9 100644
> > --- a/drivers/media/video/sr030pc30.c
> > +++ b/drivers/media/video/sr030pc30.c
> > @@ -726,8 +726,10 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
> >  	const struct sr030pc30_platform_data *pdata = info->pdata;
> >  	int ret;
> >  
> > -	if (WARN(pdata == NULL, "No platform data!\n"))
> > +	if (pdata == NULL) {
> > +		WARN(1, "No platform data!\n");
> >  		return -ENOMEM;
> > +	}
> >  
> >  	/*
> >  	 * Put sensor into power sleep mode before switching off
> > @@ -746,6 +748,7 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
> >  	if (on) {
> >  		ret = sr030pc30_base_config(sd);
> >  	} else {
> > +		ret = 0;
> >  		info->curr_win = NULL;
> >  		info->curr_fmt = NULL;
> >  	}
> > -- 1.7.1.1
> 
> IMHO, both hunks make sense, as, on the first hunk, it is returning an error condition.
> Yet, -ENOMEM seems to be the wrong return code. -EINVAL is probably more appropriate.

Sorry, Mauro, don't understand. AFAICS, the first hunk makes _no_ 
functional difference, it only obfuscates a perfectly valid use of the 
WARN() macro.

Thanks
Guennadi

> 
> However, the patch is badly described. It is not about making the code cleaner, but
> about avoiding to run s_power if no platform data is found, and to avoid having
> ret undefined. Eventually, it should be broken into two different patches, as they
> fix different things.
> 
> Please, when sending us patches, provide a proper description with "what" information
> at the first line, and why and how at the patch descriptions. Please, also avoid to
> have any line bigger than 74 characters, otherwise they'll look weird when seeing the
> patch history.
> 
> Thanks,
> Mauro.
> information a
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
