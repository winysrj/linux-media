Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40076 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdBBS7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 13:59:22 -0500
Date: Thu, 2 Feb 2017 18:58:26 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
Message-ID: <20170202185826.GV27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170202172245.GT27312@n2100.armlinux.org.uk>
 <20170202175600.GU27312@n2100.armlinux.org.uk>
 <4815b9c8-782a-ac67-d296-c4acb296d849@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815b9c8-782a-ac67-d296-c4acb296d849@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 02, 2017 at 10:26:55AM -0800, Steve Longerbeam wrote:
> On 02/02/2017 09:56 AM, Russell King - ARM Linux wrote:
> >and for whatever reason we end up falling out through free_ring.  This
> >is VERY bad news, because it means that the ring which SMFC took a copy
> >of is now freed beneath its feet.
> 
> Yes, that is bad. That was a bug, if imx_media_dma_buf_queue_from_vb()
> returned error, the ring should not have been freed, it should have only
> returned the error. And further bad stuff happens from that point on.
> 
> But all of this is gone in version 4.

I think there's an error in how you think the queue_setup() works.

camif_queue_setup() always returns the number of buffers between
IMX_MEDIA_MIN_RING_BUFS and IMX_MEDIA_MAX_RING_BUFS.  However, it seems
that, looking through the videobuf2-core.c code, that the value is
passed to __vb2_queue_alloc() to allocate the specified number of
_additional_ buffers over and on-top of the existing q->num_buffers:

static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
                             unsigned int num_buffers, unsigned int num_planes,
                             const unsigned plane_sizes[VB2_MAX_PLANES])
{
        for (buffer = 0; buffer < num_buffers; ++buffer) {
...
                vb->index = q->num_buffers + buffer;

and

int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
                unsigned int *count)
{
        unsigned int num_buffers, allocated_buffers, num_planes = 0;
...
        num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
        num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
...
        /*
         * Ask the driver how many buffers and planes per buffer it requires.
         * Driver also sets the size and allocator context for each plane.
         */
        ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
                       plane_sizes, q->alloc_devs);
        if (ret)
                return ret;

        /* Finally, allocate buffers and video memory */
        allocated_buffers =
                __vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);

or:

int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
                unsigned int *count, unsigned requested_planes,
                const unsigned requested_sizes[])
{
        unsigned int num_planes = 0, num_buffers, allocated_buffers;
...
        num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
        if (requested_planes && requested_sizes) {
                num_planes = requested_planes;
...
        /*
         * Ask the driver, whether the requested number of buffers, planes per
         * buffer and their sizes are acceptable
         */
        ret = call_qop(q, queue_setup, q, &num_buffers,
                       &num_planes, plane_sizes, q->alloc_devs);
        if (ret)
                return ret;

        /* Finally, allocate buffers and video memory */
        allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
                                num_planes, plane_sizes);


It seems to me that if you don't take account of the existing queue
size, your camif_queue_setup() has the side effect that each time
either of these are called.  Hence, the vb2 queue increases by the
same amount each time, which is probably what you don't want.

The documentation on queue_setup() leaves much to be desired:

 * @queue_setup:        called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
 *                      handlers before memory allocation. It can be called
 *                      twice: if the original number of requested buffers
 *                      could not be allocated, then it will be called a
 *                      second time with the actually allocated number of
 *                      buffers to verify if that is OK.
 *                      The driver should return the required number of buffers
 *                      in \*num_buffers, the required number of planes per
 *                      buffer in \*num_planes, the size of each plane should be
 *                      set in the sizes\[\] array and optional per-plane
 *                      allocator specific device in the alloc_devs\[\] array.
 *                      When called from VIDIOC_REQBUFS,() \*num_planes == 0,
 *                      the driver has to use the currently configured format to
 *                      determine the plane sizes and \*num_buffers is the total
 *                      number of buffers that are being allocated. When called
 *                      from VIDIOC_CREATE_BUFS,() \*num_planes != 0 and it
 *                      describes the requested number of planes and sizes\[\]
 *                      contains the requested plane sizes. If either
 *                      \*num_planes or the requested sizes are invalid callback
 *                      must return %-EINVAL. In this case \*num_buffers are
 *                      being allocated additionally to q->num_buffers.

That's really really ambiguous, because the "In this case" part doesn't
really tell you which case it's talking about - but it seems to me looking
at the code that it's referring to the VIDIOC_CREATE_BUFS case.

As you support both .vidioc_create_bufs and .vidioc_reqbufs, it seems
to me that you're not handling the VIDIOC_CREATE_BUFS case correctly.

Can you please make sure that your next version resolves that?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
