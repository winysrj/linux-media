Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:51392 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2INKjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:39:42 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <lliubbo@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"geert@linux-m68k.org" <geert@linux-m68k.org>,
	"gerg@uclinux.org" <gerg@uclinux.org>,
	"stable@kernel.org" <stable@kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Hugh Dickins <hughd@google.com>
Date: Fri, 14 Sep 2012 18:39:13 +0800
Subject: RE: [PATCH] nommu: remap_pfn_range: fix addr parameter check
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FB1E69774@EAPEX1MAIL1.st.com>
References: <1347504057-5612-1-git-send-email-lliubbo@gmail.com>
	<20120913122738.04eaceb3.akpm@linux-foundation.org>
 <CAHG8p1CJ7YizySrocYvQeCye4_63TkAimsAGU1KC5+Fn0wqF8w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Bhupesh SHARMA
> Sent: Friday, September 14, 2012 3:45 PM
> To: 'Scott Jiang'; Andrew Morton
> Cc: Bob Liu; linux-mm@kvack.org; laurent.pinchart@ideasonboard.com;
> uclinux-dist-devel@blackfin.uclinux.org; linux-media@vger.kernel.org;
> dhowells@redhat.com; geert@linux-m68k.org; gerg@uclinux.org;
> stable@kernel.org; gregkh@linuxfoundation.org; Hugh Dickins
> Subject: RE: [PATCH] nommu: remap_pfn_range: fix addr parameter check
> 
> > -----Original Message-----
> > From: Scott Jiang [mailto:scott.jiang.linux@gmail.com]
> > Sent: Friday, September 14, 2012 2:53 PM
> > To: Andrew Morton
> > Cc: Bob Liu; linux-mm@kvack.org; Bhupesh SHARMA;
> > laurent.pinchart@ideasonboard.com; uclinux-dist-
> > devel@blackfin.uclinux.org; linux-media@vger.kernel.org;
> > dhowells@redhat.com; geert@linux-m68k.org; gerg@uclinux.org;
> > stable@kernel.org; gregkh@linuxfoundation.org; Hugh Dickins
> > Subject: Re: [PATCH] nommu: remap_pfn_range: fix addr parameter check
> >
> > > Yes, the MMU version of remap_pfn_range() does permit non-page-
> > aligned
> > > `addr' (at least, if the userspace maaping is a non-COW one).  But I
> > > suspect that was an implementation accident - it is a nonsensical
> > > thing to do, isn't it?  The MMU cannot map a bunch of kernel pages
> > > onto a non-page-aligned userspace address.
> > >
> > > So I'm thinking that we should declare ((addr & ~PAGE_MASK) != 0) to
> > > be a caller bug, and fix up this regrettably unidentified v4l driver?
> >
> > I agree. This should be fixed in videobuf.
> >
> > Hi sharma, what's your kernel version? It seems videobuf2 already
> > fixed this bug in 3.5.
> 

[snip..]

> 
> I was using 3.3 linux kernel. I will again check if videobuf2 in 3.5 has already
> fixed this issue.

[snip..]

Ok I just checked the vb2_dma_contig allocator and it has no major changes from my version,
http://lxr.linux.no/linux+v3.5.3/drivers/media/video/videobuf2-dma-contig.c#L37

So, I am not sure if this issue has been fixed in the videobuf2 (or if any patch is in the pipeline
which fixes the issue).

BTW I paste my original mail on the subject below to help everyone understand the complete setup
and the issue I faced.

Regards,
Bhupesh

---------------------
Hi,

I have been trying recently to make a usb-based-webcam device to work with Linux. The entire scheme is a bit complex:

UVC gadget <--User Pointer--> User-Space Daemon <-- MMAP --> V4L2 capture device.

The UVC gadget is internally a v4l2 based device supporting VB2_VMALLOC operations, whereas the V4L2 capture device supports VB2_DMA_CONTIG operations.

The application (user-space daemon), is responsible for getting memory allocated from the V4L2 capture device via REQBUF calls. The V4L2 capture side exposes a
 MMAP IO method, whereas the UVC gadget can get a USERPTR to the buffer filled with video data from the V4L2 capture device and then send the same on a USB bus.

This scheme works absolutely fine on an architecture having a MMU, but when I try the same on a NOMMU arch, I see MMAP calls from the user-space daemon failing.

I have implemented a .get_unmapped_area callback in my V4L2 capture driver using the blackfin video capture driver as a reference (see [1]).

I make a MMAP call from the user-space application in a sequence like this (pretty similar to the standard capture.c example, see[2]):

static void init_mmap (void)
{
	struct v4l2_requestbuffers req;

	CLEAR (req);

	req.count               = 4;
	req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	req.memory              = V4L2_MEMORY_MMAP;

	if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) 
	{
		if (EINVAL == errno) 
		{
			fprintf (stderr, "%s does not support memory mapping\n", dev_name);
			exit (EXIT_FAILURE);
		} 
		else 
		{
			errno_exit ("VIDIOC_REQBUFS");
		}
	}

	if (req.count < 2) 
	{
		fprintf (stderr, "Insufficient buffer memory on %s\n",dev_name);
		exit (EXIT_FAILURE);
	}

	buffers = (buffer*) calloc (req.count, sizeof (*buffers));

	if (!buffers) 
	{
		fprintf (stderr, "Out of memory\n");
		exit (EXIT_FAILURE);
	}

	for (n_buffers = 0; n_buffers < req.count; ++n_buffers) 
	{
		struct v4l2_buffer buf;

		CLEAR (buf);

		buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory      = V4L2_MEMORY_MMAP;
		buf.index       = n_buffers;

		if (-1 == xioctl (fd, VIDIOC_QUERYBUF, &buf))
			errno_exit ("VIDIOC_QUERYBUF");

		buffers[n_buffers].length = buf.length;
		buffers[n_buffers].start =
				mmap (NULL /* start anywhere */,
					buf.length,
					PROT_READ | PROT_WRITE /* required */,
					MAP_SHARED /* recommended */,
					fd, buf.m.offset);

		if (MAP_FAILED == buffers[n_buffers].start)
			errno_exit ("mmap");
	}
}

Now, I see that the requested videobuffers are correctly allocated via 'vb2_dma_contig_alloc'
call (see [3] for reference). But the MMAP call fails in 'vb2_dma_contig_alloc' function in mm/nommu.c (see [4] for reference) when it tries to make the following check:
	
	if (addr != (pfn << PAGE_SHIFT))
		return -EINVAL;

I address Scott also, as I see that he has worked on the Blackfin v4l2 capture driver using DMA contiguous method and may have seen this issue (on a NOMMU system)
with a v4l2 application performing a MMAP operation.

Any comments on what I could be doing wrong here?

References:

[1] Blackfin capture driver, http://lxr.linux.no/linux+v3.5.3/drivers/media/video/blackfin/bfin_capture.c#L243
[2] capture.c, http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html
[3] vb2_dma_contig_alloc, http://lxr.linux.no/linux+v3.5.3/drivers/media/video/videobuf2-dma-contig.c#L37
[4] remap_pfn_range, http://lxr.linux.no/linux+v3.5.3/mm/nommu.c#L1819
