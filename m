Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753390AbeAIKEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 05:04:08 -0500
Date: Tue, 9 Jan 2018 11:04:10 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        alan@linux.intel.com, peterz@infradead.org, netdev@vger.kernel.org,
        tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        torvalds@linux-foundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
Message-ID: <20180109100410.GA11968@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180106090907.GG4380@kroah.com>
 <20180106094026.GA11525@kroah.com>
 <7187306.jmXyF4vJKt@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7187306.jmXyF4vJKt@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:40:21AM +0200, Laurent Pinchart wrote:
> On Saturday, 6 January 2018 11:40:26 EET Greg KH wrote:
> > On Sat, Jan 06, 2018 at 10:09:07AM +0100, Greg KH wrote:
> > 
> > While I'm all for fixing this type of thing, I feel like we need to do
> > something "else" for this as playing whack-a-mole for this pattern is
> > going to be a never-ending battle for all drivers for forever.
> 
> That's my concern too, as even if we managed to find and fix all the 
> occurrences of the problematic patterns (and we won't), new ones will keep 
> being merged all the time.

And what about the millions of lines of out-of-tree drivers that we all
rely on every day in our devices?  What about the distro kernels that
add random new drivers?

We need some sort of automated way to scan for this.

Intel, any chance we can get your coverity rules?  Given that the date
of this original patchset was from last August, has anyone looked at
what is now in Linus's tree?  What about linux-next?  I just added 3
brand-new driver subsystems to the kernel tree there, how do we know
there isn't problems in them?

And what about all of the other ways user-data can be affected?  Again,
as Peter pointed out, USB devices.  I want some chance to be able to at
least audit the codebase we have to see if that path is an issue.
Without any hint of how to do this in an automated manner, we are all
in deep shit for forever.

> > Either we need some way to mark this data path to make it easy for tools
> > like sparse to flag easily, or we need to catch the issue in the driver
> > subsystems, which unfortunatly, would harm the drivers that don't have
> > this type of issue (like here.)
> 
> But how would you do so ?

I do not know, it all depends on the access pattern, right?

> > I'm guessing that other operating systems, which don't have the luxury
> > of auditing all of their drivers are going for the "big hammer in the
> > subsystem" type of fix, right?
> 
> Other operating systems that ship closed-source drivers authored by hardware 
> vendors and not reviewed by third parties will likely stay vulnerable forever. 
> That's a small concern though as I expect those drivers to contain much large 
> security holes anyway.

Well yes, but odds are those operating systems are doing something to
mitigate this, right?  Slowing down all user/kernel data paths?
Targeted code analysis tools?  Something else?  I doubt they just don't
care at all about it.  At the least, I would think Coverity would be
trying to sell licenses for this :(

thanks,

greg k-h
