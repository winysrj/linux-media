Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35825 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbdBBTMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 14:12:45 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170202172245.GT27312@n2100.armlinux.org.uk>
 <20170202175600.GU27312@n2100.armlinux.org.uk>
 <4815b9c8-782a-ac67-d296-c4acb296d849@gmail.com>
 <20170202185826.GV27312@n2100.armlinux.org.uk>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <2e1cf096-ecb8-ba3d-a554-f4cc6999ed4e@gmail.com>
Date: Thu, 2 Feb 2017 11:12:41 -0800
MIME-Version: 1.0
In-Reply-To: <20170202185826.GV27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/02/2017 10:58 AM, Russell King - ARM Linux wrote:
> On Thu, Feb 02, 2017 at 10:26:55AM -0800, Steve Longerbeam wrote:
>> On 02/02/2017 09:56 AM, Russell King - ARM Linux wrote:
>>> and for whatever reason we end up falling out through free_ring.  This
>>> is VERY bad news, because it means that the ring which SMFC took a copy
>>> of is now freed beneath its feet.
>> Yes, that is bad. That was a bug, if imx_media_dma_buf_queue_from_vb()
>> returned error, the ring should not have been freed, it should have only
>> returned the error. And further bad stuff happens from that point on.
>>
>> But all of this is gone in version 4.
> I think there's an error in how you think the queue_setup() works.
>
> camif_queue_setup() always returns the number of buffers between
> IMX_MEDIA_MIN_RING_BUFS and IMX_MEDIA_MAX_RING_BUFS.  However, it seems
> that, looking through the videobuf2-core.c code, that the value is
> passed to __vb2_queue_alloc() to allocate the specified number of
> _additional_ buffers over and on-top of the existing q->num_buffers:
>
> static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>                               unsigned int num_buffers, unsigned int num_planes,
>                               const unsigned plane_sizes[VB2_MAX_PLANES])
> {
>          for (buffer = 0; buffer < num_buffers; ++buffer) {
> ...
>                  vb->index = q->num_buffers + buffer;
>
> and
>
> int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>                  unsigned int *count)
> {
>          unsigned int num_buffers, allocated_buffers, num_planes = 0;
> ...
>          num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
>          num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
> ...
>          /*
>           * Ask the driver how many buffers and planes per buffer it requires.
>           * Driver also sets the size and allocator context for each plane.
>           */
>          ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
>                         plane_sizes, q->alloc_devs);
>          if (ret)
>                  return ret;
>
>          /* Finally, allocate buffers and video memory */
>          allocated_buffers =
>                  __vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
>
> or:
>
> int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>                  unsigned int *count, unsigned requested_planes,
>                  const unsigned requested_sizes[])
> {
>          unsigned int num_planes = 0, num_buffers, allocated_buffers;
> ...
>          num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
>          if (requested_planes && requested_sizes) {
>                  num_planes = requested_planes;
> ...
>          /*
>           * Ask the driver, whether the requested number of buffers, planes per
>           * buffer and their sizes are acceptable
>           */
>          ret = call_qop(q, queue_setup, q, &num_buffers,
>                         &num_planes, plane_sizes, q->alloc_devs);
>          if (ret)
>                  return ret;
>
>          /* Finally, allocate buffers and video memory */
>          allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
>                                  num_planes, plane_sizes);
>
>
> It seems to me that if you don't take account of the existing queue
> size, your camif_queue_setup() has the side effect that each time
> either of these are called.  Hence, the vb2 queue increases by the
> same amount each time, which is probably what you don't want.
>
> The documentation on queue_setup() leaves much to be desired:
>
>   * @queue_setup:        called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
>   *                      handlers before memory allocation. It can be called
>   *                      twice: if the original number of requested buffers
>   *                      could not be allocated, then it will be called a
>   *                      second time with the actually allocated number of
>   *                      buffers to verify if that is OK.
>   *                      The driver should return the required number of buffers
>   *                      in \*num_buffers, the required number of planes per
>   *                      buffer in \*num_planes, the size of each plane should be
>   *                      set in the sizes\[\] array and optional per-plane
>   *                      allocator specific device in the alloc_devs\[\] array.
>   *                      When called from VIDIOC_REQBUFS,() \*num_planes == 0,
>   *                      the driver has to use the currently configured format to
>   *                      determine the plane sizes and \*num_buffers is the total
>   *                      number of buffers that are being allocated. When called
>   *                      from VIDIOC_CREATE_BUFS,() \*num_planes != 0 and it
>   *                      describes the requested number of planes and sizes\[\]
>   *                      contains the requested plane sizes. If either
>   *                      \*num_planes or the requested sizes are invalid callback
>   *                      must return %-EINVAL. In this case \*num_buffers are
>   *                      being allocated additionally to q->num_buffers.
>
> That's really really ambiguous, because the "In this case" part doesn't
> really tell you which case it's talking about - but it seems to me looking
> at the code that it's referring to the VIDIOC_CREATE_BUFS case.

Yes, I caught this when adding fixes from v4l2-compliance testing, which
is not part of the version 3 driver. I agree it is a confusing API. When
called from VIDIOC_CREATE_BUFS (indicated by *num_planes != 0),
*num_buffers is supposed to be requested buffers _in addition_ to
already requested q->num_buffers, which is important info and
should be emphasized a little more than the "oh by the way" fashion
in the prototype description, IMHO.

>
> As you support both .vidioc_create_bufs and .vidioc_reqbufs, it seems
> to me that you're not handling the VIDIOC_CREATE_BUFS case correctly.
>
> Can you please make sure that your next version resolves that?

Here is the current .queue_setup() op in imx-media-capture.c:

static int capture_queue_setup(struct vb2_queue *vq,
                                unsigned int *nbuffers,
                                unsigned int *nplanes,
                                unsigned int sizes[],
                                struct device *alloc_devs[])
{
         struct capture_priv *priv = vb2_get_drv_priv(vq);
         struct v4l2_pix_format *pix = &priv->vdev.fmt.fmt.pix;
         unsigned int count = *nbuffers;

         if (vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
                 return -EINVAL;

         if (*nplanes) {
                 if (*nplanes != 1 || sizes[0] < pix->sizeimage)
                         return -EINVAL;
                 count += vq->num_buffers;
         }

         while (pix->sizeimage * count > VID_MEM_LIMIT)
                 count--;

         if (*nplanes)
                 *nbuffers = (count < vq->num_buffers) ? 0 :
                         count - vq->num_buffers;
         else
                 *nbuffers = count;

         *nplanes = 1;
         sizes[0] = pix->sizeimage;

         return 0;
}

>

