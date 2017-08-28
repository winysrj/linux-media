Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58197
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750873AbdH1Mnz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:43:55 -0400
Date: Mon, 28 Aug 2017 09:43:46 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v4 4/7] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20170828094346.4a439342@vento.lan>
In-Reply-To: <0ccc7cf6-9a62-60ca-6423-a4c100197f0a@xs4all.nl>
References: <cover.1503747774.git.mchehab@s-opensource.com>
        <2fbdd960b286b73b8bdb60baf83a3e659c41789a.1503747774.git.mchehab@s-opensource.com>
        <0ccc7cf6-9a62-60ca-6423-a4c100197f0a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Aug 2017 11:36:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> > When we added support for omap3, back in 2010, we added a new
> > type of V4L2 devices that aren't fully controlled via the V4L2
> > device node.
> > 
> > Yet, we have never clearly documented in the V4L2 specification
> > the differences between the two types.
> > 
> > Let's document them based on the the current implementation.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/open.rst | 49 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > index 96ac972c1fa2..51acb8de8ba8 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -7,6 +7,55 @@ Opening and Closing Devices
> >  ***************************
> >  
> >  
> > +.. _v4l2_hardware_control:
> > +
> > +
> > +Types of V4L2 hardware peripheral control
> > +=========================================
> > +
> > +V4L2 hardware periferal is usually complex: support for it is  
> 
> peripheral
> 
> I *really* don't like the term "hardware peripheral". For me that means a
> mouse, keyboard, printer, webcam, i.e. some external device that you connect
> to a USB bus or similar, but it makes no sense as a definition of an
> SoC + sensor(s) hardware design.
> 
> I would simple define "V4L2 hardware" as consisting of 1 or more "V4L2 hardware
> components".

I don't have a strong preference here.

If I remember my computer architecture books, back on the old days, 
everything that does I/O is technically a peripheral to the CPU. That
seems, btw, the definition used by Wikipedia:

	https://en.wikipedia.org/wiki/Peripheral

So, calling it as peripheral works.

On the other hand, "V4L2 hardware" doesn't seem an adequate term,
as it associates a software API with a piece of hardware. It is
weirder when the hardware have an hybrid tuner, as the same hardware
is visible via both DVB and V4L2 APIs. Yet, we could find a similar
wording, like "media hardware".

I'm OK to replace it to something like "media hardware", but, I
prefer to do such change on a patch to be applied after this series,
in order to minimize the rebase needs[1].

[1] as you noticed on patch 6/7, with all those nomenclature changes,
one of the places were written as "v4l2-centric" instead of "vdev-centric"
as on the other patches. That's basically the problem with rebases: we
end by letting loose ends. So, IMHO, if we end by deciding to rename
	A->B
	C->D
Let's do it on a separate patch at the end of the series, as a simple
grep |sed -i could replace all occurrences at once without letting
lose ands and without needing to solve patch merge conflicts.

> > +implemented via a V4L2 main driver and often by several additional drivers.
> > +The main driver always exposes one or more **V4L2 device nodes**
> > +(see :ref:`v4l2_device_naming`).  
> 
> I think we should mention that the V4L2 device nodes are responsible for
> implementing streaming (if applicable) of data.

Ok.

> > +
> > +The other drivers are called **V4L2 sub-devices** and provide control to
> > +other hardware components usually connected via a serial bus (like
> > +I²C, SMBus or SPI). Depending on the main driver, they can be implicitly
> > +controlled directly by the main driver or explicitly via
> > +the **V4L2 sub-device API** (see :ref:`subdev`).
> > +
> > +When V4L2 was originally designed, there was only one type of
> > +peripheral control: via the **V4L2 device nodes**. We refer to this kind  
> 
> Again, I prefer the term "V4L2 hardware control".
> 
> > +of control as **V4L2 device node centric** (or, simply, "**vdev-centric**").
> > +
> > +Later (kernel 2.6.39), a new type of periferal control was  
> 
> periferal -> V4L2 hardware
> 
> > +added in order to support complex peripherals that are common for embedded  
> 
> complex V4L2 hardware
> 
> (repeat below where you use this 'peripheral' term)
> 
> > +systems. This type of periferal is controlled mainly via the media
> > +controller and V4L2 sub-devices. So, it is called
> > +**Media controller centric** (or, simply, "**MC-centric**").  
> 
> add 'control' at the end.

Ok.

> > +
> > +For **vdev-centric** hardware peripheral control, the peripheral is
> > +controlled via the **V4L2 device nodes**. They may optionally support the
> > +:ref:`media controller API <media_controller>` as well, in order to let
> > +the application to know which device nodes are available  
> 
> to know -> know
> 
> Actually, I would rephrase this to:
> 
> in order to inform the application which device nodes are available

Ok.

> > +(see :ref:`related`).
> > +
> > +For **MC-centric** hardware peripheral control it is required to configure
> > +the pipelines via the :ref:`media controller API <media_controller>` before
> > +the periferal can be used. For such devices, the sub-devices' configuration
> > +can be controlled via the :ref:`sub-device API <subdev>`, which creates one
> > +device node per sub-device.
> > +
> > +In summary, for **MC-centric** hardware peripheral control:
> > +
> > +- The **V4L2 device** node is responsible for controlling the streaming
> > +  features;
> > +- The **media controller device** is responsible to setup the pipelines
> > +  at the peripheral;
> > +- The **V4L2 sub-devices** are responsible for V4L2 sub-device
> > +  specific settings at the sub-device hardware components.  
> 
> ... settings of the corresponding hardware components.
> 
> I agree with Laurent that I don't think this summary is needed. I would drop
> it for v5 and we can look at the text again and see if it needs more work to
> clarify things.

Ok, I'll drop it.

> The main thing here is that the note about the V4L2 device node being responsible
> for controlling the streaming features is mentioned when the V4L2 device node is
> introduced above, since this is true for both MC and vdev-centric HW control.
> 
> > +
> > +
> >  .. _v4l2_device_naming:
> >  
> >  V4L2 Device Node Naming
> >   
> 
> Regards,
> 
> 	Hans

I'll submit a v5 soon, without the terms renaming. If we all agree
with renaming terms, I'll produce a separate patch fixing it where
used.

Thanks,
Mauro
