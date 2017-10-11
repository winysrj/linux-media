Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52028 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753117AbdJKKPc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 06:15:32 -0400
Date: Wed, 11 Oct 2017 07:15:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171011071524.449e4fd1@vento.lan>
In-Reply-To: <20171010221857.tlf3y2to353ybwk5@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
        <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
        <20171006115105.wqabs3cm34gdy3w5@valkosipuli.retiisi.org.uk>
        <20171010061339.67584102@vento.lan>
        <20171010115435.eer5yaybxdni2ck7@valkosipuli.retiisi.org.uk>
        <20171010094938.044fb335@vento.lan>
        <20171010221857.tlf3y2to353ybwk5@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Oct 2017 01:18:58 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> > So, if you look, for example, at the chapter 1 name:
> > 	"common API elements"
> > 
> > it implies that every single V4L2 device node supports what's there.
> > But that's not the case, for example, for what's described at
> > Documentation/media/uapi/v4l/querycap.rst (with is part of
> > chapter 1).  
> 
> Ah. I see what you mean.
> 
> > 
> > There are a couple of possible alternatives:
> > 
> > 1) define V4L2 device nodes excluding /dev/subdev, with is the
> >    current approach;
> > 
> > 2) rewrite the entire V4L2 uAPI spec to explicitly talk, on each
> >    section, if it applies or not to sub-devices;  
> 
> There are exceptions in the common API elements section even now. For
> instance, it mentions that radio devices don't support video streaming
> related IOCTLs. 

FYI, when this chapter was written, radio devices did support video
streaming ioctls :-)

As I explained on a previous email, Only several years after V4L2
spec was written, it was decided to nack using a radio device to 
control a video stream.

The real issue is that radio sets frequencies on multiples of 62.5 Hz,
while TV sets frequencies on multiples of 62.5 kHz. Due to that, the
core needs to know if the device is in radio or TV mode, in order to
handle VIDIOC_G_FREQUENCY/VIDIOC_S_FREQUENCY. There was a code there
that used to identify, but it was buggy, and there were no safe way
fix.

So, the "common API elements" was modified to forbid to use radio to
do video stream.

Later, a coarse grain logic was added at the v4l2 core in order to
present a different set of ioctls, based on the V4L2 device type,
and the chapter was modified again.

On that time, we were lazy enough to rewrite chapter 1. So,
we just add an exception "hack" at the chapter noticing that
radio devices don't stream.

I don't see a strong reason to not add other pontual exceptions
there where pertinent, but if we start having too many exceptions,
then is time to rewrite it in a way that would make more sense.

> Under common API elements, also the first section (opening
> and closing devices) refers to the interfaces section which, as we know,
> contains sub-device documentation.

Yeah, exceptions could be added, but it means that someone should read
the entire chapter and mention what doesn't apply for subdev.

> Do you see that something else is needed than telling which common API
> elements aren't relevant for sub-devices? (I didn't find explicit
> information in other sections, by a quick glance at least, telling which
> interfaces they apply to.)

No. I didn't read the entire chapter to see what doesn't apply for
sub-devices, but I'm pretty sure that there are many things. For
example, you can't read/write/mmap/stream a video on a subdev.

> Should we make such a change, this would be an additional argument for
> supporting VIDIOC_QUERYCAP on sub-devices.

Nah. We shouldn't add ioctls with the argument that it would be easier
to document. Also, if we add a subdev QUERYCAP, it would provide a
different set of information than a V4L2 device QUERYCAP.

> Further on, section 8, "Common
> definitions for V4L2 and V4L2 subdev interfaces", should probably be merged
> with the "common API elements" section.

Well, if we go to approach (2), we'll need to shrink the common
API definitions chapter, and add another chapter for the "uncommon"
features.

As an exercise: try to rewrite just open.rst to exclude sudevs where
not pertinent. Even a single definition like this:


	The main driver always exposes one or more
	:term:`V4L2 device nodes <v4l2 device node>`
	(see :ref:`v4l2_device_naming`) with are responsible for implementing
	data streaming, if applicable.

will become a lot more complex to explain if we don't have any term
to refer to "all device node types created by the v4l2 core except
for /dev/v4l-subdev* and /dev/mediaXXX".

The "Related devices" and "Shared Data Streams" sections won't apply to
subdevs.

Most of what's written at the "Multiple Opens" section also don't
apply, as subdevs don't support streaming nor they accept the priority
mechanisms via VIDIOC_S_PRIORITY.

The notes at "Functions" section also don't apply to subdevs.

So, it is probably a lot easier to just create a new "open.rst"
for subdev API and remove all that doesn't apply - as proposed
in approach (3) (see below) - keeping the V4L2 one as-is.

In a matter of fact, most of the things explained at V4L2
part of the spec don't apply to subdevs. So, it is easier
to just tell what applies there (controls, events, format 
negotiation, crop/selection) than the opposite.

The dev-subdev.rst does a good job describing it. If we move
it from Documentation/media/uapi/v4l to Documentation/media/uapi/subdev,
all we need to do is to add chapters for the syscalls it
supports: open/close/ioctl, with can be a simplified version of what
is there at v4l, removing all things that don't apply to subdevs.

The dev-subdev.rst already has links to the pertinent sections
at v4l uAPI spec. So, I suspect that, if it require any change at
all, that would be minimal.

It would probably be worth to mention at the controls, events
and selection/crop sections that what's described there applies
to both V4L2 and subdev APIs.


> Just my thougts. Anyway... let's continue tomorrow.
> 
> > 
> > 3) "promote" subdev API to a separate part of the media spec,
> >    just like what it was done for media controller, e. g. adding
> >    a /Documentation/media/uapi/subdev directory and add there
> >    descriptions for all syscalls that apply to subdevs
> >    (open, close, ioctl). That would be weird from kAPI point of
> >    view, as splitting it from V4L2 won't make sense there. So,
> >    we'll likely need to add some notes at both kAPI and uAPI to
> >    explain that the subdev API userspace API is just a different
> >    way to expose V4L2 hardware control, but, internally, both
> >    are implemented by the same V4L2 core.

Long term, IMHO, (3) is the best solution. Also, I think it is easier
to do that than (2).

My proposal is that, for 4.15, we do (1), by adding an exception
to what we consider as V4L2 device nodes, explicitly excluding 
subdevs. Then, with time, we go to (3).

> > 
> > This patchset assumes (1). I'm ok if someone wants to do either
> > (2) or (3), but I won't have the required time to do such
> > changes.  


Thanks,
Mauro
