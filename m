Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:53762 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0IKJdb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 05:33:31 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Jasmine Strong <jasmine@electronpusher.org>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Sat, 11 Sep 2010 11:32:47 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <201009110321.25852.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201009110321.25852.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009111132.49405.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Saturday 11 September 2010 04:06:02 Jasmine Strong wrote:
> On 10 Sep 2010, at 18:21, Janusz Krzysztofik wrote:
> >  Both paths work stable for me, even
> > under heavy load, on my OMAP1510 based Amstrad Delta videophone, that is
> > the oldest, least powerfull OMAP1 implementation.
>
> You say that, but the ARM925 in OMAP1510 is known not to exhibit the bug 

Then, lucky me ;)

> in  
> OMAP1610, which causes severe slowdown to DRAM writes when the first
> address of an STM instruction is not aligned to a d-cache line boundary. 
> This means that at least last time I looked, the Linux ARM memcpy()
> implementation is often faster on 1510 than 1610.

This sounds like a problem that should be solved at a machine support level 
rather than a camera driver. I don't follow general OMAP development closely 
enough to know if this bug has ever been addressed or is going to be.

Unfortunatelly, I have no access to any OMAP machine other than Amstrad Delta, 
so I'm not able to test the driver, including its performance, on other OMAP1 
implementations.

Anyways, I think there is always a room for improvement, either in my 
omap1_camera or maybe in the omap24xxcam driver, if someone tries to add 
support for a camera to an OMAP1 board other than 1510, and identifies a more 
optimal, 1610 or higher specific way of handling the OMAP camera interface.

Do you think I should rename the driver to something like "omap1510cam" rather 
than "omap1_camera" then?

Thanks,
Janusz

>
> -J.
> _______________________________________________
> e3-hacking mailing list
> e3-hacking@earth.li
> http://www.earth.li/cgi-bin/mailman/listinfo/e3-hacking

