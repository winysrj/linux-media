Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59603 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750765Ab0IVGIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 02:08:15 -0400
Date: Wed, 22 Sep 2010 08:08:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: hermann pitton <hermann-pitton@arcor.de>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
In-Reply-To: <1285114243.5561.31.camel@pc07.localdom.local>
Message-ID: <Pine.LNX.4.64.1009220801340.32562@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110321.25852.jkrzyszt@tis.icnet.pl>  <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
 <1285114243.5561.31.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Sep 2010, hermann pitton wrote:

> Am Mittwoch, den 22.09.2010, 01:23 +0200 schrieb Guennadi Liakhovetski:
> > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > 
> > > This is a V4L2 driver for TI OMAP1 SoC camera interface.
> 
> [snip]
> 
> > > +
> > > +	} else {
> > > +		dev_warn(dev, "%s: unhandled camera interrupt, status == "
> > > +				"0x%0x\n", __func__, it_status);
> > 
> > Please, don't split strings
> 
> sorry for any OT interference.
> 
> But, are there any new rules out?
> 
> Maybe I missed them.
> 
> Either way, the above was forced during the last three years.
> 
> Not at all ?

No. Splitting print strings has always been discouraged, because it makes 
tracking back kernel logs difficult. The reason for this has been the 80 
character line length limit, which has now been effectively lifted. I'm 
sure you can find enough links on the internet for any of these topics.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
