Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4189 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1I1IBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:01:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
Date: Wed, 28 Sep 2011 10:01:03 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E81D93E.1060107@redhat.com> <4E81FDD2.3090501@samsung.com>
In-Reply-To: <4E81FDD2.3090501@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281001.03564.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 18:46:10 Tomasz Stanislawski wrote:
> Hi Mauro,
> 
> On 09/27/2011 04:10 PM, Mauro Carvalho Chehab wrote:
> > Em 27-09-2011 10:02, Tomasz Stanislawski escreveu:
> >> On 09/26/2011 02:10 PM, Mauro Carvalho Chehab wrote:
> >>> Em 26-09-2011 05:42, Tomasz Stanislawski escreveu:
> >>>> On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:
> >>>>> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
> 
> [snip]
> 
> >>
> >> What do you mean by 'scale type'? Do you mean types like 'shrink', 'enlarge', 'no scale'?
> >
> > I mean: what's the scale that the application should expect for cropping? pixel, sub-mixel, percentage, etc.
> >
> 
> Hans suggest to use pixels as units. I bear to a very similar but 
> slightly different idea that the driver should use units system that 
> guarantees that no scaling is applied while the composing and cropping 
> rectangle are equal. I mean rectangle's width and height.

As I asked before: what's the use-case of non-pixel units anyway? I haven't
seen anything yet. In addition, do you know how other hardware handles
sub-pixel cropping/composing? Do you actually know how this is done in practice?

I strongly feel that the default unit should be pixels. If you want something
else you need to request that (by perhaps setting a SUBPIXEL flag, or by having
SUBPIXEL target rectangles, or perhaps by only doing subpixel selection on the
subdev device node).

> 
> [snip]
> 
> >>>> The selection API introduced the idea
> >>>> of the constraints flags, that are used for precise control of the coordinates' rounding policy.
> >>>
> >>> Ok, but I fail to see where a rounding policy would be
> >>> needed on an input device.
> >>
> >> Please refer to following use case:
> >> - there is a video capture hardware and a grabber application
> >> - a face-detection is implemented in capture hardware
> >> - the application obtains the position of the face using extended control
> >> - application would like to grab only the face, avoiding any extra content
> >> - the application configures cropping rectangle with V4L2_SEL_SIZE_GE flag to assure that no part of the face is lost
> >
> > On all cases I can think with for input devices, the rounding policy should be GE.
> >
> 
> OK. I think I know the use case for the LE flag.
> Please, analyze the following scenario:
> - video capture HW - TV card
> - application - controls TV streaming on the framebuffer
> - the image data are inserted directly into the framebuffer
> - application gets information through extended controls that 
> letterboxed signal is received
> - application is working in full-screen mode. There must be no black 
> border on the screen.
> - application sets crop using the rectangle that covers whole useful 
> image (without borders)
> - application uses V4L2_SEL_SIZE_LE flags while setting crop rectangle 
> to assure that no black border appears on the screen
> 
> >>>
> >>> In other words, I think we should split the issues with
> >>> the crop api into two groups:
> >>>
> >>> 1) for input devices
> >>> 2) for output devices.
> >>>
> >>
> >> No. I strongly prefer to keep consistent API for both capture and output devices. We should avoid adding extra ioctls and structures.
> >
> > Your proposal is to add extra ioctl's and structures.
> 
>  From the point of view of developers of new drivers:
> - implement s_selection and g_selection to support selection API
> - implement s_crop, g_crop, cropcap to support old API
> 
>  From application point of view:
> - use VIDIOC_S_SELECTION, VIDIOC_G_SELECTION, struct v4l2_selection for 
> selection API
> - use VIDIOC_S_CROP, VIDIOC_G_CROP, VIDIOC_CROPCAP, struct v4l2_crop, 
> v4l2_cropcap for old API
> 
> If new applications and drivers support only for selection API then we 
> will have:
> - less ioctl
> - less structures
> - more functionality
> 
> The legacy applications would be supported by simulation of old API 
> using selection API.

As I said before, G/S_CROP is perfectly valid and will not go away or be
deprecated. Just as S_CTRL is not replaced by S_EXT_CTRLS. There is no need
to force apps to move to the selection API. The selection API extends the
old crop API for good reasons, but for simple cropping S_CROP remains perfectly
fine.

What would be nice is to deprecate the old crop ops for new drivers and (ideally)
convert existing drivers that use vidioc_g/s_crop to the new vidioc_g/s_selection
(with the final goal of removing vidioc_g/s_crop).

And also note that cropcap is still needed to get the pixelaspect.

> 
> I'm not saying that we should have
> > different API's for input and for outputs. I'm just telling that we need to analyze each
> > case in separate.
> >
> 
> Please refer to summary of discussion about pipeline configuration.
> The selection API seams to suit well to both types of devices.
> 
> >> Moreover, there are mem2mem devices approaching from horizon.
> >> They combine features of both types of queues. It would be much simpler for developers and application to use the same API.
> >
> > On complex cases, like mem2mem and devices with output queues, your proposal
> > makes sense, but simpler devices can just use the crop API for their
> > input nodes.
> 
> Right. I agree that old API should be kept for backward compatibility 
> reasons.
> 
> BTW, till now I understood that state 'deprecated' just means to avoid 
> using it in the new code.

And even with that meaning you still can't deprecate the application API.

> 
> [snip]
> 
> > Deprecating an API means that it will be removed. So, drivers will need
> > to be ported, and also userspace applications.
> >
> 
> Ok.. I agree that it is to early to deprecate the old API.
> 
> >>> So, please explain us why the above drivers would need to be ported to
> >>> the selection API, or why new input drivers/applications would need
> >>> the new API instead of the old one.
> >>
> >> Some of presented hardware might be capable of composing into memory buffers. This functionality is not available by the current API.
> >> The support for composing operation may justify porting the drivers to the selection API.
> >
> > It is doubtful that any of the above hardware would support composing.
> > Maybe only cx18 might have this capability, but I don't think that the

ivtv, not cx18.

> > existing devices support it anyway.

Most devices that can scale can do composition by being creative with the DMA
engine setup. Just by fiddling with strides and offsets you can achieve this.

I think you can even do this today using USERPTR and fiddling with bytesperline
in v4l2_pix_format. Most drivers will probably ignore the bytesperline value
though. And it won't work for read or memory mapped streaming.

> >
> 
> S5P-FIMC supports this operation. OMAP3 does it too as I know.
> 
> >>> With respect to (2), the only TV device that (ab)used the crop API to
> >>> control its output node is
> >>>      drivers/media/video/ivtv/ivtv-ioctl.c
> >>>
> >>> To complete the drivers list, currently, the only SoC device currently
> >>> implementing vidioc_s_crop for input/output is the davinci driver:
> >>>      drivers/media/video/davinci/vpif_capture.c
> >>>      drivers/media/video/davinci/vpif_display.c
> >>>
> >>> IMO, what it seems to be happening with the crop API is similar to what
> >>> happened in the past with the control API: the existing API works fine
> >>> on simple cases, but fails on more complex scenarios. In the case of
> >>> the control API, several controls need to be grouped when selecting an
> >>> mpeg compression parameters. So, the VIDIOC_[G|S]_EXT_CTRLS were added
> >>> without deprecating the old ioctl's. This way, applications that were
> >>> only supporting controls like bright, volume, etc won't need to be changed.
> >>
> >> Refer to thread:
> >>
> >> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/33799/focus=34727
> >>
> >> The concept of the simple pipeline was described there. The selection is an important part
> >> of this proposition. If this concept is accepted then 'simple pipeline' becomes a new V4L2 primitive.
> >> All other more complex cases would be covered by the multimedia device API. The selection is
> >> cropping/composing API dedicated for such a pipelines because old one was not good enough.
> >>
> >> I agree that most of the selection configuration could be moved to extended control API.
> >> By applying the same logic a few further one could state that the whole configuration
> >> (like VIDIOC_S_FMT, VIDIOC_S_STD, etc) could be moved to the extended controls. Maybe only
> >> the memory and streaming control ioctl would survive.
> >
> > I never said that we should be using the ext control API. I'm just saying that the selection
> > API x crop API resembles the control API x ext control API.
> 
> I agree. However these ioctls are strongly connect with memory 
> management in the similar way as VIDIOC_S_FMT does. Moreover the 
> selection is a simple and robust API that covers a wide range of 
> build-in pipelines. Due to its generality, I think it is worth to be 
> promoted with dedicated ioctl.

I've lost the plot here. This has nothing to do with pipelines, controls or V4L3.
The simple fact of the matter is that the current crop API is insufficiently
powerful (and also confusing since for outputs it does composition instead of
cropping). And the selection API was designed to overcome those limitations.

Nothing more, nothing less.

Nobody is advocating the removal of the CROP ioctls. But it would be nice from
a driver maintenance point of view if we can convert the existing drivers to use
the selection ops instead of the crop ops as much as possible. There aren't that
many that do cropping anyway. And new drivers should implement only the selection
API.

Regards,

	Hans

> 
> >
> > In other words, for the same reason we didn't deprecate the control API when the ext control API
> > were added, I don't think that we should deprecate the crop API in favor of the selection API.
> >
> >> I think that it would be a good start for V4L3 project.
> >
> > Are you proposing that we should start a V4L3 project?????? Why?
> >
> > Only this year we were able of get rid of V4L1 API, after 10+ years of efforts!
> > Why? Moving from V4L2 to anything else will likely take even more time, as we
> > now have much more drivers to take care with.
> 
> I don't want to start V4L3 project. I just hope that if it ever happens 
> then V4L3 would a completely controls-based API with well defined 
> pipeline configuration rules and memory management compatible with other 
> popular APIs.
> 
> Best regards,
> Tomasz Stanislawski
> 
