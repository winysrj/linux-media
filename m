Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54556 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0HCCPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 22:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <00e601cb32a5$61f4d8e0$25de8aa0$%kim@samsung.com>
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
	<1279902083-21250-2-git-send-email-s.nawrocki@samsung.com>
	<00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com>
	<003001cb322d$fc976b10$f5c64130$%osciak@samsung.com>
	<20100802105216.GD30670@n2100.arm.linux.org.uk>
	<003201cb323b$72f32df0$58d989d0$%osciak@samsung.com>
	<20100802165852.GA6671@n2100.arm.linux.org.uk>
	<00e601cb32a5$61f4d8e0$25de8aa0$%kim@samsung.com>
Date: Tue, 3 Aug 2010 11:15:34 +0900
Message-ID: <AANLkTi=cCPXP0nHskKKn-fJj_u2TYj26J=JWXrh3jYe_@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] ARM: Samsung: Add register definitions for Samsung
	S5P SoC camera interface
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Osciak <p.osciak@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 3, 2010 at 9:46 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Russell King wrote:
>>
>> On Mon, Aug 02, 2010 at 02:08:42PM +0200, Pawel Osciak wrote:
>> > >Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> > >On Mon, Aug 02, 2010 at 12:32:20PM +0200, Pawel Osciak wrote:
>> > >> Well, some of them are indeed unused, but it's not an uncommon
> practice in
>> > >> kernel and might help future developers.
>> > >
>> > >On the other hand, arch/arm is getting soo big that we need to do
>> > >something about this - and one solution is to avoid unnecessary
>> > >definitions that we're not using.
>> > >
>> > >Another good idea is to put definitions along side the drivers which
>> > >they're relevant to - maybe in a local driver-name.h file which
>> > >driver-name.c includes, or maybe even within driver-name.c if they're
>> > >not excessive.  This has the advantage of distributing the "bloat" to
>> > >where its actually used, and means that the driver isn't dependent so
>> > >much on arch/arm or even the SoC itself.
>> > >
>> > >Take a look at arch/arm/mach-vexpress/include/mach/ct-ca9x4.h and
>> > >arch/arm/mach-vexpress/include/mach/motherboard.h - these are the only
>> > >two files which contain platform definitions which are actually used
>> > >for Versatile Express.  Compare that with
>> > >arch/arm/mach-realview/include/mach/platform.h which contains lots
>> > >more...
>> >
>> > So basically, what you and Mauro are recommending is that we move the
> *.h
>> > file with register definitions to drivers/media?
>>
>> What I'm suggesting is what's been pretty standard in Linux for a long
>> time.  Take a look at: drivers/net/3c503.[ch], or for a more recent
>> driver, drivers/net/e1000/*.[ch].  Or drivers/mmc/host/mmci.[ch]
>>
> I agree with Russell's opinion.
> I don't want to add unnecessary(or unavailable in arch/arm) definitions in
> arch/arm/*/include
>
>> Putting definitions which are only used by one driver in
> arch/arm/*/include
>> is silly.

I also happy with this method.

Thank you,
Kyungmin Park
