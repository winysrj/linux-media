Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51554 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbaFZJGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jun 2014 05:06:31 -0400
Date: Thu, 26 Jun 2014 10:06:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] media: soc_camera: pxa_camera documentation
 device-tree support
Message-ID: <20140626090625.GK15240@leverpostej>
References: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
 <20140625103042.GB14495@leverpostej>
 <874mz893kw.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mz893kw.fsf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 25, 2014 at 08:44:31PM +0100, Robert Jarzmik wrote:
> Mark Rutland <mark.rutland@arm.com> writes:
> 
> > On Sat, Jun 21, 2014 at 11:21:46PM +0100, Robert Jarzmik wrote:
> >> +Required properties:
> >> + - compatible: Should be "marvell,pxa27x-qci"
> >
> > Is that x a wildcard? Or is 'x' part of the name of a particular unit?
> It's kind of a wildcard for a group of platforms
> It stands for the 3 PXA27x SoCs I'm aware of : PXA270, PXA271, and PXA272. The
> difference between them is different core frequency range and embedded RAM.
> 
> > We prefer not to have wildcard compatible strings in DT.
> OK, then let's go for "marvell,pxa270-qci".

That sounds fine to me.

> >
> >> + - reg: register base and size
> >> + - interrupts: the interrupt number
> >> + - any required generic properties defined in video-interfaces.txt
> >> +
> >> +Optional properties:
> >> + - clock-frequency: host interface is driving MCLK, and MCLK rate is this rate
> >
> > Is MCLK an input or an output of this block?
> An output clock.
> 
> > If the former, why isn't this described as a clock?
> It's a good point. I'll try to add that too. The little trouble I have is that
> the PXA clocks are not _yet_ in device-tree. Putting a clock description will
> make this patch dependant on the clock framework patches [1], right ?

Yes, this will.

> 
> >> 
> >> +Example:
> >> +
> >> +	pxa_camera: pxa_camera@50000000 {
> >> +		compatible = "marvell,pxa27x-qci";
> >> +		reg = <0x50000000 0x1000>;
> >> +		interrupts = <33>;
> >> +
> >> +		clocks = <&pxa2xx_clks 24>;
> >> +		clock-names = "camera";
> >
> > These weren't mentioned above. Is the clock input line really called
> > "camera"?
> This is another clock, an input clock, independant of the former one. This is
> the clock actually fed to make this IP block work. This is dependant on the
> clock framework patches [1].

Ok. This clock should be mentioned in the properties description above.

Thanks,
Mark.
