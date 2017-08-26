Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53516
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752129AbdHZK6T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:58:19 -0400
Date: Sat, 26 Aug 2017 07:58:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 2/3] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20170826075810.123a8939@vento.lan>
In-Reply-To: <b1f6f019-50dd-b067-d631-87f0ab0d866b@xs4all.nl>
References: <cover.1503665390.git.mchehab@s-opensource.com>
        <e789d3d71c7f784d17ffcd8389ce56ae950f736e.1503665390.git.mchehab@s-opensource.com>
        <b1f6f019-50dd-b067-d631-87f0ab0d866b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 25 Aug 2017 15:42:21 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 25/08/17 14:52, Mauro Carvalho Chehab wrote:
> > From: "mchehab@s-opensource.com" <mchehab@s-opensource.com>
> > 
> > When we added support for omap3, back in 2010, we added a new
> > type of V4L2 devices that aren't fully controlled via the V4L2
> > device node. Yet, we never made it clear, at the V4L2 spec,
> > about the differences between both types.
> > 
> > Let's document them with the current implementation.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/open.rst | 53 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > index 9b98d10d5153..bbd1887f83a0 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -6,6 +6,59 @@
> >  Opening and Closing Devices
> >  ***************************
> >  
> > +Types of V4L2 hardware control
> > +==============================
> > +
> > +V4L2 hardware is usually complex: support for the hardware is implemented
> > +via a main driver (also known as bridge driver) and often several
> > +additional drivers. The main driver always exposes one or
> > +more **V4L2 device nodes** (see :ref:`v4l2_device_naming`).
> > +
> > +The other drivers are called **V4L2 sub-devices** and provide control to
> > +other parts of the hardware usually connected via a serial bus (like
> > +I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
> > +controlled directly by the main driver or explicitly via
> > +the **V4L2 sub-device API** (see :ref:`subdev`).
> > +
> > +When V4L2 was originally designed, there was only one type of hardware
> > +control. The entire V4L2 hardware is controlled via the
> > +**V4L2 device nodes**. We refer to this kind of control as
> > +**V4L2 device node centric** (or, simply, **vdev-centric**).
> > +
> > +Since the end of 2010, a new type of V4L2 hardware control was added, in  
> 
> Just drop 'the end of'.
> 
> s/, in/ in/

I anded by changing it to:

	Later (kernel 2.6.39),

> 
> > +order to support complex devices that are common for embedded systems.
> > +Those hardware are controlled mainly via the media controller and  
> 
> Such hardware is
> 
> > +sub-devices. So, they are called: **Media controller centric**
> > +(or, simply, "**MC-centric**").
> > +
> > +For **vdev-centric** hardware control, the hardware is controlled via
> > +the **V4L2 device nodes**. They may optionally support the
> > +:ref:`media controller API <media_controller>` as well, in order to let
> > +the application to know with device nodes are available.  
> 
> to know with -> know which
> 
> > +
> > +.. note::
> > +
> > +   A **vdev-centric** may optionally expose V4L2 sub-devices via  
> 
> I propose adding 'also' before 'expose' to indicate that it is in
> addition to the V4L2 device nodes that were mentioned in the previous
> paragraph.
> 
> > +   :ref:`sub-device API <subdev>`. In that case, it has to implement
> > +   the :ref:`media controller API <media_controller>` as well.
> > +
> > +For **MC-centric** hardware control, before using the V4L2 hardware,
> > +it is required to set the pipelines via the  
> 
> I'd reword this a bit:
> 
> For **MC-centric** hardware control it is required to configure the pipelines
> via the :ref:`media controller API <media_controller>` before the hardware can be used.
> 
> > +:ref:`media controller API <media_controller>`. For those devices, the  
> 
> s/those/such/
> 
> > +sub-devices' configuration can be controlled via the
> > +:ref:`sub-device API <subdev>`, whith creates one device node  
> 
> s/whith/which/
> 
> > +per sub-device.
> > +
> > +In summary, for **MC-centric** hardware control:
> > +
> > +- The **V4L2 device** node is responsible for controlling the streaming
> > +  features;
> > +- The **media controller device** is responsible to setup the pipelines;
> > +- The **V4L2 sub-devices** are responsible for sub-device
> > +  specific settings.
> > +
> > +
> > +.. _v4l2_device_naming:
> >  
> >  V4L2 Device Node Naming
> >  =======================

Changes done. I'll place on a new version of this series.

> >   
> 
> The only thing I am not sure about is vdev-centric vs V4L2-centric. 'Laziness while
> typing' is not a convincing argument :-)

Despite the laziness of playing a lot with shifts to type V4L2-centric,
the thing that bothers me with V4L2 is that the subdev API is part of
V4L2 spec. So, IMHO, it is still a confusing name.

As this actually refers to "V4L2 Device Node", with is now properly
specified (due to patch 1/3), "vdev" is a good shortcut for it.

Let's reverse the question: what's wrong with "vdev-centric"?

Thanks,
Mauro
