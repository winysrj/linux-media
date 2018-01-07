Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbeAGJJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Jan 2018 04:09:16 -0500
Date: Sun, 7 Jan 2018 10:09:18 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dsj@fb.com
Subject: Re: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
Message-ID: <20180107090918.GA29329@kroah.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520103240.32271.14706852449205864676.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180106090907.GG4380@kroah.com>
 <20180106094026.GA11525@kroah.com>
 <CAPcyv4je-agqvmNSJf7v-1VBOrfhOvcs_qASNPJiBzgTt70dPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4je-agqvmNSJf7v-1VBOrfhOvcs_qASNPJiBzgTt70dPA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 06, 2018 at 09:41:17AM -0800, Dan Williams wrote:
> On Sat, Jan 6, 2018 at 1:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sat, Jan 06, 2018 at 10:09:07AM +0100, Greg KH wrote:
> >> On Fri, Jan 05, 2018 at 05:10:32PM -0800, Dan Williams wrote:
> >> > Static analysis reports that 'index' may be a user controlled value that
> >> > is used as a data dependency to read 'pin' from the
> >> > 'selector->baSourceID' array. In order to avoid potential leaks of
> >> > kernel memory values, block speculative execution of the instruction
> >> > stream that could issue reads based on an invalid value of 'pin'.
> >> >
> >> > Based on an original patch by Elena Reshetova.
> >> >
> >> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> >> > Cc: linux-media@vger.kernel.org
> >> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> >> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> > ---
> >> >  drivers/media/usb/uvc/uvc_v4l2.c |    7 +++++--
> >> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> >> > index 3e7e283a44a8..7442626dc20e 100644
> >> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> >> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> >> > @@ -22,6 +22,7 @@
> >> >  #include <linux/mm.h>
> >> >  #include <linux/wait.h>
> >> >  #include <linux/atomic.h>
> >> > +#include <linux/compiler.h>
> >> >
> >> >  #include <media/v4l2-common.h>
> >> >  #include <media/v4l2-ctrls.h>
> >> > @@ -810,6 +811,7 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
> >> >     struct uvc_entity *iterm = NULL;
> >> >     u32 index = input->index;
> >> >     int pin = 0;
> >> > +   __u8 *elem;
> >> >
> >> >     if (selector == NULL ||
> >> >         (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
> >> > @@ -820,8 +822,9 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
> >> >                             break;
> >> >             }
> >> >             pin = iterm->id;
> >> > -   } else if (index < selector->bNrInPins) {
> >> > -           pin = selector->baSourceID[index];
> >> > +   } else if ((elem = nospec_array_ptr(selector->baSourceID, index,
> >> > +                                   selector->bNrInPins))) {
> >> > +           pin = *elem;
> >>
> >> I dug through this before, and I couldn't find where index came from
> >> userspace, I think seeing the coverity rule would be nice.
> >
> > Ok, I take it back, this looks correct.  Ugh, the v4l ioctl api is
> > crazy complex (rightfully so), it's amazing that coverity could navigate
> > that whole thing :)
> >
> > While I'm all for fixing this type of thing, I feel like we need to do
> > something "else" for this as playing whack-a-mole for this pattern is
> > going to be a never-ending battle for all drivers for forever.  Either
> > we need some way to mark this data path to make it easy for tools like
> > sparse to flag easily, or we need to catch the issue in the driver
> > subsystems, which unfortunatly, would harm the drivers that don't have
> > this type of issue (like here.)
> >
> > I'm guessing that other operating systems, which don't have the luxury
> > of auditing all of their drivers are going for the "big hammer in the
> > subsystem" type of fix, right?
> >
> > I don't have a good answer for this, but if there was some better way to
> > rewrite these types of patterns to just prevent the need for the
> > nospec_array_ptr() type thing, that might be the best overall for
> > everyone.  Much like ebpf did with their changes.  That way a simple
> > coccinelle rule would be able to catch the pattern and rewrite it.
> >
> > Or am I just dreaming?
> 
> At least on the coccinelle front you're dreaming. Julia already took a
> look and said:
> 
> "I don't think Coccinelle would be good for doing this (ie
> implementing taint analysis) because the dataflow is too complicated."

Sorry for the confusion, no, I don't mean the "taint tracking", I mean
the generic pattern of "speculative out of bounds access" that we are
fixing here.

Yes, as you mentioned before, there are tons of false-positives in the
tree, as to find the real problems you have to show that userspace
controls the access index.  But if we have a generic pattern that can
rewrite that type of logic into one where it does not matter at all
(i.e. like the ebpf proposed changes), then it would not be an issue if
they are false or not, we just rewrite them all to be safe.

We need to find some way not only to fix these issues now (like you are
doing with this series), but to prevent them from every coming back into
the codebase again.  It's that second part that we need to keep in the
back of our minds here, while doing the first portion of this work.

> Perhaps the Coverity instance Dave mentioned at Ksummit 2012 has a
> role to play here?

We have a coverity instance that all kernel developers have access to
(just sign up and we grant it.)  We have at least one person working
full time on fixing up errors that this instance reports.  So if we
could get those rules added (which is why I asked for them), it would be
a great first line of defense to prevent the "adding new problems" issue
from happening right now for the 4.16-rc1 merge window.

thanks,

greg k-h
