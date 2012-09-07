Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:44952 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab2IGKLQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Sep 2012 06:11:16 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Scott Jiang <Scott.Jiang.Linux@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Armando VISCONTI <armando.visconti@st.com>,
	Shiraz HASHIM <shiraz.hashim@st.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Date: Fri, 7 Sep 2012 18:10:47 +0800
Subject: Using MMAP calls on a video capture device having underlying NOMMU
 arch
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FB084B206@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been trying recently to make a usb-based-webcam device to work with
Linux. The entire scheme is a bit complex:

UVC gadget <--User Pointer--> User-Space Daemon <-- MMAP --> V4L2 capture device.

The UVC gadget is internally a v4l2 based device supporting VB2_VMALLOC operations,
whereas the V4L2 capture device supports VB2_DMA_CONTIG operations.

The application (user-space daemon), is responsible for getting memory allocated
from the V4L2 capture device via REQBUF calls. The V4L2 capture side exposes a
MMAP IO method, whereas the UVC gadget can get a USERPTR to the buffer filled with
video data from the V4L2 capture device and then send the same on a USB bus.

This scheme works absolutely fine on an architecture having a MMU, but when I try
the same on a NOMMU arch, I see MMAP calls from the user-space daemon failing.

I have implemented a .get_unmapped_area callback in my V4L2 capture driver using
the blackfin video capture driver as a reference (see [1]).

I make a MMAP call from the user-space application in a sequence like this
(pretty similar to the standard capture.c example, see[2]):

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
call (see [3] for reference). But the MMAP call fails in 'vb2_dma_contig_alloc' function
in mm/nommu.c (see [4] for reference) when it tries to make the following check:
	
	if (addr != (pfn << PAGE_SHIFT))
		return -EINVAL;

I address Scott also, as I see that he has worked on the Blackfin v4l2 capture driver using
DMA contiguous method and may have seen this issue (on a NOMMU system) with a v4l2 application
performing a MMAP operation.

Any comments on what I could be doing wrong here?

References:

[1] Blackfin capture driver, http://lxr.linux.no/linux+v3.5.3/drivers/media/video/blackfin/bfin_capture.c#L243
[2] capture.c, http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html
[3] vb2_dma_contig_alloc, http://lxr.linux.no/linux+v3.5.3/drivers/media/video/videobuf2-dma-contig.c#L37
[4] remap_pfn_range, http://lxr.linux.no/linux+v3.5.3/mm/nommu.c#L1819

Regards,
Bhupesh
