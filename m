Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:58937 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbcEDOEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 10:04:12 -0400
Subject: Re: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
To: Andrey Utkin <andrey_utkin@fastmail.com>,
	Ismael Luceno <ismael@iodev.co.uk>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
 <20160504133408.GA18570@acer>
Cc: linux-media@vger.kernel.org, chall@corp.bluecherry.net,
	maintainers@bluecherrydvr.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <572A0155.3030507@xs4all.nl>
Date: Wed, 4 May 2016 16:04:05 +0200
MIME-Version: 1.0
In-Reply-To: <20160504133408.GA18570@acer>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I've dropped Ismael's patch from my pull request to Mauro until this
is resolved.

Who actually maintains this driver? I would say Andrey since he works for
bluecherry. If Ismael is no longer affiliated (either officially or unofficially)
with bluecherry, then his name should be removed.

BTW, looking at the MAINTAINERS file I see two email addresses for Andrey,
neither of which is the fastmail.com address this email came from.

Ismael, please keep the correct author if it isn't you. And a CC to Andrey
certainly doesn't hurt.

Andrey, it might be a good idea to post such fixes to the mailinglist sooner,
both to prevent situations like this and to keep the diffs between mainline
and your internal code as small as possible.

I don't really care who posts fixes as long as authorship info etc. remains
intact and the code is obviously an improvement.

Regards,

	Hans

On 05/04/2016 03:34 PM, Andrey Utkin wrote:
> On Sat, Apr 30, 2016 at 12:17:08AM -0300, Ismael Luceno wrote:
>> Such frame size is met in practice. Also report oversized frames.
>>
>> Based on patches by Andrey Utkin <andrey.utkin@corp.bluecherry.net>.
> 
> If it is based on my patches([1] [2]), then why you claim authorship and
> why you don't let me know (at last CCing me)?
> 
> Do you know that 200 KiB is not the limit, just as previous value? I
> haven't researched subj deep enough to figure out proven good value for
> new buffer size.
> 
> It's both laughable and infuriating for me to spectate your behaviour of
> "stealth driver developer".
> You have added yourself back to driver maintainers in MAINTAINERS file
> after your quit without letting us know.
> You are not affiliated with Bluecherry for two years, and you are not
> informed about how the driver is working in production on customers
> setups. So you are not aware what are real issues with it. BTW do you
> still have a sample of actual hardware? Yeah, I agree that this can be
> argument against Bluecherry and lack of openness in its bug tracking.
> But you are also not open and not collaborating.
> 
> The point of my accusation to you is that you seem to be just gaining
> "kernel developer" score for nobody's (except your CV's) benefit.
> Development and maintenance is what Hans Verkuil, Krzysztof Halasa and
> others do to this driver, but not this.
> 
> Sorry to be harsh.
> 
> [1] https://github.com/bluecherrydvr/solo6x10/commit/5cd985087362e2e524b3e44504eea791ae7cda7e
> [2] https://github.com/bluecherrydvr/solo6x10/commit/3b437f79c40438eb09bb2d5dbcfe67dbc94648ed
> 
