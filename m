Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:38725 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0ECQ7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 12:59:00 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ideal DVB-C PCI/e card?
References: <4BDE5AA1.1050000@gmail.com> <87pr1dbf1q.fsf@nemi.mork.no>
	<4BDEEE35.6040308@gmail.com>
Date: Mon, 03 May 2010 18:58:52 +0200
In-Reply-To: <4BDEEE35.6040308@gmail.com> (Jed's message of "Tue, 04 May 2010
	01:39:33 +1000")
Message-ID: <87ocgwapmb.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jed <jedi.theone@gmail.com> writes:

> Just curious, why did you pick VDR over MythTV?
> I would rather use the later + OSCam (maybe) if feasible.

It's mostly because I had no experience with either and tried VDR
first.  And then I never got around to trying MythTV.

I don't know if MythTV would fit. Probably would.  My impression was
that it was mainly targeted at media portal + analogue TV while VDR was
made for live DVB from the start, which was why I trid VDR first.  One
of my requirements was that I could tune to any channel by simply
accessing a streaming URL, i.e. without touching any portal at all.  I
started my small project mainly because I have ethernet around the house
but not coax, and I got a request for live TV two floors away from the
nearest coax cable.

VDR with the streamdev plugin turned out to be an excellent headless
streaming server. It is perfectly suitable for the more primitive
streaming display devices, like popcornhour boxes or TV sets with
ethernet, which are great for watching live streams but suck when it
comes to portal "browsing".

One application I looked at initially was mumudvb, since it is targeted
towards live streaming.  I must admit that I liked the idea of just
multicasting all channels all the time, but unfortunately that would
have required 7 or 8 tuners just to get the "free" channels from my
cable operator.  Which of course would be out of the question even if
dual DVB-C cards existed. And more HD channels are probably going to
make this even more difficult.  And I really won't have more than a
couple of channel "consumers" anyway so it would most certainly be way
overkill.  But fun though :-)




Bjørn
