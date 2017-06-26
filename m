Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751411AbdFZOva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 10:51:30 -0400
Date: Mon, 26 Jun 2017 17:51:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170626145105.GN12407@valkosipuli.retiisi.org.uk>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

A few more comments, better late than never I guess.

On Mon, Jun 12, 2017 at 06:59:18PM +0900, Tomasz Figa wrote:
...
> > +/*
> > + * The CSI2 receiver has several parameters affecting
> > + * the receiver timings. These depend on the MIPI bus frequency
> > + * F in Hz (sensor transmitter rate) as follows:
> > + *     register value = (A/1e9 + B * UI) / COUNT_ACC
> > + * where
> > + *      UI = 1 / (2 * F) in seconds
> > + *      COUNT_ACC = counter accuracy in seconds
> > + *      For IPU3 COUNT_ACC = 0.0625
> > + *
> > + * A and B are coefficients from the table below,
> > + * depending whether the register minimum or maximum value is
> > + * calculated.
> > + *                                     Minimum     Maximum
> > + * Clock lane                          A     B     A     B
> > + * reg_rx_csi_dly_cnt_termen_clane     0     0    38     0
> > + * reg_rx_csi_dly_cnt_settle_clane    95    -8   300   -16
> > + * Data lanes
> > + * reg_rx_csi_dly_cnt_termen_dlane0    0     0    35
> > + * reg_rx_csi_dly_cnt_settle_dlane0   85    -2   145    -6
> > + * reg_rx_csi_dly_cnt_termen_dlane1    0     0    35     4
> > + * reg_rx_csi_dly_cnt_settle_dlane1   85    -2   145    -6
> > + * reg_rx_csi_dly_cnt_termen_dlane2    0     0    35     4
> > + * reg_rx_csi_dly_cnt_settle_dlane2   85    -2   145    -6
> > + * reg_rx_csi_dly_cnt_termen_dlane3    0     0    35     4
> > + * reg_rx_csi_dly_cnt_settle_dlane3   85    -2   145    -6
> > + *
> > + * We use the minimum values of both A and B.
> 
> Why?
> 
> > + */
> > +static int cio2_rx_timing(s32 a, s32 b, s64 freq)
> > +{
> > +       int r;
> > +       const u32 accinv = 16;
> > +       const u32 ds = 8; /* divde shift */
> 
> typo: divide
> 
> > +
> > +       freq = (s32)freq >> ds;
> 
> Why do we demote freq from 64 to 32 bits here?

I don't think there's any reason to. The original purpose of the check has
likely been to avoid dividing by a 64-bit number but that has been lost
here. The cast should be elsewhere...

> 
> > +       if (WARN_ON(freq <= 0))
> > +               return -EINVAL;
> 
> It generally doesn't make sense for the frequency to be negative, so
> maybe the argument should have been unsigned to start with? (And
> 32-bit if we don't expect frequencies higher than 4 GHz anyway.)

The value comes from a 64-bit integer V4L2 control so that implies the value
range of s64 as well.

> 
> > +
> > +       /* b could be 0, -2 or -8, so r < 500000000 */
> 
> Definitely. Anything <= 0 is also less than 500000000. Let's take a
> look at the computation below again:
> 
> 1) accinv is multiplied by b,
> 2) 500000000 is divided by 256 (=== shift right by 8 bits) = 1953125,
> 3) accinv*b is multiplied by 1953125 to form the value of r.
> 
> Now let's see at possible maximum absolute values for particular steps:
> 1) 16 * -8 = -128 (signed 8 bits),
> 2) 1953125 (unsigned 21 bits),
> 3) -128 * 1953125 = -249999872 (signed 29 bits).
> 
> So I think the important thing to note in the comment is:
> 
> /* b could be 0, -2 or -8, so |accinv * b| is always less than (1 <<
> ds) and thus |r| < 500000000. */
> 
> > +       r = accinv * b * (500000000 >> ds);
> 
> On the other hand, you lose some precision here. If you used s64
> instead and did the divide shift at the end ((accinv * b * 500000000)
> >> ds), for the example above you would get -250007629. (Depending on
> how big freq is, it might not matter, though.)
> 

The frequency is typically hundreds of mega-Hertz.

> Also nit: What is 500000000? We have local constants defined above, I
> think it could also make sense to do the same for this one. The
> compiler should do constant propagation and simplify respective
> calculations anyway.

COUNT_ACC in the formula in the comment a few decalines above is in
nanoseconds. Performing the calculations in integer arithmetics results in
having 500000000 in the resulting formula.

So this is actually a constant related to the hardware but it does not have
a pre-determined name because it is derived from COUNT_ACC.

...

> > +static int cio2_vb2_queue_setup(struct vb2_queue *vq,
> > +                               unsigned int *num_buffers,
> > +                               unsigned int *num_planes,
> > +                               unsigned int sizes[],
> > +                               struct device *alloc_devs[])
> > +{
> > +       struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> > +       struct cio2_queue *q = container_of(vq, struct cio2_queue, vbq);
> > +       u32 width = q->subdev_fmt.width;
> > +       u32 height = q->subdev_fmt.height;
> > +       u32 pixelformat = q->pixelformat;
> > +       unsigned int i, szimage;
> > +       int r = 0;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(cio2_csi2_fmts); i++) {
> > +               if (pixelformat == cio2_csi2_fmts[i])
> > +                       break;
> > +       }
> > +
> > +       /* Use SRGGB10 instead of return err */
> > +       if (i >= ARRAY_SIZE(cio2_csi2_fmts))
> 
> I think this should be impossible, since S_FMT should have already
> validated (and corrected) the setting.
> 
> > +               pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> > +
> > +       alloc_devs[0] = &cio2->pci_dev->dev;
> 
> Hmm, so it doesn't go through the IPU MMU in the end?

No. The CSI-2 receiver isn't behind the MMU --- it's entirely separate from
the ISP.

...

> > +static int cio2_v4l2_querycap(struct file *file, void *fh,
> > +                             struct v4l2_capability *cap)
> > +{
> > +       struct cio2_device *cio2 = video_drvdata(file);
> > +
> > +       strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
> > +       strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
> > +       snprintf(cap->bus_info, sizeof(cap->bus_info),
> > +                "PCI:%s", pci_name(cio2->pci_dev));
> > +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> 
> Hmm, I thought single plane queue type was deprecated these days and
> _MPLANE recommended for all new drivers. I'll defer this to other
> reviewers, though.

If the device supports single plane formats only, I don't see a reason to
use MPLANE buffer types.

> [snip]
> > +
> > +       /* Initialize vbq */
> > +       vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +       vbq->io_modes = VB2_USERPTR | VB2_MMAP;
> 
> VB2_DMABUF?
> 
> > +       vbq->ops = &cio2_vb2_ops;
> > +       vbq->mem_ops = &vb2_dma_sg_memops;
> > +       vbq->buf_struct_size = sizeof(struct cio2_buffer);
> > +       vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +       vbq->min_buffers_needed = 1;
> > +       vbq->drv_priv = cio2;
> > +       vbq->lock = &q->lock;
> 
> Does the code take into account queue operations and video device
> operations being asynchronous regarding each other? Given that in this
> case there is always one queue per video device, maybe it would just
> make sense to use the same lock for both? (This happens if you leave
> vbq->lock with NULL.)

Using the same lock should be fine IMO.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
