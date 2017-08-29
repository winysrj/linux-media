Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33918
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751329AbdH2JIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 05:08:07 -0400
Date: Tue, 29 Aug 2017 06:07:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v5 2/7] media: open.rst: better document device node
 naming
Message-ID: <20170829060755.6ad54051@vento.lan>
In-Reply-To: <20170829083406.c3lkpaj33ybngvil@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
        <f63c7412638307f3f58dc114b64339755741feb6.1503924361.git.mchehab@s-opensource.com>
        <20170829083406.c3lkpaj33ybngvil@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Tue, 29 Aug 2017 11:34:06 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Aug 28, 2017 at 09:53:56AM -0300, Mauro Carvalho Chehab wrote:
> > Right now, only kAPI documentation describes the device naming.
> > However, such description is needed at the uAPI too. Add it,
> > and describe how to get an unique identify for a given device.
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/open.rst | 39 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 36 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > index afd116edb40d..fc0037091814 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -7,12 +7,14 @@ Opening and Closing Devices
> >  ***************************
> >  
> >  
> > -Device Naming
> > -=============
> > +.. _v4l2_device_naming:
> > +
> > +V4L2 Device Node Naming
> > +=======================
> >  
> >  V4L2 drivers are implemented as kernel modules, loaded manually by the
> >  system administrator or automatically when a device is first discovered.
> > -The driver modules plug into the "videodev" kernel module. It provides
> > +The driver modules plug into the ``videodev`` kernel module. It provides
> >  helper functions and a common application interface specified in this
> >  document.
> >  
> > @@ -23,6 +25,37 @@ option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
> >  are allocated in ranges depending on the device node type (video, radio,
> >  etc.).
> >  
> > +The existing V4L2 device node types are:
> > +
> > +======================== ======================================================
> > +Default device node name Usage
> > +======================== ======================================================
> > +``/dev/videoX``		 Video input/output devices
> > +``/dev/vbiX``		 Vertical blank data (i.e. closed captions, teletext)
> > +``/dev/radioX``		 Radio tuners and modulators
> > +``/dev/swradioX``	 Software Defined Radio tuners and modulators
> > +``/dev/v4l-touchX``	 Touch sensors  
> 
> Should we document V4L2 sub-device nodes here as well? They are implemented
> by the V4L2 core as well as the other device node types.
> 
> Their purpose is somewhat different, though, and I think we'll need to make
> that explicit somehow.

Actually, what we're calling as "V4L2 Device node" are the vdev-centric
device nodes. That should not include /dev/v4l-subdevX.

What we can do here is to explicitly rule out the subdev interfaces,
with something like:

.. note::

	3. **V4L2 sub-device nodes** (e. g. ``/dev/v4l-sudevX``) provide a
	   different API and aren't considered as V4L2 device nodes.
	   They are covered at :ref:`subdev`.

> 
> > +======================== ======================================================
> > +
> > +Where ``X`` is a non-negative number.
> > +
> > +.. note::
> > +
> > +   1. The actual device node name is system-dependent, as udev rules may apply.
> > +   2. There is no warranty that ``X`` will remain the same for the same  
> 
> s/warranty/guarantee/

OK.

> 
> > +      device, as the number depends on the device driver's probe order.
> > +      If you need an unique name, udev default rules produce
> > +      ``/dev/v4l/by-id/`` and ``/dev/v4l/by-path/`` directoiries containing  
> 
> "directories"

OK.

> 
> > +      links that can be used uniquely to identify a V4L2 device node::
> > +
> > +	$ tree /dev/v4l
> > +	/dev/v4l
> > +	├── by-id
> > +	│   └── usb-OmniVision._USB_Camera-B4.04.27.1-video-index0 -> ../../video0
> > +	└── by-path
> > +	    └── pci-0000:00:14.0-usb-0:2:1.0-video-index0 -> ../../video0
> > +
> > +
> >  Many drivers support "video_nr", "radio_nr" or "vbi_nr" module
> >  options to select specific video/radio/vbi node numbers. This allows the
> >  user to request that the device node is named e.g. /dev/video5 instead  
> 



Thanks,
Mauro
