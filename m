Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40706 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbdHYN0a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 09:26:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] media: videodev2: add a flag for vdev-centric devices
Date: Fri, 25 Aug 2017 16:27:02 +0300
Message-ID: <3382039.MFWhFQ8s1i@avalon>
In-Reply-To: <20170825070632.28580858@vento.lan>
References: <cover.1503653839.git.mchehab@s-opensource.com> <4f771cfa-0e0d-3548-a363-6470b32a6634@cisco.com> <20170825070632.28580858@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday, 25 August 2017 13:06:32 EEST Mauro Carvalho Chehab wrote:
> Em Fri, 25 Aug 2017 11:44:27 +0200 Hans Verkuil escreveu:
> > On 08/25/2017 11:40 AM, Mauro Carvalho Chehab wrote:
> > > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > As both vdev-centric and mc-centric devices may implement the
> > > same APIs, we need a flag to allow userspace to distinguish
> > > between them.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > ---
> > > 
> > >  Documentation/media/uapi/v4l/open.rst            | 6 ++++++
> > >  Documentation/media/uapi/v4l/vidioc-querycap.rst | 4 ++++
> > >  include/uapi/linux/videodev2.h                   | 2 ++
> > >  3 files changed, 12 insertions(+)
> > > 
> > > diff --git a/Documentation/media/uapi/v4l/open.rst
> > > b/Documentation/media/uapi/v4l/open.rst index
> > > a72d142897c0..eb3f0ec57edb 100644
> > > --- a/Documentation/media/uapi/v4l/open.rst
> > > +++ b/Documentation/media/uapi/v4l/open.rst
> > > @@ -33,6 +33,12 @@ For **vdev-centric** control, the device and their
> > > corresponding hardware> > 
> > >  pipelines are controlled via the **V4L2 device** node. They may
> > >  optionally
> > >  expose via the :ref:`media controller API <media_controller>`.
> > > 
> > > +.. note::
> > > +
> > > +   **vdev-centric** devices should report V4L2_VDEV_CENTERED
> > 
> > You mean CENTRIC, not CENTERED.
> 
> Yeah, true. I'll fix it.
> 
> > But I would change this to MC_CENTRIC: the vast majority of drivers are
> > VDEV centric, so it makes a lot more sense to keep that as the default
> > and only set the cap for MC-centric drivers.
> 
> I actually focused it on what an userspace application would do.
> 
> An specialized application for a given hardware will likely just
> ignore whatever flag is added, and use vdev, mc and subdev APIs
> as it pleases. So, those applications don't need any flag at all.
> 
> However, a generic application needs a flag to allow them to check
> if a given hardware can be controlled by the traditional way
> to control the device (e. g. if it accepts vdev-centric type of
> hardware control).
> 
> It is an old desire (since when MC was designed) to allow that
> generic V4L2 apps to also work with MC-centric hardware somehow.
> 
> At the moment we add that (either in Kernelspace, as proposed for
> iMX6 [1] or via libv4l), a mc-centric hardware can also be
> vdev-centric.
> 
> [1] one alternative proposed for iMX6 driver, would be to enable
>     vdev-centric control only for hardware with a single camera
>     slot, like those cheap RPi3-camera compatible hardware, by
>     using some info at the DT.

DT isn't the right place for this, it should describe the hardware, not how it 
gets exposed by the kernel to userspace. It could be up to each device driver 
to decide, based on the complexity of the hardware as defined in DT, whether 
to expose a vdev-centric or MC-centric API, but I wouldn't recommend that as 
it would drasticly increase the complexity of the driver.

> >> +   :c:type:`v4l2_capability` flag (see :ref:`VIDIOC_QUERYCAP`).
> >> +
> >> +
> >>  For **MC-centric** control, before using the V4L2 device, it is
> >>  required to set the hardware pipelines via the
> >>  :ref:`media controller API <media_controller>`. For those devices, the
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> >> b/Documentation/media/uapi/v4l/vidioc-querycap.rst index
> >> 12e0d9a63cd8..4856821b7608 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> >> @@ -252,6 +252,10 @@ specification the ioctl returns an ``EINVAL`` error
> >> code.
> >>      * - ``V4L2_CAP_TOUCH``
> >>        - 0x10000000
> >>        - This is a touch device.
> >> +    * - ``V4L2_VDEV_CENTERED``
> >> +      - 0x20000000
> >> +      - This is controlled via V4L2 device nodes (radio, video, vbi,
> >> +        sdr
> >>      * - ``V4L2_CAP_DEVICE_CAPS``
> >>        - 0x80000000
> >>        - The driver fills the ``device_caps`` field. This capability can
> >> 
> >> diff --git a/include/uapi/linux/videodev2.h
> >> b/include/uapi/linux/videodev2.h index 45cf7359822c..d89090d99042
> >> 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -460,6 +460,8 @@ struct v4l2_capability {
> >> 
> >>  #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch
> >>  device */
> >> 
> >> +#define V4L2_CAP_VDEV_CENTERED          0x20000000  /* V4L2 Device is
> >> controlled via V4L2 device devnode */ +
> >> 
> >>  #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device
> >>  capabilities field */
> >>  
> >>  /*

-- 
Regards,

Laurent Pinchart
