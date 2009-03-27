Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50788 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750846AbZC0Hfr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 03:35:47 -0400
Date: Fri, 27 Mar 2009 08:35:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3] ov772x: add edge contrl support
In-Reply-To: <u3ad214an.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903270828200.4635@axis700.grange>
References: <uvdpzuw4t.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0903241019030.4451@axis700.grange> <u3ad214an.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

On Wed, 25 Mar 2009, morimoto.kuninori@renesas.com wrote:

> > Whatever this "edge" does, isn't it so, that "threshold," "upper," and 
> > "lower" parameters configure it and "strength" actually enforces the 
> > changes? Say, if strength == 0, edge control is off, and as soon as you 
> > switch it to != 0, it is on with all the configured parameters? If my 
> > guess is right, wouldn't it make sense to first configure parameters and 
> > then set strength? If you agree, I'll just swap them when committing, so, 
> > you don't have to resend. Just please either confirm that you agree, or 
> > explain why I am wrong.
> 
> I don't know detail of these register's order.
> Because my datasheet doesn't have detail explain.
> 
> For example, does "strength" actually enforce
> all of configured parameters change ?
> 
> So, I tried to test whether these register setting
> order were important.
> 
> It seems to be independent apparently respectively.
> For example, I can change only "upper" register and
> the setting was effective.

So, you _do_ know what that parameter does - if you can verify what effect 
it produces on the camera? So, that's just what I was asking - what do 
these settings do? What changes do you observe when you manipulate them? 
And this your observation actually suffices to me to preserve your 
original order of register writes. If documentation says nothing about it, 
and as long as it works - we can keep it.

> So, I will ask to maker about these register's behavior.
> Because it seems to relate to other register.
> So, please ignore this patch until I get answer. sorry.

Well, I don't think we have to wait for an answer for too long. If they 
don't reply within 1-2 days, let's just take the patch as is (with the 
single minor correction I proposed).

> > +#define OV772X_EDGECTRL(s, t, u, l)	\
> > +{					\
> > +	.strength	= (s & 0x1F),	\
> > +	.threshold	= (t & 0x0F),	\
> > +	.upper		= (u & 0xFF),	\
> > +	.lower		= (l & 0xFF),	\
> > +}
> 
> I will fix this in next =)

That's up to you. This is a minor formatting correction, which I can do 
myself when merging. But if you like, you can send an update, sure.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
