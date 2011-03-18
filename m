Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57641 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1CRAuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 20:50:13 -0400
Subject: Re: [PATCH 5/6] lirc_zilog: error out if buffer read bytes !=
 chunk size
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110317190827.GD5941@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
	 <1300307071-19665-6-git-send-email-jarod@redhat.com>
	 <1300320442.2296.25.camel@localhost> <20110317131909.GA5941@redhat.com>
	 <210cb1d1-4426-4b73-92aa-ec4337d9642c@email.android.com>
	 <20110317154204.GB5941@redhat.com>
	 <9e23e0c0-8944-458f-a521-216239dc9bf9@email.android.com>
	 <20110317190827.GD5941@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 20:50:33 -0400
Message-ID: <1300409433.2317.64.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-03-17 at 15:08 -0400, Jarod Wilson wrote:
> On Thu, Mar 17, 2011 at 12:16:31PM -0400, Andy Walls wrote:
> > Jarod Wilson <jarod@redhat.com> wrote:
> .
> > 
> > But the orignal intent of the check I put in was to avoid passing
> partial/junk data to userspace, and go around again to see if good
> data could be provided.  
> > 
> > Your check bails when good data that might be sitting there still.
> That doesn't seem like a good trade for supporting backward compat for
> old kernels.
> 
> Ah. Another thing I neglected to notice then. :)
> 
> Perhaps there should be a retry count check as well then, as otherwise,
> its possible to get stuck in that loop forever (which is what was
> happening on older kernels). Its conceivable that similar could happen on
> a newer kernel for some reason.

Well, lets see,

>From the perspective of userspace & lircd:

1. A specification compliance failure for a corner case isn't too bad
(bailing out on junk and leaving good data behind)

2. An unrecoverable failure for any case is very bad (spinning/hanging
on a result that won't change)

3. Sending unitialized bytes out to userspace with copy_to_user() is
very bad.
(I recall the old code would do the copy to user and always tell
userspace it got a code whether it read anything out of the buffer or
not.  IIRC, that leaked information off the stack.)


If the code as patched avoids the two very bad things (#2 and #3), then
the patch is OK by me.

Regards,
Andy

