Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52088 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGVOS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 10:18:29 -0400
Message-id: <53CE72B1.4080706@samsung.com>
Date: Tue, 22 Jul 2014 16:18:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>
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
 <20140714095640.GC4980@leverpostej> <53CE4E08.2030407@samsung.com>
 <14970063.d648TVkJj8@wuerfel>
In-reply-to: <14970063.d648TVkJj8@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/07/14 13:48, Arnd Bergmann wrote:
>>>>> -- clocks  : should contain the JPEG codec IP gate clock specifier, from the
>>>>> > >> > +- clocks  : should contain the JPEG codec IP gate clock specifier and
>>>>> > >> > +            for the Exynos3250 SoC additionally the SCLK_JPEG entry; from the
>>>>> > >> >              common clock bindings;
>>>>> > >> > -- clock-names     : should contain "jpeg" entry.
>>>>> > >> > +- clock-names     : should contain "jpeg" entry and additionally "sclk-jpeg" entry
>>>>> > >> > +            for Exynos3250 SoC
>>> > >
>>> > > Please turn this into a list for easier reading, e.g.
>>> > > 
>>> > > - clock-names: should contain:
>>> > >   * "jpeg" for the gate clock.
>>> > >   * "sclk-jpeg" for the SCLK_JPEG clock (only for Exynos3250).
>>> > > 
>>> > > You could also define clocks in terms of clock-names to avoid
>>> > > redundancy.
>>> > > 
>>> > > The SCLK_JPEG name sounds like a global name for the clock. Is there a
>>> > > name for the input line on the JPEG block this is plugged into?
>> > 
>> > There is unfortunately no such name for SCLK_JPEG clock in the IP's block
>> > documentation. For most of the multimedia IPs clocks are documented
>> > only in the clock controller chapter, hence the names may appear global.
>> > Probably "gate", "sclk" would be good names, rather than "<IP_NAME>",
>> > "<IP_NAME>-sclk". But people kept using the latter convention and now
>> > it's spread all over and it's hard to change it.
>> > Since now we can't rename "jpeg" and other IPs I'd assume it's best
>> > to stay with "jpeg", "sclk-jpeg".
>
> We just had the exact same discussion about the addition of the sclk for
> the adc in exynos3250 and ended up calling it just "sclk" instead of "sclk-adc"
> there. I think it would be best to do the same here and use "sclk" instead
> of "sclk-jpeg".

All right, then I would rephrase it to:

- clock-names   : should contain:
  		   - "jpeg" for the common gate clock,
		   - "sclk" for the special clock (only for Exynos3250).
- clocks	: should contain the clock specifier and clock ID list
  		  matching entries in the clock-names property, according
		  to the common clock bindings.

I went through documentation of these clocks in various SoCs' datasheets:
exynos4210, exynos4212/4412, exynos3250, exynos5250 and I think for all
SoCs the "jpeg" clock can be referred as "gating all clocks for the IP".
That means there is a single bit in a CMU register masking all the clocks
for the IP, I suppose this includes the control bus (APB) clock and the
IP functional ("special") clock.

It looks like e.g. exynos4412 also has the SCLK clock, after muxes and
a divider, so rate can be configured for this clock.  However there is
no separate gate for SCLK as in case of exynos3250. Thus there is no
need to to enable/disable the second clock on anything except exynos3250
currently.

I think ideally sclk should also be defined for SoCs like exynos4x12,
exynos5250, even if now drivers are not touching sclk. All in all the
IP functional clock frequency should be normally set to some known value,
now we rely on the default divider value which results in divider
ratio = 1.
It would break backward compatibility though if we now made sclk
mandatory. I'm inclined to also specify sclk for exynos4x12, just
not sure if it should be optional or mandatory.

-- 
Regards,
Sylwester
