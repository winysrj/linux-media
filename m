Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64258 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1LAVS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 16:18:26 -0500
Received: by eaak14 with SMTP id k14so2648796eaa.19
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2011 13:18:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112012042.57343.laurent.pinchart@ideasonboard.com>
References: <4ED65C46.20502@netup.ru>
	<CAGoCfiw16bAtPHfrtsDDOBL4BeFnH+zMqcz9wBitGGSq_RZtJA@mail.gmail.com>
	<4ED68AF0.8000903@linuxtv.org>
	<201112012042.57343.laurent.pinchart@ideasonboard.com>
Date: Thu, 1 Dec 2011 16:18:24 -0500
Message-ID: <CALzAhNW_BSf-MbD8yM8YyrjaaGnTsni4NOzaRBu0zZ6zFxgP7Q@mail.gmail.com>
Subject: Re: LinuxTV ported to Windows
From: Steven Toth <stoth@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Abylay Ospan <aospan@netup.ru>,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> The point I'm trying to make: Someone made a presumably nice open source
>> port to a new platform and the first thing you're doing is to play the
>> GPL-has-been-violated-card, even though you're admitting that you don't
>> know whether any right is being violated or not. Please don't do that.
>> It's not very encouraging to someone who just announced free software.
>
> Thanks for pointing this out. I would have reacted similarly to Devin, not to
> discourage Abylay from working on this interesting project, but to warn him
> that there might be legal issues (I think we would all prefer early
> notifications from the community than late notifications from unfriendly
> lawyers :-)). You understanding this as an attack shows that we need to be
> more careful in the way we word our messages on license-related issues.

I've been silent as I wanted to see how the thread evolved. This is a
response in general to the group - not any individual.

Speaking as the maintainer and copyright owner I can say that it would
have been nice if someone had contacted me privately re the matter,
before hand. Not to assert any legal right, not for any approval,
simply as a courtesy and a perhaps a small 'Thank You'. NetUp could
have happily had my personal blessing on their project.

My first concern is that this only benefits NetUp on Windows, no other
company benefits on windows - as they all already have legal access to
the Conexant source reference driver. The Windows GPL driver
could/will evolve much faster than the Linux driver and that will suit
NetUp commercially and nobody else. Time will not be taken to
"backport" changes into the Linux driver and that's bad for the Linux
community. (Or, for commercial reasons, the backports will take longer
than expected)

My second concern is that NetUp have made it very simply for the
hundreds of no-name third party far-east companies (with zero
legitimate access to the Conexant windows source reference driver), to
take the windows driver, close source it, not distribute their changes
and compete against the few legitimate TVTuner companies left in the
world. If/when the one or two remaining TVTuner companies die because
their bread and butter Windows sales are being eroded to zero - how
does this help this community? It doesn't, it only helps NetUp.

I embrace open source, I welcome new developers, debate and growth....
I just think if you are going to get my 18 year old daughter pregnant
then it's courtesy to knock on my door and introduce yourself first -
regardless of my opinion or your legal rights.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
