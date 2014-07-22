Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29311 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaGVLmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 07:42:06 -0400
Message-id: <53CE4E08.2030407@samsung.com>
Date: Tue, 22 Jul 2014 13:42:00 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"andrzej.p@samsung.com" <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] Documentation: devicetree: Document sclk-jpeg clock
 for exynos3250 SoC
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
 <1405091990-28567-9-git-send-email-j.anaszewski@samsung.com>
 <20140714095640.GC4980@leverpostej>
In-reply-to: <20140714095640.GC4980@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/07/14 11:56, Mark Rutland wrote:
>> diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>> > index 937b755..3142745 100644
>> > --- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>> > +++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
>> > @@ -3,9 +3,12 @@ Samsung S5P/EXYNOS SoC series JPEG codec
>> >  Required properties:
>> >  
>> >  - compatible	: should be one of:
>> > -		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg";
>> > +		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
>> > +		  "samsung,exynos3250-jpeg";
>> >  - reg		: address and length of the JPEG codec IP register set;
>> >  - interrupts	: specifies the JPEG codec IP interrupt;
>> > -- clocks	: should contain the JPEG codec IP gate clock specifier, from the
>> > +- clocks	: should contain the JPEG codec IP gate clock specifier and
>> > +		  for the Exynos3250 SoC additionally the SCLK_JPEG entry; from the
>> >  		  common clock bindings;
>> > -- clock-names	: should contain "jpeg" entry.
>> > +- clock-names	: should contain "jpeg" entry and additionally "sclk-jpeg" entry
>> > +		  for Exynos3250 SoC
>
> Please turn this into a list for easier reading, e.g.
> 
> - clock-names: should contain:
>   * "jpeg" for the gate clock.
>   * "sclk-jpeg" for the SCLK_JPEG clock (only for Exynos3250).
> 
> You could also define clocks in terms of clock-names to avoid
> redundancy.
> 
> The SCLK_JPEG name sounds like a global name for the clock. Is there a
> name for the input line on the JPEG block this is plugged into?

There is unfortunately no such name for SCLK_JPEG clock in the IP's block
documentation. For most of the multimedia IPs clocks are documented
only in the clock controller chapter, hence the names may appear global.
Probably "gate", "sclk" would be good names, rather than "<IP_NAME>",
"<IP_NAME>-sclk". But people kept using the latter convention and now
it's spread all over and it's hard to change it.
Since now we can't rename "jpeg" and other IPs I'd assume it's best
to stay with "jpeg", "sclk-jpeg".

--
Regards,
Sylwester
