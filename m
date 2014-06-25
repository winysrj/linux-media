Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:57145 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaFYTod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 15:44:33 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "g.liakhovetski\@gmx.de" <g.liakhovetski@gmx.de>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] media: soc_camera: pxa_camera documentation device-tree support
References: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
	<20140625103042.GB14495@leverpostej>
Date: Wed, 25 Jun 2014 21:44:31 +0200
In-Reply-To: <20140625103042.GB14495@leverpostej> (Mark Rutland's message of
	"Wed, 25 Jun 2014 11:30:42 +0100")
Message-ID: <874mz893kw.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Rutland <mark.rutland@arm.com> writes:

> On Sat, Jun 21, 2014 at 11:21:46PM +0100, Robert Jarzmik wrote:
>> +Required properties:
>> + - compatible: Should be "marvell,pxa27x-qci"
>
> Is that x a wildcard? Or is 'x' part of the name of a particular unit?
It's kind of a wildcard for a group of platforms
It stands for the 3 PXA27x SoCs I'm aware of : PXA270, PXA271, and PXA272. The
difference between them is different core frequency range and embedded RAM.

> We prefer not to have wildcard compatible strings in DT.
OK, then let's go for "marvell,pxa270-qci".


>
>> + - reg: register base and size
>> + - interrupts: the interrupt number
>> + - any required generic properties defined in video-interfaces.txt
>> +
>> +Optional properties:
>> + - clock-frequency: host interface is driving MCLK, and MCLK rate is this rate
>
> Is MCLK an input or an output of this block?
An output clock.

> If the former, why isn't this described as a clock?
It's a good point. I'll try to add that too. The little trouble I have is that
the PXA clocks are not _yet_ in device-tree. Putting a clock description will
make this patch dependant on the clock framework patches [1], right ?

>> 
>> +Example:
>> +
>> +	pxa_camera: pxa_camera@50000000 {
>> +		compatible = "marvell,pxa27x-qci";
>> +		reg = <0x50000000 0x1000>;
>> +		interrupts = <33>;
>> +
>> +		clocks = <&pxa2xx_clks 24>;
>> +		clock-names = "camera";
>
> These weren't mentioned above. Is the clock input line really called
> "camera"?
This is another clock, an input clock, independant of the former one. This is
the clock actually fed to make this IP block work. This is dependant on the
clock framework patches [1].

Cheers.

-- 
Robert

[1] http://www.spinics.net/lists/arm-kernel/msg337521.html
