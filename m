Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42615 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1FXS4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 14:56:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110624061926.GA26504@linux-sh.org>
References: <4DDAE63A.3070203@gmx.de>
	<1308670579-15138-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<BANLkTim6wUaeZCya=9dMvU7iHj4W4E57Fg@mail.gmail.com>
	<201106220031.57972.laurent.pinchart@ideasonboard.com>
	<4E018189.3020305@gmx.de>
	<BANLkTikMLE=F4OLTRhQ6LYR=d1x6xukJXA@mail.gmail.com>
	<20110624061926.GA26504@linux-sh.org>
Date: Fri, 24 Jun 2011 20:55:57 +0200
Message-ID: <BANLkTi=RCx9Bifpw9BvqNAB0J+1ENkRK4A@mail.gmail.com>
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 24, 2011 at 08:19, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Jun 23, 2011 at 06:08:03PM +0200, Geert Uytterhoeven wrote:
>> On Wed, Jun 22, 2011 at 07:45, Florian Tobias Schandinat
>> <FlorianSchandinat@gmx.de> wrote:
>> > On 06/21/2011 10:31 PM, Laurent Pinchart wrote:
>> >> On Tuesday 21 June 2011 22:49:14 Geert Uytterhoeven wrote:
>> >>> As FOURCC values are always 4 ASCII characters (hence all 4 bytes must
>> >>> be non-zero), I don't think there are any conflicts with existing values
>> >>> of
>> >>> nonstd. To make it even safer and easier to parse, you could set bit 31
>> >>> of
>> >>> nonstd as a FOURCC indicator.
>> >>
>> >> I would then create a union between nonstd and fourcc, and document nonstd
>> >> as
>> >> being used for the legacy API only. Most existing drivers use a couple of
>> >> nonstd bits only. The driver that (ab)uses nonstd the most is pxafb and
>> >> uses
>> >> bits 22:0. Bits 31:24 are never used as far as I can tell, so nonstd&
>> >> 0xff000000 != 0 could be used as a FOURCC mode test.
>> >>
>> >> This assumes that FOURCCs will never have their last character set to
>> >> '\0'. Is
>> >> that a safe assumption for the future ?
>> >
>> > Yes, I think. The information I found indicates that space should be used
>> > for padding, so a \0 shouldn't exist.
>> > I think using only the nonstd field and requiring applications to check the
>> > capabilities would be possible, although not fool proof ;)
>>
>> So we can declare the 8 msb bits of nonstd reserved, and assume FOURCC if
>> any of them is set.
>>
>> Nicely backwards compatible, as sane drivers should reject nonstd values they
>> don't support (apps _will_ start filling in FOURCC values ignoring capabilities,
>> won't they?).
>>
> That seems like a reasonable case, but if we're going to do that then
> certainly the nonstd bit encoding needs to be documented and treated as a
> hard ABI.
>
> I'm not so sure about the if any bit in the upper byte is set assume
> FOURCC case though, there will presumably be other users in the future
> that will want bits for themselves, too. What exactly was the issue with
> having a FOURCC capability bit in the upper byte?

That indeed gives less issues (as long as you don't stuff 8-bit ASCII
in the MSB)
and more bits for tradiditional nonstd users.

BTW, after giving it some more thought: what does the FB_CAP_FOURCC buys
us? It's not like all drivers will support whatever random FOURCC mode
you give them,
so you have to check whether it's supported by doing a set_var first.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
