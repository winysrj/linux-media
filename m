Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756222AbeAIOrx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:47:53 -0500
Date: Tue, 9 Jan 2018 15:47:54 +0100
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
Message-ID: <20180109144754.GB13228@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <7187306.jmXyF4vJKt@avalon>
 <20180109100410.GA11968@kroah.com>
 <2835808.JOrOUjDU6l@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2835808.JOrOUjDU6l@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 09, 2018 at 04:26:28PM +0200, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Tuesday, 9 January 2018 12:04:10 EET Greg KH wrote:
> > On Tue, Jan 09, 2018 at 10:40:21AM +0200, Laurent Pinchart wrote:
> > > On Saturday, 6 January 2018 11:40:26 EET Greg KH wrote:
> > >> On Sat, Jan 06, 2018 at 10:09:07AM +0100, Greg KH wrote:
> > >> 
> > >> While I'm all for fixing this type of thing, I feel like we need to do
> > >> something "else" for this as playing whack-a-mole for this pattern is
> > >> going to be a never-ending battle for all drivers for forever.
> > > 
> > > That's my concern too, as even if we managed to find and fix all the
> > > occurrences of the problematic patterns (and we won't), new ones will keep
> > > being merged all the time.
> > 
> > And what about the millions of lines of out-of-tree drivers that we all
> > rely on every day in our devices?  What about the distro kernels that
> > add random new drivers?
> 
> Of course, even though the out-of-tree drivers probably come with lots of 
> security issues worse than this one.

Sure, but I have worked with some teams that have used coverity to find
and fix all of the reported bugs it founds.  So some companies are
trying to fix their problems here, let's not make it impossible for them :)

> > We need some sort of automated way to scan for this.
> 
> Is there any initiative to implement such a scan in an open-source tool ?

Sure, if you want to, but I have no such initiative...

> We also need to educate developers. An automatic scanner could help there, but 
> in the end the information has to spread to all our brains. It won't be easy, 
> and is likely not fully feasible, but it's no different than how developers 
> have to be educated about race conditions and locking for instance. It's a 
> mind set.

Agreed.

> > Intel, any chance we can get your coverity rules?  Given that the date
> > of this original patchset was from last August, has anyone looked at
> > what is now in Linus's tree?  What about linux-next?  I just added 3
> > brand-new driver subsystems to the kernel tree there, how do we know
> > there isn't problems in them?
> > 
> > And what about all of the other ways user-data can be affected?  Again,
> > as Peter pointed out, USB devices.  I want some chance to be able to at
> > least audit the codebase we have to see if that path is an issue.
> > Without any hint of how to do this in an automated manner, we are all
> > in deep shit for forever.
> 
> Or at least until the hardware architecture evolves. Let's drop the x86 
> instruction set, expose the µops, and have gcc handle the scheduling. Sure, it 
> will mean recompiling everything for every x86 CPU model out there, but we 
> have source-based distros to the rescue :-D

Then we are back at the itanium mess, where all of the hardware issues
were supposed be fixed by the compiler writers.  We all remember how
well that worked out...

> > >> Either we need some way to mark this data path to make it easy for tools
> > >> like sparse to flag easily, or we need to catch the issue in the driver
> > >> subsystems, which unfortunatly, would harm the drivers that don't have
> > >> this type of issue (like here.)
> > > 
> > > But how would you do so ?
> > 
> > I do not know, it all depends on the access pattern, right?
> 
> Any data coming from userspace could trigger such accesses. If we want 
> complete coverage the only way I can think of is starting from syscalls and 
> tainting data down the call stacks (__user could help to some extend), but 
> we'll likely be drowned in false positives. I don't see how we could mark 
> paths manually.

I agree, which is why I want to see how someone did this work
originally.  We have no idea as no one is telling us anything :(

How do we "know" that these are the only problem areas?  When was the
last scan run?  On what tree?  And so on...

thanks,

greg k-h
