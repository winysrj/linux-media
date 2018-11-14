Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34795 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbeKOArO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 19:47:14 -0500
Message-ID: <1542206620.4095.10.camel@pengutronix.de>
Subject: Re: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Date: Wed, 14 Nov 2018 15:43:40 +0100
In-Reply-To: <eac4ab89-fde0-d28c-9f56-6b6ad5f9e95a@xs4all.nl>
References: <20181113150621.22276-1-p.zabel@pengutronix.de>
         <eac4ab89-fde0-d28c-9f56-6b6ad5f9e95a@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 2018-11-13 at 16:43 +0100, Hans Verkuil wrote:
> Hi Philipp,
> 
> On 11/13/18 16:06, Philipp Zabel wrote:
> > From: John Sheu <sheu@chromium.org>
> > 
> > Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
> > buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
> > considered "in use".  This is different behavior than for other memory
> > types and prevents us from deallocating buffers in following two cases:
> > 
> > 1) There are outstanding mmap()ed views on the buffer. However even if
> >    we put the buffer in reqbufs(0), there will be remaining references,
> >    due to vma .open/close() adjusting vb2 buffer refcount appropriately.
> >    This means that the buffer will be in fact freed only when the last
> >    mmap()ed view is unmapped.
> > 
> > 2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
> >    is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
> >    get and decremented on DMABUF release. This means that the buffer
> >    will be alive until all importers release it.
> > 
> > Considering both cases above, there does not seem to be any need to
> > prevent reqbufs(0) operation, because buffer lifetime is already
> > properly managed by both mmap() and DMABUF code paths. Let's remove it
> > and allow userspace freeing the queue (and potentially allocating a new
> > one) even though old buffers might be still in processing.
> > 
> > To let userspace know that the kernel now supports orphaning buffers
> > that are still in use, add a new V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
> > to be set by reqbufs and create_bufs.
> 
> Looks good, but I have some questions:
> 
> 1) does v4l2-compliance together with vivid (easiest to test) still work?
>    I don't think I have a proper test for this in v4l2-compliance, but
>    I'm not 100% certain. If it fails with this patch, then please provide
>    a fix for v4l2-compliance as well.

I have tested on v4.20-rc2 with 92539d3eda2c ("media: v4l: event: Add
subscription to list before calling "add" operation") and this patch
applied:

$ modprobe vivid no_error_inj=1
vivid-000: V4L2 capture device registered as video15
vivid-000: V4L2 output device registered as video16

$ v4l2-compliance -d 15 -s 1 --expbuf-device 16
v4l2-compliance SHA: 98b4c9f276a18535b5691e5f350f59ffbf5a9aa5, 32 bits
...
Total: 112, Succeeded: 112, Failed: 0, Warnings: 4

The warnings are:
		warn: v4l2-test-formats.cpp(1426): doioctl(node, VIDIOC_CROPCAP, &cap)
	test Cropping: OK
(one per input) and:
		warn: v4l2-test-controls.cpp(845): V4L2_CID_DV_RX_POWER_PRESENT not found for input 3
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK

> 2) I would like to see a new test in v4l2-compliance for this: i.e. if
>    the capability is set, then check that you can call REQBUFS(0) before
>    unmapping all buffers. Ditto with dmabuffers.
>
> I said during the media summit that I wanted to be more strict about
> requiring compliance tests before adding new features, so you're the
> unlucky victim of that :-)

That's fair. The SHA above is actually a lie, I had one patch applied.

regards
Philipp
