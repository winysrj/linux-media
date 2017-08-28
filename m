Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57910
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751190AbdH1KaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:30:21 -0400
Date: Mon, 28 Aug 2017 07:30:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v4 7/7] media: open.rst: add a notice about subdev-API
 on vdev-centric
Message-ID: <20170828073009.3762b293@vento.lan>
In-Reply-To: <ac21c30e-1d41-881d-d22e-2244a3dcde2e@xs4all.nl>
References: <cover.1503747774.git.mchehab@s-opensource.com>
        <a77ff374ebde22ea20e1cec7c94026db817ed89d.1503747774.git.mchehab@s-opensource.com>
        <ac21c30e-1d41-881d-d22e-2244a3dcde2e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Aug 2017 12:05:06 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 26/08/17 13:53, Mauro Carvalho Chehab wrote:
> > The documentation doesn't mention if vdev-centric hardware
> > control would have subdev API or not.
> > 
> > Add a notice about that, reflecting the current status, where
> > three drivers use it, in order to support some subdev-specific
> > controls.
> 
> I posted a patch removing v4l-subdevX support for cobalt. It's only used
> within Cisco, so this is safe to do and won't break any userspace support.

OK.

> atmel-isc is another driver that creates subdev nodes. Like cobalt, this
> is unnecessary. There are no sensors that use private controls.

The question is not if the driver has private controls. Private controls
can be V4L2 device node oriented.

The real question is if userspace applications use subdevs or not in
order to set something specific to a subdev, on a pipeline where
multiple subdevs could use the same control.

E. g. even on a simple case where the driver would have something like:

sensor -> processing -> DMA

both "sensor" and "processing" could provide the same control
(bright, contrast, gain, or whatever). Only by exposing such 
control via subdev is possible to pinpoint what part of the 
hardware pipeline would be affected when such control is changed.

> This driver is not referenced anywhere (dts or board file) in the kernel.
> It is highly unlikely anyone would use v4l-subdevX nodes when there is no
> need to do so. My suggestion is to add a kernel option for this driver
> to enable v4l-subdevX support, but set it to 'default n'. Perhaps with
> a note in the Kconfig description and a message in the kernel log that
> this will be removed in the future.
> 
> The final driver is rcar_drif that uses this to set the "I2S Enable"
> private control of the max2175 driver.
> 
> I remember that there was a long discussion over this control. I still
> think that there is no need to mark this private. 

The problem with I2S is that a device may have multiple places
where I2S could be used. I don't know how the rcar-drif driver uses
it, but there are several vdev-centric boards that use I2S for audio.

On several of the devices I worked with, the I2S can be enabled, in
runtime, if the audio signal would be directed to some digital output,
or it can be disabled if the audio signal would be directed to some
analog output. Thankfully, on those devices, I2S can be indirectly
controlled via either an ALSA mixer or via VIDIOC A/V routing
ioctls. Also, there's just one I2S bus on them.

However, on a device that have multiple I2S bus, userspace should
be able to control each of them individually, as some parts of the
pipeline may require it enabled while others may require it
disabled. So, I strongly believe that this should be a subdev
control on such hardware.

That's said, I don't know how rcar_drif uses it. If it has just
one I2S bus and it is used only for audio, then VIDIOC A/V routing
ioctls and/or an ALSA mixer could replace it. If not, then
it should be kept as-is and the driver would need to add support
for MC, in order for applications to identify the right
sub-devices that are associated with the pipelines where I2S
will be controlled.

Thanks,
Mauro
