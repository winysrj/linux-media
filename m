Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab2DTPy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:54:56 -0400
Date: Fri, 20 Apr 2012 17:54:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Gershgorin <alexg@meprolight.com>
cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH v1] ARM: i.mx: mx3fb: add overlay support
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CC952548B@MEP-EXCH.meprolight.com>
Message-ID: <Pine.LNX.4.64.1204201746300.3974@axis700.grange>
References: <1334770715-31064-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1204181952580.30514@axis700.grange>
 <4875438356E7CA4A8F2145FCD3E61C0B2CC952548B@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex

On Fri, 20 Apr 2012, Alex Gershgorin wrote:

[snip]

> > Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> > > Thanks for the credit (;-)), but no, putting my Sob after yours means,
> > > that I took your patch and forwarded it on to the next maintainer, which
> > > is clearly not the case here:-) The original i.MX31 framebuffer overlay
> > > code from my old patches also clearly wasn't written by me, since I didn't
> > > have a chance to test it. So, if you like, you can try to trace back
> > > original authors of that code and ask them, how they want to be credited
> > > here,
> 
> I would like to thank all the authors of original code.
> unfortunately I can't thank for each one of you separately by name, i hope
> that you understand and accept it.
> 
> >>  otherwise just mentioning, that this work is based on some earlier
> > > patch series "i.MX31: dmaengine and framebuffer drivers" from 2008 by ...
> > > should be enough.
> 
> This option is more suitable, I just correct the description of the patch,
> and leave your signature (if you have any objections?) since 2008 patch version.

Well, if you wish so...:-) To me it looks like a new patch from you, 
that's just vaguely based on my previous patch, that was copying some 
previous work, so, my contribution to this code isn't huge;-) But if you 
insist - you can keep my Sob, but at least put it above yours.

[snip]

> > @@ -1333,8 +1534,8 @@ static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
> >       ichan->client = mx3fb;
> >       irq = ichan->eof_irq;
> >
> > -     if (ichan->dma_chan.chan_id != IDMAC_SDC_0)
> > -             return -EINVAL;
> > +     switch (ichan->dma_chan.chan_id) {
> > +     case IDMAC_SDC_0:
> >
> >       fbi = mx3fb_init_fbinfo(dev, &mx3fb_ops);
> 
> > > I would bite the bullet and indent this case block...
> 
> This makes a clear separation between the framebuffer and overlay
> channels during initializing, but if you have any ideas welcome, please
> send, I could do a test on my hardware :-)

Sorry, I didn't mean any functional change, just a pure formatting issue: 
you put a "switch-case" statement above, but didn't add an indentation 
level to the following code. While reducing the patch size by avoiding 
unnecessary changes is good, I think, following the coding style and 
improving readability are more important arguments here, so, I would go 
and do that "unnecessary" change and indent the code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
