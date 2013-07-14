Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4905 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3GNW4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 18:56:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-media@vger.kernel.org
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
Date: Mon, 15 Jul 2013 00:56:17 +0200
Message-ID: <3450029.Clt96MKhHs@wyst>
In-Reply-To: <CAGoCfiwhC7EZHY0KQ-MF+NcSJDkhsaT_SP_MQCY7fGvp4C4Svw@mail.gmail.com>
References: <1139404719.20130516194142@eikelenboom.it> <3683080.CL97pXOYgk@wyst> <CAGoCfiwhC7EZHY0KQ-MF+NcSJDkhsaT_SP_MQCY7fGvp4C4Svw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, July 14, 2013 18:44:13 Devin Heitmueller wrote:
> On Sun, Jul 14, 2013 at 5:39 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> > If you can get cx25821-video.c to work with vb2, then we can take a look at the alsa
> >> > code.
> 
> If I can make a suggestion:  fix the lock problem first.

That's why I propose to move to vb2 :-)

I looked at it for a bit and what makes locking a problem is videobuf in the
first place. It's the cause of the locking problems and the solution is to get
rid of it. In vb2 I understand at least who is locking what, whereas videobuf
is locking and unlocking at the weirdest places. From what I remember it
was not really solvable without hacking videobuf, which is something you
really don't want to do. Don't ask me the details, it's been a while ago that
I looked at this particular issue.

I did similar vb2 conversions for go7007 and solo6x10 for pretty much the
same reasons: fixing an unmaintainable locking spaghetti.

In general I agree with you, but in this particular case moving to vb2 *is* the
solution for the problem.

Regards,

	Hans

> The last
> thing you want to do is simultaneously debug a known buffer management
> problem at the same time you're trying to port to VB2.  I panic'd my
> system enough times during the em28xx conversion where you really want
> to know whether the source is the VB2 work in progress or some other
> issue with buffer management.
> 
> I'm not saying to not do the VB2 port -- just that you would be well
> served to have a reasonable stable driver before attempting to do the
> port.
> 
> That said, I guess it's possible that digging into the code enough to
> understand what specifically has to be done for a VB2 port might
> reveal the source of the locking problem, but that's not how I would
> do it.
> 
> Devin
> 
> 
