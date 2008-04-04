Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34IwHXV008268
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 14:58:17 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34IvpWF013991
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 14:57:53 -0400
Received: by gv-out-0910.google.com with SMTP id l14so110267gvf.13
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 11:57:04 -0700 (PDT)
Date: Fri, 4 Apr 2008 11:56:50 -0700
From: Brandon Philips <brandon@ifup.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080404185650.GB4899@plankton.ifup.org>
References: <47ED68E3.7040400@hhs.nl>
	<20080403212728.GE14369@plankton.ifup.org>
	<47F5D1F6.2020906@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F5D1F6.2020906@hhs.nl>
Cc: video4linux-list@redhat.com, spca50x-devs@lists.sourceforge.net
Subject: Re: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
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

On 09:00 Fri 04 Apr 2008, Hans de Goede wrote:
>  Brandon Philips wrote:
> > On 22:53 Fri 28 Mar 2008, Hans de Goede wrote:
> >>  I'm currently posting these as .c files for easy reading and
> >>  compilation / testing, but I still hope to get a lot of feedback / a
> >>  thorough review, esp of the core <-> pac207 split version as I hope
> >>  to submit that as a patch for mainline inclusion soon.
> > The driver look pretty good.  Comments inline.
> 
>  Thanks for the review!
> 
> >> struct pac207_decompress_table_t {
> >> 	u8 is_abs;
> >> 	u8 len;
> >> 	s8 val;
> >> };
> > Why add the _t?
> 
>  So that I can write "struct pac207_decompress_table_t 
>  pac207_decompress_table[256];" further on.

But, why does the struct have a _t on the end of the name?  Usually that
is used for typedefs of structs.

> > This all needs some locking to protect from multi-threaded applications.
> > Otherwise the hardware and data structures could be in two different
> > states.
> 
>  They are all called with the usbvideo2 "core" fileop_mutex lock held, as is 
>  documented in usbvideo2.h

Oops, I see that now.

> >> static void usbvideo2_urb_complete(struct urb *urb)
> >> {
> >> 	struct usbvideo2_device* cam = urb->context;
> >> 	struct usbvideo2_frame_t** f;
> >> 	int i, ret;
> >>
> >> 	switch (urb->status) {
> >> 		case 0:
> >> 			break;
> >> 		case -ENOENT:		/* usb_kill_urb() called. */
> >> 		case -ECONNRESET:	/* usb_unlink_urb() called. */
> >> 		case -ESHUTDOWN:	/* The endpoint is being disabled. */
> >> 			return;
> >> 		default:
> >> 			goto resubmit_urb;
> >> 	}
> >>
> >> 	f = &cam->frame_current;
> >>
> >> 	if (!(*f)) {
> >> 		if (list_empty(&cam->inqueue))
> >> 			goto resubmit_urb;
> >>
> >> 		(*f) = list_entry(cam->inqueue.next, struct usbvideo2_frame_t,
> >> 					frame);
> >> 	} 
> > Don't you want to take a spinlock here?  Most accesses of inqueue seem
> > to take a spinlock.
> 
>  Good catch! Note that this bug is present in the current in mainline zc0301, 
>  et61x251, and sn9c102 drivers too!!
> 

Ok, I will look at this and submit patches.  Thanks.

>  I'm currently trying to merge my work and the work to port gspca as a whole 
>  to v4l2 of Jean-François Moine, so don't expect a new iteration of this 
>  soon, as I first want to have a clear path for merging these 2 works.

Great.  It would be good to get gspca into the Kernel.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
