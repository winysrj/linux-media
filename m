Return-path: <mchehab@pedra>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:52743 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754846Ab0IVAZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 20:25:05 -0400
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera
	interface
From: hermann pitton <hermann-pitton@arcor.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
In-Reply-To: <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
	 <201009110321.25852.jkrzyszt@tis.icnet.pl>
	 <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 02:10:43 +0200
Message-Id: <1285114243.5561.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Am Mittwoch, den 22.09.2010, 01:23 +0200 schrieb Guennadi Liakhovetski:
> On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> 
> > This is a V4L2 driver for TI OMAP1 SoC camera interface.

[snip]

> > +
> > +	} else {
> > +		dev_warn(dev, "%s: unhandled camera interrupt, status == "
> > +				"0x%0x\n", __func__, it_status);
> 
> Please, don't split strings

sorry for any OT interference.

But, are there any new rules out?

Maybe I missed them.

Either way, the above was forced during the last three years.

Not at all ?

Cheers,
Hermann



