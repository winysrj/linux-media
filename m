Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n15Hl8jk000549
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 12:47:14 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n15HD4qb020877
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 12:14:38 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Bryan Wu <cooloney@kernel.org>
Date: Thu, 5 Feb 2009 18:12:54 +0100
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
	<20081118133908.GA26119@linux-sh.org>
	<386072610902050110r192c53f5xf06a91ac3a115c8f@mail.gmail.com>
In-Reply-To: <386072610902050110r192c53f5xf06a91ac3a115c8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051812.54504.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de,
	linux-kernel@vger.kernel.org, "Hennerich,
	Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
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

Hi Bryan,

On Thursday 05 February 2009, Bryan Wu wrote:
> On Tue, Nov 18, 2008 at 9:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Fri, Nov 14, 2008 at 12:52:10AM +0100, Laurent Pinchart wrote:
> >> On Monday 10 November 2008, Hennerich, Michael wrote:
> >> > >On Thursday 06 November 2008, Bryan Wu wrote:
> >> > > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
> >> > > > struct vm_area_struct *vma) addr += PAGE_SIZE;
> >> > > >                 size -= PAGE_SIZE;
> >> > > >         }
> >> > > > +#else
> >> > > > +       if (i == video->queue.count ||
> >> > > > +               PAGE_ALIGN(size) != video->queue.buf_size) {
> >> > >
> >> > > Just out of curiosity, why do you need to PAGE_ALIGN size for
> >> > > non-MMU platforms ?
> >> >
> >> > Size and video->queue.buf_size is not the 100% same size (off by a few
> >> > bytes < pagesize), I think it's because on NOMMU the kernel calls
> >> > kmalloc() to allocate the buffer, not get_free_page().
> >>
> >> That's right, but only for private mappings. It makes little sense to
> >> create a private mapping on a V4L2 device as the kernel will read()
> >> device data into the buffer when mapping the device (at least on NOMMU
> >> platforms). Only shared mappings make sense in this case.
> >
> > The change itself is crap anyways, since it is just working around the
> > fact that vm_insert_page() presently -EINVAL's out on nommu. The
> > vmalloc_to_page()/vm_insert_page() pair is used extensively across the
> > v4l drivers, and it's unrealistic to expect to patch every call site with
> > this sort of a workaround.
> >
> > While we can't support vm_insert_page() in most cases, these sorts of
> > use cases where it is just iterating over a contiguous block of pages on
> > a VMA that has already been established is something that can at least be
> > handled fairly easily (in this case, even just doing nothing in
> > vm_insert_page() would likely give the desired result, although we ought
> > to fix up vm_insert_page() to do something more useful instead). Working
> > out the bounds of the VMA isn't exactly difficult either, since we have
> > all of that already filled in the VMA by the time vma_insert_page() is
> > called.
> >
> > Regarding the VMA flag, this can be rectified by providing a dummy
> > get_unmapped_area() for the v4l devices which will set some default
> > capabilities. After that, determine_vm_flags() should take care of
> > setting up the proper VMA flags without hacking every driver's mmap()
> > routine. This sort of thing has absolutely no place in the driver,
> > though.
>
> Hi Laurent,
>
> Does this patch make sense? I hope you understand the tricky things in
> nommu mapping world.

I agree with Paul, the problem lies in vm_insert_page() and a fix is needed 
there.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
