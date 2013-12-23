Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:60147 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab3LWKl1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 05:41:27 -0500
Message-ID: <52B81354.303@imgtec.com>
Date: Mon, 23 Dec 2013 10:41:24 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	"Pawel Moll" <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	<devicetree@vger.kernel.org>, Rob Landley <rob@landley.net>,
	<linux-doc@vger.kernel.org>
Subject: Re: [PATCH 01/11] dt: binding: add binding for ImgTec IR block
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com> <1386947579-26703-2-git-send-email-james.hogan@imgtec.com> <3633330.ixgGf52iFP@flatron>
In-Reply-To: <3633330.ixgGf52iFP@flatron>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/12/13 12:48, Tomasz Figa wrote:
>> diff --git a/Documentation/devicetree/bindings/media/img-ir.txt b/Documentation/devicetree/bindings/media/img-ir.txt
>> new file mode 100644
>> index 000000000000..6f623b094ea6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/img-ir.txt
>> @@ -0,0 +1,20 @@
>> +* ImgTec Infrared (IR) decoder
>> +
>> +Required properties:
>> +- compatible:		Should be "img,ir"
> 
> This compatible string isn't really very specific. Is there some IP
> revision string that could be added, to account for possible design
> changes that may require binding change?

Yes, agreed. I'll try and find a more unambiguous name for the IP block.

>> +- reg:			Physical base address of the controller and length of
>> +			memory mapped region.
>> +- interrupts:		The interrupt specifier to the cpu.
>> +
>> +Optional properties:
>> +- clocks:		Clock specifier for base clock.
>> +			Defaults to 32.768KHz if not specified.
> 
> To make the binding less fragile and allow interoperability with non-DT
> platforms it may be better to provide also clock-names property (so you
> can use clk_get(); that's a Linux implementation detail, though, but to
> make our lives easier IMHO they should be sometimes considered too).

Good idea. Looking at the hardware manual it actually describes 3 clock
inputs, and although only one is needed by the driver it makes sense for
the DT binding to be able to describe them all. I'll probably go with
these clock-names values:
"core": Core clock (32.867kHz)
"sys": System side (fast) clock
"mod": Power modulation clock

Cheers
James

