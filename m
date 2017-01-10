Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45359 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754580AbdAJOl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 09:41:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vincent ABRIOU <vincent.abriou@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Date: Tue, 10 Jan 2017 16:41:39 +0200
Message-ID: <2642368.koo1zFQjyt@avalon>
In-Reply-To: <93a7f73c-0c0f-64cb-5918-e86add84b006@st.com>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com> <3193570.QBsjjzBjh2@avalon> <93a7f73c-0c0f-64cb-5918-e86add84b006@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 Jan 2017 08:55:16 Vincent ABRIOU wrote:
> On 01/09/2017 05:59 PM, Laurent Pinchart wrote:
> > On Monday 09 Jan 2017 15:49:00 Vincent ABRIOU wrote:
> >> On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
> >>> Hi Vincent,
> >>> 
> >>> Thank you for the patch.
> >>> 
> >>> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
> >>>> Allow uvcvideo compatible devices to allocate their output buffers
> >>>> using contiguous DMA buffers.
> >>> 
> >>> Why do you need this ? If it's for buffer sharing with a device that
> >>> requires dma-contig, can't you allocate the buffers on the other device
> >>> and import them on the UVC side ?
> >> 
> >> Hi Laurent,
> >> 
> >> I need this using Gstreamer simple pipeline to connect an usb webcam
> >> (v4l2src) with a display (waylandsink) activating the zero copy path.
> >> 
> >> The waylandsink plugin does not have any contiguous memory pool to
> >> allocate contiguous buffer. So it is up to the upstream element, here
> >> v4l2src, to provide such contiguous buffers.
> > 
> > Isn't that a gstreamer issue ?
> 
> It is not a gstreamer issue. It is the way it has been decided to work.
> Waylandsink accept DMABUF contiguous buffer but it does not have its own
> buffer pool.

But why do you put the blame on the kernel when you decide to take the wrong 
decision in userspace ? :-)

> >>>> Add the "allocators" module parameter option to let uvcvideo use the
> >>>> dma-contig instead of vmalloc.
> >>>> 
> >>>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
> >>>> ---
> >>>> 
> >>>>  Documentation/media/v4l-drivers/uvcvideo.rst | 12 ++++++++++++
> >>>>  drivers/media/usb/uvc/Kconfig                |  2 ++
> >>>>  drivers/media/usb/uvc/uvc_driver.c           |  3 ++-
> >>>>  drivers/media/usb/uvc/uvc_queue.c            | 23 ++++++++++++++++---
> >>>>  drivers/media/usb/uvc/uvcvideo.h             |  4 ++--
> >>>>  5 files changed, 38 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

