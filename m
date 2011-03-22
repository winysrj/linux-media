Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1CVUjl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 16:39:41 -0400
Date: Tue, 22 Mar 2011 16:39:36 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes != chunk
 size
Message-ID: <20110322203936.GC19325@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
 <1300307071-19665-6-git-send-email-jarod@redhat.com>
 <1300320442.2296.25.camel@localhost>
 <20110317131909.GA5941@redhat.com>
 <210cb1d1-4426-4b73-92aa-ec4337d9642c@email.android.com>
 <20110317154204.GB5941@redhat.com>
 <9e23e0c0-8944-458f-a521-216239dc9bf9@email.android.com>
 <20110317190827.GD5941@redhat.com>
 <1300409433.2317.64.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300409433.2317.64.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 17, 2011 at 08:50:33PM -0400, Andy Walls wrote:
> On Thu, 2011-03-17 at 15:08 -0400, Jarod Wilson wrote:
> > On Thu, Mar 17, 2011 at 12:16:31PM -0400, Andy Walls wrote:
> > > Jarod Wilson <jarod@redhat.com> wrote:
> > .
> > > 
> > > But the orignal intent of the check I put in was to avoid passing
> > partial/junk data to userspace, and go around again to see if good
> > data could be provided.  
> > > 
> > > Your check bails when good data that might be sitting there still.
> > That doesn't seem like a good trade for supporting backward compat for
> > old kernels.
> > 
> > Ah. Another thing I neglected to notice then. :)
> > 
> > Perhaps there should be a retry count check as well then, as otherwise,
> > its possible to get stuck in that loop forever (which is what was
> > happening on older kernels). Its conceivable that similar could happen on
> > a newer kernel for some reason.
> 
> Well, lets see,
> 
> >From the perspective of userspace & lircd:
> 
> 1. A specification compliance failure for a corner case isn't too bad
> (bailing out on junk and leaving good data behind)
> 
> 2. An unrecoverable failure for any case is very bad (spinning/hanging
> on a result that won't change)
> 
> 3. Sending unitialized bytes out to userspace with copy_to_user() is
> very bad.
> (I recall the old code would do the copy to user and always tell
> userspace it got a code whether it read anything out of the buffer or
> not.  IIRC, that leaked information off the stack.)
> 
> 
> If the code as patched avoids the two very bad things (#2 and #3), then
> the patch is OK by me.

I *think* what I've got now should address both 2 and 3, with a very
minimal risk of leaving data behind, since it'll retry a couple of times
before bailing out of the loop, so it should be pretty unlikely we'd leave
any good data behind. But even if we do, like you said, this is just an IR
signal, the user can press the button on the remote again. :)

-- 
Jarod Wilson
jarod@redhat.com

