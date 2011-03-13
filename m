Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35328 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab1CMBpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 20:45:31 -0500
Received: by ewy4 with SMTP id 4so1303883ewy.19
        for <linux-media@vger.kernel.org>; Sat, 12 Mar 2011 17:45:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110313032208.ab1b6488.jean.bruenn@ip-minds.de>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
	<76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
	<ba12e998349efa465be466a4d7f9d43f@localhost>
	<3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
	<81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
	<af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
	<AANLkTimqGxS6OYNarqQwZNxFk+rccPn40UcK+6Oo72SC@mail.gmail.com>
	<3934d121118af31f8708589189a42b95@localhost>
	<AANLkTikYjaeXnhA3iP+kxjpA-NU4QQw-_YhRFf4U=30a@mail.gmail.com>
	<3DAC424F-1318-4E9D-B1E6-949ABE9E3CBB@wilsonet.com>
	<20110313032208.ab1b6488.jean.bruenn@ip-minds.de>
Date: Sat, 12 Mar 2011 20:45:29 -0500
Message-ID: <AANLkTikZ4KFSrzj6cJhbST9DWVcDqgQ6Y8R3we9614Bo@mail.gmail.com>
Subject: Re: WinTV 1400 broken with recent versions?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Mar 12, 2011 at 9:22 PM, Jean-Michel Bruenn
<jean.bruenn@ip-minds.de> wrote:
> So i guess, nobody here can help me to solve that problems?
>
> xc2028 1-0064: i2c output error: rc = -6 (should be 64)
> xc2028 1-0064: -6 returned from send
> xc2028 1-0064: Error -22 while loading base firmware
> xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
>
> and nobody can tell me, whether thats a firmware problem, or is it an
> i2c problem? At least someone who could explain me, what the above
> errors mean?

It means the i2c bus failed to get an ACK back when talking to the
xc3028.  It could be a number of different things:

* broken cx23885 i2c master implementation
* bug in the xc3028 driver
* screwed up GPIOs causing the xc3028 to be held in reset
* i2c bus wedged

> Also, nobody has any idea what i could try (except for what
> i already did, including reverting patches and downgrading the kernel)?

If you're knowledgeable enough to downgrade the kernel, then your best
bet is to learn how to use git bisect so you can identify exactly
which patch introduced the regression.

> I don't think the card is that uncommon, because i've already seen some
> pages stating problems with that card, at least 3 on this maillinglist
> with exactly the same problem (not to talk about those people, who just
> send the card back and replace it with something else/people who don't
> use maillinglists/bugtracker) however, whether the card is common or
> uncommon is not very helpful/useful, so.. it shouldn't really matter.

Tens of thousands of cards sold.  Three complaints.  That should
indeed give you an idea how few people are using the card under Linux.
 That said, the likelihood of a card getting fixed is largely related
to how popular it is and the probability that some developer who
actually cares has the card.

> heh. I'm about to give up. just a pity because the card wasn't
> cheap when it came out and every page states "supported in linux" which
> seems to be not true anymore. I know that it was, back in 2008 when i
> wrote with S. Toth about it.

Well with Linux and open source in general, you get what you paid for.
 The only reason the card worked at all is because of the thousands of
dollars worth of man-hours that developers like Steve donated to bring
up the board in the first place.  The downside of course is that since
you paid *nothing* for Linux support, you cannot really complain when
it stops working.  If the card is unpopular and therefore there aren't
developers willing to work on it, and you're not knowledgeable enough
to fix it yourself, then you are largely SOL.

> http://git.linuxtv.org/anttip/media_tree.git?a=commit;h=6676237398d0c2e61e5a3a27e0951f60d6ef6fe3
>
> Here's the commit when the card was added. I was using it without any
> trouble around that time. Well if someone knows what i could try (i
> could also hack around in the source if someone tells me what to
> change/where to change) i'd be very happy about ANY information.

Yeah, if you can git bisect to identify which patch broke the support,
Andy can probably offer some idea what is going on.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
