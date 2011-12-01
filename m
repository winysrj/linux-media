Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:33867 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1LAXKj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 18:10:39 -0500
Message-ID: <4ED80969.6060404@linuxtv.org>
Date: Fri, 02 Dec 2011 00:10:33 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Abylay Ospan <aospan@netup.ru>,
	laurent.pinchart@ideasonboard.com
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com> <4ED68AF0.8000903@linuxtv.org> <201112012042.57343.laurent.pinchart@ideasonboard.com> <CALzAhNW_BSf-MbD8yM8YyrjaaGnTsni4NOzaRBu0zZ6zFxgP7Q@mail.gmail.com>
In-Reply-To: <CALzAhNW_BSf-MbD8yM8YyrjaaGnTsni4NOzaRBu0zZ6zFxgP7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven,

On 01.12.2011 22:18, Steven Toth wrote:
>>> The point I'm trying to make: Someone made a presumably nice open source
>>> port to a new platform and the first thing you're doing is to play the
>>> GPL-has-been-violated-card, even though you're admitting that you don't
>>> know whether any right is being violated or not. Please don't do that.
>>> It's not very encouraging to someone who just announced free software.
>>
>> Thanks for pointing this out. I would have reacted similarly to Devin, not to
>> discourage Abylay from working on this interesting project, but to warn him
>> that there might be legal issues (I think we would all prefer early
>> notifications from the community than late notifications from unfriendly
>> lawyers :-)). You understanding this as an attack shows that we need to be
>> more careful in the way we word our messages on license-related issues.
> 
> I've been silent as I wanted to see how the thread evolved. This is a
> response in general to the group - not any individual.
> 
> Speaking as the maintainer and copyright owner I can say that it would
> have been nice if someone had contacted me privately re the matter,
> before hand. Not to assert any legal right, not for any approval,
> simply as a courtesy and a perhaps a small 'Thank You'. NetUp could
> have happily had my personal blessing on their project.

you could have said thank you for porting the driver as well: The port
enlarges the user base, is likely to uncover bugs and you might even
receive fixes to those bugs for free (unless the ranting goes on).

> My first concern is that this only benefits NetUp on Windows, no other
> company benefits on windows - as they all already have legal access to
> the Conexant source reference driver.

Are you implying that
a) it's not the users who benefit most?
b) other companies won't be able to use this driver?
c) NetUp doesn't have legal access to the reference driver?

> The Windows GPL driver
> could/will evolve much faster than the Linux driver and that will suit
> NetUp commercially and nobody else. Time will not be taken to
> "backport" changes into the Linux driver and that's bad for the Linux
> community. (Or, for commercial reasons, the backports will take longer
> than expected)

Why don't you do the backports yourself? You want NetUp to do the work
for you? The code is published in a Git repository. You can easily track
any changes.

> My second concern is that NetUp have made it very simply for the
> hundreds of no-name third party far-east companies (with zero
> legitimate access to the Conexant windows source reference driver), to
> take the windows driver, close source it, not distribute their changes
> and compete against the few legitimate TVTuner companies left in the
> world. If/when the one or two remaining TVTuner companies die because
> their bread and butter Windows sales are being eroded to zero - how
> does this help this community? It doesn't, it only helps NetUp.

Any company doing that could use any existing binary driver as well.
Besides that, I'm sure it's no problem for them to get access to any
reference driver they want.

> I embrace open source, I welcome new developers, debate and growth....
> I just think if you are going to get my 18 year old daughter pregnant
> then it's courtesy to knock on my door and introduce yourself first -
> regardless of my opinion or your legal rights.

A very compelling analogy.

Regards,
Andreas
