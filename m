Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HL0C1D027100
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 17:00:17 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HKmTxY002698
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 16:49:05 -0400
From: Andy Walls <awalls@radix.net>
To: Dave Huseby <dave@linuxprogrammer.org>
In-Reply-To: <15770467.41224260830600.JavaMail.dave@mycroft>
References: <15770467.41224260830600.JavaMail.dave@mycroft>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 16:50:14 -0400
Message-Id: <1224276614.3124.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: strange hauppauge wintv device number
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 2008-10-17 at 09:27 -0700, Dave Huseby wrote:
> From: "Andy Walls" <awalls@radix.net>
> On Thu, 2008-10-16 at 14:26 -0700, Dave Huseby wrote:
> > > Hi Everybody,
> > > 
> > > I just bought an old hauppauge wintv card off of ebay and even though it is a model 401--which everybody claims to be supported by linux--it isn't working with tvtime or xawtv.  I noticed that its subsystem id is not detected by the bttv driver in the 2.6 kernel.  Here's the lspci dump:
> > > 
> > > 01:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
> > >         Subsystem: Hauppauge computer works Inc. Unknown device 03eb    <----- 03eb instead of the usual 13eb
> > >         Flags: bus master, medium devsel, latency 64, IRQ 21
> > >         Memory at cfdfe000 (32-bit, prefetchable) [size=4K]
> > >         Capabilities: [44] Vital Product Data
> > >         Capabilities: [4c] Power Management version 2
> > > 
> > > 01:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
> > >         Subsystem: Hauppauge computer works Inc. Unknown device 03eb    <----- 03eb instead of the usual 13eb
> > >         Flags: medium devsel, IRQ 21
> > >         Memory at cfdff000 (32-bit, prefetchable) [size=4K]
> > >         Capabilities: [44] Vital Product Data
> > >         Capabilities: [4c] Power Management version 2
> > 
> > A user on the list had a similar problem in early May of this year.  His
> > device Vendor ID was coming across as 009e instead of 109e for
> > Brooktree.  He resolved his problem by pulling the card out, blowing the
> > dust out of the slot, and reinstalling the card.  

> Yep, that was it.  I pulled the card out, blew out the slot with a can
> of air, plugged it back in and everything worked perfectly.

Cool.  Just copying the list for posterity, in case someone else has the
problem in the future.  Not that it's easy for non-list subscribers to
check the v4l list archives.

Regards,
Andy



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
