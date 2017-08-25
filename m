Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49357
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755446AbdHYJfR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:35:17 -0400
Date: Fri, 25 Aug 2017 06:35:07 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "mchehab@s-opensource.com" <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH RFC v2] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20170825063507.2a2b2b43@vento.lan>
In-Reply-To: <20170824150748.lnqjvp4j3xo65ckk@valkosipuli.retiisi.org.uk>
References: <779378fa18f93929547665467990ff9284a60521.1503576451.git.mchehab@osg.samsung.com>
        <20170824150748.lnqjvp4j3xo65ckk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Aug 2017 18:07:48 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Thanks for the update! A few comments below.
> 
> (Cc Hans and Laurent.)
> 
> On Thu, Aug 24, 2017 at 09:07:35AM -0300, Mauro Carvalho Chehab wrote:
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
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> 
> Pick one. :-)

I edited it on another machine that were using the old address :-)
I'll fix on the next version.

> 
> > ---
> >  Documentation/media/uapi/v4l/open.rst | 47 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > index afd116edb40d..cf522d9bb53c 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -6,6 +6,53 @@
> >  Opening and Closing Devices
> >  ***************************
> >  
> > +Types of V4L2 device control
> > +============================
> > +
> > +V4L2 devices are usually complex: they're implemented via a main driver and
> > +often several additional drivers. The main driver always exposes one or
> > +more **V4L2 device** devnodes (see :ref:`v4l2_device_naming`). The other
> > +devices are called **V4L2 sub-devices**. They are usually controlled via a
> > +serial bus (I2C or SMBus).  
> 
> Reading this paragraph again, I think this is meant as an introduction to
> the reader. In this level of documentation (user space), it's fair to
> describe hardware. As the V4L2 sub-device concept in the kernel and the
> V4L2 sub-device API which is visible to the user space are not exactly the
> same things, I think I'd avoid using V4L2 sub-device concept when referring
> to hardware and how the concept is used in the kernel.
> 
> How about, to replace the two last sentences:
> 
> The other devices are typically I²C or SPI devices. Depending on the main
> driver, these devices are controlled either implicitly through the main
> driver or explicitly through the **V4L2 sub-device** interface.
> 
> (I'm not sure the second sentence is even needed here.)

Yeah, there is a mix of concepts here. I wanted to also define here
that those "other drivers" are called as "V4L2 sub-devices", as this
documentation is also a reference for driver developers. I ended by
mixing things there. I suspect that the best would be to write it as:

	The other drivers are called **V4L2 sub-devices** and provide control to
	other parts of the hardware usually connected via a serial bus
	(like I²C, SMBus or SPI). They can be implicitly controlled directly by the
	main driver or explicitly through via the **V4L2 sub-device API** interface.


> > +
> > +When V4L2 started, there was only one type of device control. The entire
> > +device was controlled via the **V4L2 device nodes**. We refer to this
> > +kind of control as **V4L2 device-centric** (or, simply, **device-centric**).  
> 
> I'm still not quite happy with the naming. "Device" is too generic. How
> about "V4L2-centric"? SDR, radio and video nodes are part of V4L2, so I
> think that should convey the message as well as is factually correct.

V4L2-centric is too generic too, as the subdev API is part of V4L2 :-)

On our meeting, Laurent referred them as vdev-centric, with is a shortcut
for "V4L2 device centric". I guess such name would be OK.

> > +
> > +Since the end of 2010, a new type of V4L2 device control was added in order
> > +to support complex devices that are common on embedded systems. Those
> > +devices are controlled mainly via the media controller and sub-devices.
> > +So, they're called: **media controller centric** (or, simply,
> > +"**mc-centric**").  
> 
> Looks good. I'd use capital "M" in Media controller.

Ok.

> 
> > +
> > +On **device-centric** control, the device and their corresponding hardware
> > +pipelines are controlled via the **V4L2 device** node. They may optionally
> > +expose the hardware pipelines via the
> > +:ref:`media controller API <media_controller>`.  
> 
> s/the hardware pipelines//

Ok.

> 
> It could be that there is a media device, but still no pipeline. Think of
> lens and flash devices, for instance.
> 
> > +
> > +On a **mc-centric**, before using the V4L2 device, it is required to  
> 
> In English, abbreviations are capitalised, i.e. "MC-centric".

Ok.

> 
> > +set the hardware pipelines via the
> > +:ref:`media controller API <media_controller>`. On those devices, the
> > +sub-devices' configuration can be controlled via the
> > +:ref:`sub-device API <subdev>`, with creates one device node per sub device.
> > +
> > +In summary, on **mc-centric** devices:
> > +
> > +- The **V4L2 device** node is mainly responsible for controlling the
> > +  streaming features;
> > +- The **media controller device** is responsible to setup the pipelines
> > +  and image settings (like size and format);  
> 
> "image settings (like size and format)" go to the sub-device bullet below.

I guess I'll just remove it then, as it is implicit when it says:
	"sub-device specific settings".

> 
> > +- The **V4L2 sub-devices** are responsible for sub-device
> > +  specific settings.
> > +
> > +.. note::
> > +
> > +   It is forbidden for **device-centric** devices to expose V4L2
> > +   sub-devices via :ref:`sub-device API <subdev>`, although this
> > +   might change in the future.  
> 
> I believe we agree on the subject matter but we can still argue. :-D
> 
> Could you drop ", although this might change in the future" part? We've
> established that there is no use case currently and we could well allow
> things in the API that were not allowed before without a specific not in
> the spec.

As we sort of agreed at the meeting on Thu, I changed it to:

   A **vdev-centric** may optionally expose V4L2 sub-devices via
   :ref:`sub-device API <subdev>`. In that case, it has to implement
   the :ref:`media controller API <media_controller>` as well.

Thanks,
Mauro
