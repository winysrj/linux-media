Return-path: <mchehab@pedra>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43735 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759678Ab1F1QkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 12:40:13 -0400
Date: Tue, 28 Jun 2011 17:42:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
Message-ID: <20110628174223.3d78ca4c@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
References: <4E0519B7.3000304@redhat.com>
	<201106271907.59067.hverkuil@xs4all.nl>
	<BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>
	<201106280804.48742.hverkuil@xs4all.nl>
	<BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> (In fact, the _correct_ thing to do would probably be to just do
> 
>    #define ENOIOCTLCMD ENOTTY
> 
> and get rid of any translation - just giving ENOTTY a more appropriate
> name and less chance for confusion)

Some code uses the two to separate 'the driver specific helper code
doesn't handle this' and 'does handle this'. In that situation you take
away the ability of a driver to override a midlayer ioctl with -ENOTTY to
say "I don't support this even if most people do"

> There may be applications out there that really break when they get
> ENOTTY instead of EINVAL. But most cases that check for errors from
> ioctl's tend to just say "did this succeed or not" rather than "did
> this return EINVAL". That's *doubly* true since the error code has
> been ambiguous, so checking for the exact error code has always been
> pretty pointless.

Chances are if anything is busted its busted the other way on Linux and
expects -ENOTTY. Certainly the large number I've been fixing over time
haven't shown up any problems.
