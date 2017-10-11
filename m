Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56988 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbdJKJFe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 05:05:34 -0400
Date: Wed, 11 Oct 2017 06:05:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 5/7] media: open.rst: Adjust some terms to match the
 glossary
Message-ID: <20171011060523.62daca97@vento.lan>
In-Reply-To: <20171010224100.lfdnvzkxw457setj@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <9a2db3c52a3d894728d6ed29681f49e8745f98a9.1506550930.git.mchehab@s-opensource.com>
        <20171006124822.xjppck3ks4as3zqf@valkosipuli.retiisi.org.uk>
        <20171010083743.03e8f1b9@vento.lan>
        <20171010224100.lfdnvzkxw457setj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Oct 2017 01:41:00 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Oct 10, 2017 at 08:37:43AM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri, 6 Oct 2017 15:48:22 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > On Wed, Sep 27, 2017 at 07:23:47PM -0300, Mauro Carvalho Chehab wrote:  
> > > > As we now have a glossary, some terms used on open.rst
> > > > require adjustments.
> > > > 
> > > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > ---
> > > >  Documentation/media/uapi/v4l/open.rst | 12 ++++++------
> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > > > index f603bc9b49a0..0daf0c122c19 100644
> > > > --- a/Documentation/media/uapi/v4l/open.rst
> > > > +++ b/Documentation/media/uapi/v4l/open.rst
> > > > @@ -143,7 +143,7 @@ Related Devices
> > > >  Devices can support several functions. For example video capturing, VBI
> > > >  capturing and radio support.
> > > >  
> > > > -The V4L2 API creates different nodes for each of these functions.
> > > > +The V4L2 API creates different V4L2 device nodes for each of these functions.    
> > > 
> > > A V4L2 device node is an instance of the V4L2 API. At the very least we
> > > should call them "V4L2 device node types", not device nodes only. This
> > > simply would suggests they're separate.  
> > 
> > OK, I added "types" there.
> >   
> > > 
> > > s/creates/defines/ ?  
> > 
> > It is meant to say create.
> > 
> > A device that supports both radio, video and VBI for the same V4L2
> > input will create three device nodes:
> > 	/dev/video0
> > 	/dev/radio0
> > 	/dev/vbi0
> > 
> > As all are associated to the same video input, and an ioctl send 
> > to one device may affect the other devices too, as they all associated
> > with the same hardware.  
> 
> Right. In this case I'd change the sentence. What would you think of this?
> 
> "Each of these functions is available via separate V4L2 device node."

Maybe replacing "is" by "should be" (or shall be?) would express the
requirement.

> 
> For it's not the V4L2 API that creates them. I failed to grasp what the
> original sentence meant. Was it about API, or framework, or were the
> devices nodes just separate or unlike as well?

Short answer:

>From uAPI PoV, it doesn't matter if it is the driver or the framework
that creates multiple device nodes.

What matters is that, if multiple types of capture/input are possible, 
multiple devnodes are created. Also, if one wants to control a radio
function, it should use /dev/radio, instead of /dev/video.

Long answer:

At kAPI, a typical register code, found on almost all non-webcam drivers is:

	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
				    video_nr[dev->devno]);
	if (ret)
		goto error;

	if (vbi_supported(dev)) {
		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
					    vbi_nr[dev->devno]);
		if (ret)
			goto error;
	}

	if (radio_supported(dev)) {
		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
					    radio_nr[dev->devno]);
		if (ret)
			goto error;
	}

	(note: it doesn't make sense to mention the above kAPI code at
	 the uAPI documentation)


All tree devnodes are associated to the same capture or input device.

In the past, it was possible to use a /dev/radio to watch a video,
or /dev/video to listen radio, as they both corresponds to the same
V4L2 device, and the ioctl arguments used for radio and VBI are 
different. In other words, "/dev/radio" and "/dev/vbi" worked like a
sort of alias to the same device. Such support, however, required the
V4L2 core to do some tricks to identify the type of usage between
radio and video modes when handling tuner ioctls, like
VIDIOC_G_FREQUENCY/VIDIOC_S_FREQUENCY, making harder to prevent the
simultaneous usage of the device by a radio and a video application,
and causing some bugs (like returning a FM frequency on TV, or an
UHF frequency on radio).

So, several years ago, the API spec was modified to forbid such
usage, and support for switching the mode between radio/video mode
based on ioctl set usage was removed.

Yet, the v4l2 core use a coarse logic there: it only handles
differently stuff that are required to be different (like frequencies).
It won't check if, for example, a CTRL belongs to radio or video.
So, one can change a control using any device node, no matter if
the control belongs to video or radio.

So, in summary, the goal of the "Related Devices" at uAPI is to
mention that, if a V4L2 device supports multiple types, multiple
device nodes will be created, one for each (V4L2 device, type)
tuple[1].

[1] So, a driver for a board that supports four V4L2 devices, each
    with radio, vbi and video will create 12 device nodes.

Thanks,
Mauro
