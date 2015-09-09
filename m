Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55565 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751862AbbIIOmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 10:42:32 -0400
Date: Wed, 9 Sep 2015 10:42:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
	<laurent.pinchart@ideasonboard.com>, <linux-media@vger.kernel.org>,
	<mchehab@osg.samsung.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work
 queue
In-Reply-To: <55EFEE14.5050100@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1509091033210.2045-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Sep 2015, Hans de Goede wrote:

> Hi,
> 
> On 08-09-15 16:36, Alan Stern wrote:
> > On Tue, 8 Sep 2015, Hans de Goede wrote:
> >
> >> Hi,
> >>
> >> On 09/07/2015 06:23 PM, Mian Yousaf Kaukab wrote:
> >>> urb completion callback is executed in host controllers interrupt
> >>> context. To keep preempt disable time short, add urbs to a list on
> >>> completion and schedule work to process the list.
> >>>
> >>> Moreover, save timestamp and sof number in the urb completion callback
> >>> to avoid any delays.
> >>
> >> Erm, I thought that we had already moved to using threaded interrupt
> >> handling for the urb completion a while (1-2 years ?) back. Is this then
> >> still needed ?
> >
> > We moved to handling URB completions in a tasklet, not a threaded
> > handler.
> 
> Right.
> 
> > (Similar idea, though.)  And the change was made in only one
> > or two HCDs, not in all of them.
> 
> Ah, I was under the impression this was a core change, not a per
> hcd change.

In fact, both the core and the HCD needed to be changed.  For example,
see commits 94dfd7edfd5c (core) and 9118f9eb4f1e (ehci-hcd).  (There
was more to it than just those two commits, of course.)

In one respect the change still isn't complete: Since the completion
callback occurs in a tasklet, we should allow interrupts to remain
enabled while the callback runs.  But some class drivers still expect
interrupts to be disabled at that time, so the core has to disable
interrupts before invoking the callback and then re-enable them
afterward.

There was a proposal to fix up a number of drivers so that we could 
leave interrupts enabled the whole time.  But I don't think it ever got 
merged.

Alan Stern

