Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762AbaDNVT4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 17:19:56 -0400
Date: Mon, 14 Apr 2014 23:19:51 +0200
From: Jan Kara <jack@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-mm@kvack.org, linux-media@vger.kernel.org,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	'Tomasz Stanislawski' <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Helper to abstract vma handling in media layer
Message-ID: <20140414211951.GE13860@quack.suse.cz>
References: <1395085776-8626-1-git-send-email-jack@suse.cz>
 <53466C4A.2030107@samsung.com>
 <20140410103220.GB28404@quack.suse.cz>
 <53467B7E.5060408@xs4all.nl>
 <20140410121554.GC28404@quack.suse.cz>
 <53468CFC.2060707@xs4all.nl>
 <20140410215738.GB12339@quack.suse.cz>
 <20140410221818.GA14625@quack.suse.cz>
 <534792B3.1060709@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534792B3.1060709@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 11-04-14 08:58:59, Hans Verkuil wrote:
> On 04/11/2014 12:18 AM, Jan Kara wrote:
> > On Thu 10-04-14 23:57:38, Jan Kara wrote:
> >> On Thu 10-04-14 14:22:20, Hans Verkuil wrote:
> >>> On 04/10/14 14:15, Jan Kara wrote:
> >>>> On Thu 10-04-14 13:07:42, Hans Verkuil wrote:
> >>>>> On 04/10/14 12:32, Jan Kara wrote:
> >>>>>>   Hello,
> >>>>>>
> >>>>>> On Thu 10-04-14 12:02:50, Marek Szyprowski wrote:
> >>>>>>> On 2014-03-17 20:49, Jan Kara wrote:
> >>>>>>>>   The following patch series is my first stab at abstracting vma handling
> >>>>>>> >from the various media drivers. After this patch set drivers have to know
> >>>>>>>> much less details about vmas, their types, and locking. My motivation for
> >>>>>>>> the series is that I want to change get_user_pages() locking and I want
> >>>>>>>> to handle subtle locking details in as few places as possible.
> >>>>>>>>
> >>>>>>>> The core of the series is the new helper get_vaddr_pfns() which is given a
> >>>>>>>> virtual address and it fills in PFNs into provided array. If PFNs correspond to
> >>>>>>>> normal pages it also grabs references to these pages. The difference from
> >>>>>>>> get_user_pages() is that this function can also deal with pfnmap, mixed, and io
> >>>>>>>> mappings which is what the media drivers need.
> >>>>>>>>
> >>>>>>>> The patches are just compile tested (since I don't have any of the hardware
> >>>>>>>> I'm afraid I won't be able to do any more testing anyway) so please handle
> >>>>>>>> with care. I'm grateful for any comments.
> >>>>>>>
> >>>>>>> Thanks for posting this series! I will check if it works with our
> >>>>>>> hardware soon.  This is something I wanted to introduce some time ago to
> >>>>>>> simplify buffer handling in dma-buf, but I had no time to start working.
> >>>>>>   Thanks for having a look in the series.
> >>>>>>
> >>>>>>> However I would like to go even further with integration of your pfn
> >>>>>>> vector idea.  This structure looks like a best solution for a compact
> >>>>>>> representation of the memory buffer, which should be considered by the
> >>>>>>> hardware as contiguous (either contiguous in physical memory or mapped
> >>>>>>> contiguously into dma address space by the respective iommu). As you
> >>>>>>> already noticed it is widely used by graphics and video drivers.
> >>>>>>>
> >>>>>>> I would also like to add support for pfn vector directly to the
> >>>>>>> dma-mapping subsystem. This can be done quite easily (even with a
> >>>>>>> fallback for architectures which don't provide method for it). I will try
> >>>>>>> to prepare rfc soon.  This will finally remove the need for hacks in
> >>>>>>> media/v4l2-core/videobuf2-dma-contig.c
> >>>>>>   That would be a worthwhile thing to do. When I was reading the code this
> >>>>>> seemed like something which could be done but I delibrately avoided doing
> >>>>>> more unification than necessary for my purposes as I don't have any
> >>>>>> hardware to test and don't know all the subtleties in the code... BTW, is
> >>>>>> there some way to test the drivers without the physical video HW?
> >>>>>
> >>>>> You can use the vivi driver (drivers/media/platform/vivi) for this.
> >>>>> However, while the vivi driver can import dma buffers it cannot export
> >>>>> them. If you want that, then you have to use this tree:
> >>>>>
> >>>>> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vb2-part4
> >>>>   Thanks for the pointer that looks good. I've also found
> >>>> drivers/media/platform/mem2mem_testdev.c which seems to do even more
> >>>> testing of the area I made changes to. So now I have to find some userspace
> >>>> tool which can issue proper ioctls to setup and use the buffers and I can
> >>>> start testing what I wrote :)
> >>>
> >>> Get the v4l-utils.git repository (http://git.linuxtv.org/cgit.cgi/v4l-utils.git/).
> >>> You want the v4l2-ctl tool. Don't use the version supplied by your distro,
> >>> that's often too old.
> >>>
> >>> 'v4l2-ctl --help-streaming' gives the available options for doing streaming.
> >>>
> >>> So simple capturing from vivi is 'v4l2-ctl --stream-mmap' or '--stream-user'.
> >>> You can't test dmabuf unless you switch to the vb2-part4 branch of my tree.
> >>   Great, it seems to be doing something and it shows there's some bug in my
> >> code. Thanks a lot for help.
> >   OK, so after a small fix the basic functionality seems to be working. It
> > doesn't seem there's a way to test multiplanar buffers with vivi, is there?
> 
> For that you need to switch to the vb2-part4 branch as well. That has support
> for multiplanar.
  OK, I've merged that branch to my kernel but I failed to find the setting
for vivi that would create multiplanar buffers and in fact I don't see
multiplanar capabilities among the capabilities reported by the v4l2-ctl
tool. Can you help me please?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
