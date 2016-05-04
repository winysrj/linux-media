Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46862 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbcEDPlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 11:41:25 -0400
Subject: Re: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
 <20160504133408.GA18570@acer> <572A0155.3030507@xs4all.nl>
 <CAM_ZknWELGNLnwFR66WbSEtDRHE2cEnkSOAOjAtd=aRXBgqgxw@mail.gmail.com>
Cc: Andrey Utkin <andrey_utkin@fastmail.com>,
	Ismael Luceno <ismael@iodev.co.uk>,
	Linux Media <linux-media@vger.kernel.org>,
	Curtis Hall <chall@corp.bluecherry.net>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <572A181E.4050204@xs4all.nl>
Date: Wed, 4 May 2016 17:41:18 +0200
MIME-Version: 1.0
In-Reply-To: <CAM_ZknWELGNLnwFR66WbSEtDRHE2cEnkSOAOjAtd=aRXBgqgxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/04/2016 04:22 PM, Andrey Utkin wrote:
> On Wed, May 4, 2016 at 5:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> BTW, looking at the MAINTAINERS file I see two email addresses for Andrey,
>> neither of which is the fastmail.com address this email came from.
> 
> Now I'm replying from corporate email.
> 
>> Andrey, it might be a good idea to post such fixes to the mailinglist sooner,
>> both to prevent situations like this and to keep the diffs between mainline
>> and your internal code as small as possible.
> 
> In a word - we would do what is possible to achieve that, but there's
> little time
> and little incentive for that.
> The codebases have already diverged a lot, having unique sets of runtime bugs.
> And this exact issue alone is not resolved yet in a good way and is
> not actually critical.
> Merging would require a lot of working time. And it is complicated by
> the fact that
> there's not going to be any new manufacturing orders (the minimal order quantity
> is too high for Bluecherry), and that we have picked tw5864 as
> reachable for retail orders.
> 

It sounds more like the status of this driver is "Odd Fixes" and not "Supported"
as it says today. From the MAINTAINERS file:

        S: Status, one of the following:
           Supported:   Someone is actually paid to look after this.
           Maintained:  Someone actually looks after it.
           Odd Fixes:   It has a maintainer but they don't have time to do
                        much other than throw the odd patch in. See below..
           Orphan:      No current maintainer [but maybe you could take the
                        role as you write your new code].
           Obsolete:    Old code. Something tagged obsolete generally means
                        it has been replaced by a better system and you
                        should be using that.

Yes, Ismael should have kept your authorship, but it won't be the first time
someone forgets that. Heck, I've forgotten it on occasion. Just point that out
politely and let Ismael post a new version of this patch.

Don't look for conspiracies when it is just a mistake. Relax, peace on earth,
don't worry, be happy and all that. Bad for everyone's blood pressure to get
so worked up about these things.

Looking at the recent history of this driver the patch contributions seem to
be more-or-less equally distributed between Krzysztof, Andrey and Ismael, not
that there are all that many.

So if Ismael is merging in some of your patches for free in his own time, then
I'd say why not? Again, provided correct authorship is maintained.

Regards,

	Hans
