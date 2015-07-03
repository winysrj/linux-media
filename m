Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37735 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbbGCHjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 03:39:07 -0400
Message-ID: <55963BF1.7060009@xs4all.nl>
Date: Fri, 03 Jul 2015 09:38:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nathaniel Bezanson <myself@telcodata.us>,
	linux-media@vger.kernel.org
Subject: Re: Subjective maturity of tw6869, cx25821, bluecherry/softlogic
 drivers
References: <1435871672466752997@telcodata.us>
In-Reply-To: <1435871672466752997@telcodata.us>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/02/2015 11:14 PM, Nathaniel Bezanson wrote:
> Hi all,
> 
> If this isn't the appropriate venue for this question, please gently
> steer me somewhere else. Thanks. :) I'm trying to head off the "well
> you shouldn't have bought *that* junk in the first place!" advice by
> doing some research ahead of time, and I'm here to check some
> assumptions.
> 
> I've been tasked with recommending a capture card for our
> hackerspace's video monitoring system. We'll be using motion so
> anything v4l/v4l2 is fair game. We presently have 8 cameras, but a
> 16-channel card wouldn't go to waste. Only quirk is the host system
> is PCI-Express only, no parallel PCI.
> 
> I've found the much-lauded Bluecherry driver release in 2010:
> http://ben-collins.blogspot.com/2010/06/softlogic-6010-4816-channel-mpeg-4.html
>
> It claims to be 90% functional, and I haven't found any updates since
> then. Am I looking in the wrong place or is this completely orphaned?
> Cards sometimes come up cheap and the board looks really
> well-thought-out, but as a hardware guy I'm the last person you want
> rooting around in driver source trying to solder some code together
> and get the last bits working...

The support for the solo devices is now part of the kernel and it is
maintained there. I still get patches from Bluecherry and it is a
mature card.

> I found the intersil/techwell TW6869 chip on a very affordable card,
> and there's a nice looking driver here:
> https://github.com/igorizyumin/tw6869/ Only trouble is there only
> seems to be the one card using it, and it's v1.0 hardware without
> robust ESD protection on the inputs; I don't know if I'd expect it to
> survive a decade connected to 200-foot camera leads. It's cheap
> enough to keep spare boards around, though. Is this driver solid? Is
> the chip? Are there other cards based on it?

I don't know anything about this chip. Other Techwell devices give decent
quality, but I've never used this one.

> I popped into #v4l on freenode, and was pointed to the cx25821 chip,
> which seems well supported but I can't find any actual names of cards
> that claim to use it, except possibly a line of Russian cards and
> maybe I can get a Russian-speaking friend to help figure out their
> shopping cart... Is there a known/recommended Cx25821-based card I
> should look for? (And is the 25853 similar?)

There used to be a cx25821 card on dx.com (which is where I got mine),
but it's out of stock. I haven't been able to find one either. It's
unclear to me whether the 25853 is similar enough to work with the
cx25821 driver. I'm not optimistic.

> I've seen talk of the older Geovision cards using the Bt878a chips,
> which is of course lovely, but I can't find any info on their PCIe
> offerings, nor even high-res photos of the board. That's a shame cuz
> their hardware looks really solid. Any chipset info? Anyone using
> these?

I don't think there is any linux support for Geovision PCIe cards.

> Anything else I'm missing?

No, I don't think so.

If you want to have a well-supported card, then Bluecherry is your
best bet. Techwell will likely work too, but the driver is not in the
kernel (which may or may not be a problem for you). Getting it ready
for inclusion into the kernel is a fair amount of work.

Regards,

	Hans
