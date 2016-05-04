Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36016 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbcEDPJf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 11:09:35 -0400
Received: by mail-qk0-f170.google.com with SMTP id x7so26473831qkd.3
        for <linux-media@vger.kernel.org>; Wed, 04 May 2016 08:09:35 -0700 (PDT)
Date: Wed, 4 May 2016 12:09:28 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey_utkin@fastmail.com>,
	Ismael Luceno <ismael@iodev.co.uk>,
	Linux Media <linux-media@vger.kernel.org>,
	Curtis Hall <chall@corp.bluecherry.net>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: [PATCH 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160504150928.GD9208@pirotess.lan>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
 <20160504133408.GA18570@acer>
 <572A0155.3030507@xs4all.nl>
 <CAM_ZknWELGNLnwFR66WbSEtDRHE2cEnkSOAOjAtd=aRXBgqgxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_ZknWELGNLnwFR66WbSEtDRHE2cEnkSOAOjAtd=aRXBgqgxw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/May/2016 17:22, Andrey Utkin wrote:
> On Wed, May 4, 2016 at 5:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > BTW, looking at the MAINTAINERS file I see two email addresses for Andrey,
> > neither of which is the fastmail.com address this email came from.
> 
> Now I'm replying from corporate email.
> 
> > Andrey, it might be a good idea to post such fixes to the mailinglist sooner,
> > both to prevent situations like this and to keep the diffs between mainline
> > and your internal code as small as possible.
> 
> In a word - we would do what is possible to achieve that, but
> there's little time and little incentive for that.
> The codebases have already diverged a lot, having unique sets of runtime bugs.

The divergence is due to the vb2 porting effort by Hans. History
was not properly conserved, but it is otherwise compatible, and most
changes can still be ported back and forth without trouble.

> And this exact issue alone is not resolved yet in a good way and is
> not actually critical.
> Merging would require a lot of working time. And it is complicated by
> the fact that there's not going to be any new manufacturing orders
> (the minimal order quantity is too high for Bluecherry), and that
> we have picked tw5864 as reachable for retail orders.

Right now it would be easy to keep the two in sync, there has been
not many changes since I left, and if changes are integrated into
mainline first, there will be no further issues.
