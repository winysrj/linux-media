Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40918 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751355AbdAYLqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 06:46:10 -0500
Date: Wed, 25 Jan 2017 13:46:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Vincent ABRIOU <vincent.abriou@st.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Message-ID: <20170125114605.GC7139@valkosipuli.retiisi.org.uk>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com>
 <5308977.1AOWxa0Moe@avalon>
 <c86650e5-7106-d36b-b716-6247fb2fa8ed@st.com>
 <20170111110350.GE10831@valkosipuli.retiisi.org.uk>
 <45eec54c-059e-86c1-bedb-78a6400328a4@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45eec54c-059e-86c1-bedb-78a6400328a4@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

On Wed, Jan 11, 2017 at 12:36:24PM +0000, Vincent ABRIOU wrote:
> Hi Sakari,
> 
> On 01/11/2017 12:03 PM, Sakari Ailus wrote:
> > Hi Vincent,
> >
> > On Mon, Jan 09, 2017 at 03:49:00PM +0000, Vincent ABRIOU wrote:
> >>
> >>
> >> On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
> >>> Hi Vincent,
> >>>
> >>> Thank you for the patch.
> >>>
> >>> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
> >>>> Allow uvcvideo compatible devices to allocate their output buffers using
> >>>> contiguous DMA buffers.
> >>>
> >>> Why do you need this ? If it's for buffer sharing with a device that requires
> >>> dma-contig, can't you allocate the buffers on the other device and import them
> >>> on the UVC side ?
> >>>
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
> > Do you need (physically) contiguous memory?
> >
> 
> Yes, drm driver that does not have mmu needs to have contiguous buffers.

One option would be to have that driver to allocate the memory. I admit it's
not a great solution as you need special arrangements because you allocate
memory where the hardware has strictest memory allocation requirements.

> 
> > The DMA-BUF API does help sharing the buffers but it, at least currently,
> > does not help allocating memory or specifying a common format so that all
> > the devices the buffer needs to be accessible can actually make use of it.
> >
> > Instead of hacking drivers to make use of different memory allocation
> > strategies required by unrelated devices, we should instead fix these
> > problems in a proper, scalable way.
> >
> 
> Scalable way? Like central allocator?

Yeah. You seem to be working on this already. :-)

Some devices have the weirdest memory requirements, but most (those with
MMU) can manage with any pages in the system memory. Either physically or
virtually (i.e. a buffer consisting of any page in system memory) contiguous
memory can be supported by the vast majority of devices.

It'd be nice, API-wise, to be able to tell in the user space which device
the buffer is used with and only then perform the actual allocation. An
alternative would be to re-allocate if a device's memory requirements do not
match with a buffer what the user is passing to to a device, but this may be
problematic from performance point of view (as you need to reallocate).

An allocator or a couple will be needed, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
