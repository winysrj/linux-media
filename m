Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40834 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751655AbdF1Ncc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 09:32:32 -0400
Date: Wed, 28 Jun 2017 16:31:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170628133156.c333lrsauageq3yt@valkosipuli.retiisi.org.uk>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
 <20170626145105.GN12407@valkosipuli.retiisi.org.uk>
 <CAAFQd5AGEYRZye3ShEGLrLTyG67jRzSU2-dN6=wmo5DuVxvGaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AGEYRZye3ShEGLrLTyG67jRzSU2-dN6=wmo5DuVxvGaw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 27, 2017 at 06:33:13PM +0900, Tomasz Figa wrote:
> On Mon, Jun 26, 2017 at 11:51 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Mon, Jun 12, 2017 at 06:59:18PM +0900, Tomasz Figa wrote:
> >
> >>
> >> > +       if (WARN_ON(freq <= 0))
> >> > +               return -EINVAL;
> >>
> >> It generally doesn't make sense for the frequency to be negative, so
> >> maybe the argument should have been unsigned to start with? (And
> >> 32-bit if we don't expect frequencies higher than 4 GHz anyway.)
> >
> > The value comes from a 64-bit integer V4L2 control so that implies the value
> > range of s64 as well.
> 
> Okay, if there is no way to enforce this at control level, then I
> guess we have to keep this here.
> 
> >
> >>
> >> > +
> >> > +       /* b could be 0, -2 or -8, so r < 500000000 */
> >>
> >> Definitely. Anything <= 0 is also less than 500000000. Let's take a
> >> look at the computation below again:
> >>
> >> 1) accinv is multiplied by b,
> >> 2) 500000000 is divided by 256 (=== shift right by 8 bits) = 1953125,
> >> 3) accinv*b is multiplied by 1953125 to form the value of r.
> >>
> >> Now let's see at possible maximum absolute values for particular steps:
> >> 1) 16 * -8 = -128 (signed 8 bits),
> >> 2) 1953125 (unsigned 21 bits),
> >> 3) -128 * 1953125 = -249999872 (signed 29 bits).
> >>
> >> So I think the important thing to note in the comment is:
> >>
> >> /* b could be 0, -2 or -8, so |accinv * b| is always less than (1 <<
> >> ds) and thus |r| < 500000000. */
> >>
> >> > +       r = accinv * b * (500000000 >> ds);
> >>
> >> On the other hand, you lose some precision here. If you used s64
> >> instead and did the divide shift at the end ((accinv * b * 500000000)
> >> >> ds), for the example above you would get -250007629. (Depending on
> >> how big freq is, it might not matter, though.)
> >>
> >
> > The frequency is typically hundreds of mega-Hertz.
> 
> I think it still would make sense to have the calculation a bit more precise.

Then the solution is to divide by the 64-bit number, i.e. do_div(). IMO
this shouldn't be a big deal either way: the result needs to be in a value
range and this is only done once when streaming is started.

> 
> >
> >> Also nit: What is 500000000? We have local constants defined above, I
> >> think it could also make sense to do the same for this one. The
> >> compiler should do constant propagation and simplify respective
> >> calculations anyway.
> >
> > COUNT_ACC in the formula in the comment a few decalines above is in
> > nanoseconds. Performing the calculations in integer arithmetics results in
> > having 500000000 in the resulting formula.
> >
> > So this is actually a constant related to the hardware but it does not have
> > a pre-determined name because it is derived from COUNT_ACC.
> 
> Which, I believe, doesn't stop us from naming it.

No, but the value is derived from another value and used once. There's not
much value in adding a macro for IMO.

The formula can be perhaps easier written as:

	accinv * a + (accinv * b * (500000000 >> ds)
		      / (int32_t)(link_freq >> ds));

If you insist, how about COUNT_ACC_FACTOR, for it's derived from COUNT_ACC?

> 
> >> > +static int cio2_v4l2_querycap(struct file *file, void *fh,
> >> > +                             struct v4l2_capability *cap)
> >> > +{
> >> > +       struct cio2_device *cio2 = video_drvdata(file);
> >> > +
> >> > +       strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
> >> > +       strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
> >> > +       snprintf(cap->bus_info, sizeof(cap->bus_info),
> >> > +                "PCI:%s", pci_name(cio2->pci_dev));
> >> > +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> >>
> >> Hmm, I thought single plane queue type was deprecated these days and
> >> _MPLANE recommended for all new drivers. I'll defer this to other
> >> reviewers, though.
> >
> > If the device supports single plane formats only, I don't see a reason to
> > use MPLANE buffer types.
> 
> On the other hand, if a further new revision of the hardware (or
> amendment of supported feature set of current hardware) actually adds
> support for multiple planes, changing it to MPLANE will require
> keeping a non-MPLANE variant of the code, due to userspace
> compatibility concerns...

I think I have to correct my earlier statement --- the device supports
multi-planar formats as well. They're only useful with SoC cameras though,
not with raw Bayer cameras.

IMO VB2/V4L2 could better support conversion between single and
multi-planar buffer types so that the applications could just use any and
drivers could manage with one.

I don't have a strong opinion either way, but IMO this could be well
addressed later on by improving the framework when (or if) the support for
formats such as NV12 is added.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
