Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:34220 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbcEDOxQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 10:53:16 -0400
Date: Wed, 4 May 2016 11:53:06 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	chall@corp.bluecherry.net, maintainers@bluecherrydvr.com
Subject: Re: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160504145305.GC9208@pirotess.lan>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
 <20160504133408.GA18570@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160504133408.GA18570@acer>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/May/2016 16:34, Andrey Utkin wrote:
> On Sat, Apr 30, 2016 at 12:17:08AM -0300, Ismael Luceno wrote:
> > Such frame size is met in practice. Also report oversized frames.
> > 
> > Based on patches by Andrey Utkin <andrey.utkin@corp.bluecherry.net>.
> 
> If it is based on my patches([1] [2]), then why you claim authorship and
> why you don't let me know (at last CCing me)?

Wasn't my intention, I gave you credit, I just merged the changes
and reworked the warning and commit message.

The whole point to have solo6x10 mainlined was to get rid of the
out-of-tree driver and convert the DKMS package to use media_build,
thus mainline should be kept in sync, so why are you not submitting
the patches yourself? I should have nothing to do with that.

> Do you know that 200 KiB is not the limit, just as previous value? I
> haven't researched subj deep enough to figure out proven good value for
> new buffer size.

I know, I know it depends on the quantization matrix, and it should
be possible to infer the limit, but like you I didn't do the research,
the difference is that I don't get paid to do it anymore.

> It's both laughable and infuriating for me to spectate your behaviour of
> "stealth driver developer".
> You have added yourself back to driver maintainers in MAINTAINERS file
> after your quit without letting us know.

Why the attack?

I didn't quit, I was dismissed, and the remaining ~5k USD I'm owed
was never paid. Curtis: any comment on that?

Also, I don't see what's the problem in re-adding myself, and I
don't understand why I was removed in the first place, it's not up
to Bluecherry, is it?

> You are not affiliated with Bluecherry for two years, and you are not
> informed about how the driver is working in production on customers
> setups. So you are not aware what are real issues with it. BTW do you
> still have a sample of actual hardware? Yeah, I agree that this can be
> argument against Bluecherry and lack of openness in its bug tracking.

You attend Bluecherry customers' needs because you're part of
Bluecherry; like you said I'm not, and I certainly don't get paid to
care about the out-of-tree driver issues or it's bug tracker.

And yes, I still have the hardware.

> But you are also not open and not collaborating.

What do you think I should do? Seriously, I don't get it.

> The point of my accusation to you is that you seem to be just gaining
> "kernel developer" score for nobody's (except your CV's) benefit.
> Development and maintenance is what Hans Verkuil, Krzysztof Halasa and
> others do to this driver, but not this.
> 
> Sorry to be harsh.

I think you're the only one keeping such a score, and I never claimed
my work being more or superior to anyone's else.

You're out of your mind, man.
