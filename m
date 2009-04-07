Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZDGBbJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 21:31:09 -0400
Date: Mon, 6 Apr 2009 22:29:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.30] V4L/DVB updates
Message-ID: <20090406222940.02258999@pedra.chehab.org>
In-Reply-To: <alpine.LFD.2.00.0904061808580.4010@localhost.localdomain>
References: <20090406215632.3eb96373@pedra.chehab.org>
	<alpine.LFD.2.00.0904061808580.4010@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Mon, 6 Apr 2009 18:11:34 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 6 Apr 2009, Mauro Carvalho Chehab wrote:
> > 
> > Please pull from:
> >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> 
> Have you rebased your tree and pushed out multiple versions of it?
> 
> I'm getting very confusing things from the mirrors, which are subtly 
> different from the copy on master.
> 
> This all looks like it was rebased just hours ago, and to top it off, it 
> looks like you actually change stuff you had exported earlier.
> 
> Don't do that. Really. It's very annoying. More than annoying, in fact. 
> This had better simply not happen again!

Yes, unfortunately I had to rebase. I noticed that one of the patches were
creating a file that didn't belong to that changeset, creating a file on the
wrong place (at -p2 diff format).

We should be discussing during this kernel cycle about migrating our
development tree to use -git (instead of Mercurial). I hope that this will
avoid to detect such errors so late, and avoid a few conversion issues we
currently have.

Sorry for the mess.

-- 

Cheers,
Mauro
