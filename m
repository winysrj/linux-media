Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63117 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab2A0W0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 17:26:53 -0500
Received: by wics10 with SMTP id s10so1671965wic.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 14:26:52 -0800 (PST)
Message-ID: <4f2324a6.4d5ab40a.4ce7.ffff91c5@mx.google.com>
Subject: Re: [PATCH 1/3] m88brs2000 DVB-S frontend and tuner module.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 27 Jan 2012 22:26:40 +0000
In-Reply-To: <4F2185A1.2000402@redhat.com>
References: <1327228731.2540.3.camel@tvbox> <4F2185A1.2000402@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-01-26 at 14:56 -0200, Mauro Carvalho Chehab wrote:
> Em 22-01-2012 08:38, Malcolm Priestley escreveu:
> > Support for m88brs2000 chip used in lmedm04 driver.
> > 
> > Note there are still lock problems.
> > 
> > Slow channel change due to the large block of registers sent in set_frontend.
> > 
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> > ---
> 
> ...
> > +static int m88rs2000_set_property(struct dvb_frontend *fe,
> > +	struct dtv_property *p)
> > +{
> > +	dprintk("%s(..)\n", __func__);
> > +	return 0;
> > +}
> > +
> > +static int m88rs2000_get_property(struct dvb_frontend *fe,
> > +	struct dtv_property *p)
> > +{
> > +	dprintk("%s(..)\n", __func__);
> > +	return 0;
> > +}
> ...
> 
> Just don't implement set_property/get_property if you're not using them.
> 
> Except for that, the code looks ok on my eyes.
> 
Hi Mauro

This patch series is now on alpha due to hardware issues.

The hardware becomes completely unresponsive after a full transponder
scan on all systems.

Although, the hardware becomes fully usable again after a few days!?!

Some kind of memory storage?

So, for the time being this driver is not to go upstream.

Regards


Malcolm

