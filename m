Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab1ETTrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 15:47:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Fri, 20 May 2011 21:47:21 +0200
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105201749.27977.laurent.pinchart@ideasonboard.com> <4DD6BE21.30605@redhat.com>
In-Reply-To: <4DD6BE21.30605@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202147.22435.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Friday 20 May 2011 21:16:49 Mauro Carvalho Chehab wrote:
> Em 20-05-2011 12:49, Laurent Pinchart escreveu:
> > On Friday 20 May 2011 17:32:45 Mauro Carvalho Chehab wrote:
> >> Em 15-05-2011 04:48, Laurent Pinchart escreveu:
> >>> Hi Mauro,
> >>> 
> >>> The following changes since commit
> > 
> > f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> >>>   [media] DVB: return meaningful error codes in dvb_frontend
> >>>   (2011-05-09 05:47:20 +0200)
> >>> 
> >>> are available in the git repository at:
> >>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> >>> 
> >>> They replace the git pull request I've sent on Thursday with the same
> >>> subject.
> >>> 
> >>> Bob Liu (2):
> >>>       Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
> >>>       uvcvideo: Add support for NOMMU arch
> >> 
> >> IMO, such fixes should happen inside the arch bits, and not on each
> >> driver. If this fix is needed for uvc video, the same fix should
> >> probably needed to all other USB drivers, in order to work on NOMMU
> >> arch.
> >> 
> >> For now, I'm accepting this as a workaround, but please work on a
> >> generic solution for it.
> > 
> > A fix at the arch/ level isn't possible, as drivers need to implement the
> > get_unmapped_area file operation in order to support NOMMU architectures.
> > The proper fix is of course to port uvcvideo to videobuf2, and implement
> > support for NOMMU in videobuf2. Modifications to individual drivers will
> > still be needed to fill the get_unmapped_area operation pointer with a
> > videobuf2 handler though.
> 
> This doesn't sound nice, as most people test their drivers only on an
> specific architecture. If the driver can work on more then one
> architecture (e. g. if it is not part of the IP block of some SoC chip,
> but, instead, uses some generic bus like USB or PCI), the driver itself
> shouldn't contain any arch-specific bits. IMO, the proper fix should be
> either at the DMA stuff or somewhere inside the bus driver implementation.

It might not sound nice, but that's how NOMMU works. It needs 
get_unmapped_area. If you can get rid of that requirement I'll be happy to 
remove NOMMU-specific support from the driver :-)

> >>> Hans de Goede (2):
> >>>       v4l: Add M420 format definition
> >>>       uvcvideo: Add M420 format support
> >> 
> >> OK.
> >> 
> >>> Laurent Pinchart (4):
> >>>       v4l: Release module if subdev registration fails
> >>>       uvcvideo: Register a v4l2_device
> >>>       uvcvideo: Register subdevices for each entity
> >>>       uvcvideo: Connect video devices to media entities
> >> 
> >> We've discussed already about using the media controller for uvcvideo,
> >> but I can't remember anymore what where your aguments in favor of
> >> merging it (and, even if I've remembered it right now, the #irc channel
> >> log is not the proper way to document the rationale to apply a patch).
> >> 
> >> The thing is: it is clear that SoC embedded devices need the media
> >> controller, as they have IP blocks that do weird things, and userspace
> >> may need to access those, as it is not possible to control such IP
> >> blocks using the V4L2 API.
> >> 
> >> However, I have serious concerns about media_controller API usage on
> >> generic drivers, as it is required that all drivers should be fully
> >> configurable via V4L2 API alone, otherwise we'll have regressions, as no
> >> generic applications use the media_controller.
> >> 
> >> In other words, if you have enough arguments about why we should add
> >> media_controller support at the uvcvideo, please clearly provide them at
> >> the patch descriptions, as this is not obvious. It would equally
> >> important do document, at the uvcvideo doc, what kind of information is
> >> provided via the media_controller and why an userspace application
> >> should care to use it.
> > 
> > First of all, the uvcvideo driver doesn't require application to use the
> > media controller API to operate. All configuration is handled through a
> > V4L2 video device node, and these patches do not modify that. No change
> > is required to applications to use the uvcvideo driver.
> > 
> > There's however a reason why I want to add support for the media
> > controller API to the uvcvideo driver (I wouldn't have submitted the
> > patches otherwise
> > 
> > :-)). UVC-compliant devices are modeled as a connected graph of entities
> > 
> > (called terminals and units in the UVC world). The device topology can be
> > arbitrarily complex (or simple, which is fortunately often the case) and
> > is exported by the device to the host through USB descriptors. The
> > uvcvideo driver parses the descriptor, creates an internal
> > representation of the device internal topology, and maps V4L2 operations
> > to the various entities that the device contains.
> > The UVC specification standardizes a couple of entities (camera terminal,
> > processing unit, ...) and allows device vendors to create vendor-specific
> > entities called extension units (XUs in short). Those XUs are usually
> > used to expose controls that are not standardized by UVC to the host.
> > These controls can be anything from an activity LED to a firmware update
> > system. The uvcvideo tries to map those XU controls to V4L2 controls
> > when it makes sense (and when the controls are documented by the device
> > manufacturer, which is unfortunately often not the case). If an XU
> > control can't be mapped to a V4L2 control, it can be accessed through
> > uvcvideo-specific (documented) ioctls.
> > 
> > In order to access those XU controls, device-specific applications (such
> > as a firmware update application for instance) need to know what XUs are
> > present in the device and possibly how they are connected. That
> > information can't be exported through V4L2. That's why I'm adding media
> > controller support to the uvcvideo driver.
> 
> By allowing access to those undocumented XU controls an Evil
> Manufacturer(tm) could try to sell its own proprietary software that will
> work on Linux where all other software will deadly fail or will produce
> very bad results. We've seen that history before.

We have several alternatives. One of them, that is being shipped in some 
systems, is a uvcvideo driver patched by the Evil Manufacturer(tm), 
incompatible with the mainline version. Another one is a closed-source 
userspace driver based on libusb shipped by the Evil Manufacturer(tm). Yet 
another one is webcams that work on Windows only. Which one do you prefer ?

> That's why I'm concerned a lot about exposing such internal raw interfaces
> to userspace.
>
> It should be noticed that such XU-specific Linux applications will depend
> if the vendor is working on Linux or if somebody else did some reverse
> engineering and discovered (for example) how to upgrade a firmware for a
> certain camera.

The only Evil Manufacturer(tm) I know of that really uses XUs is Logitech. 
They've been quite supportive so far, and have documented at least part of 
their XU controls.

> In the first case, we should simply ask the vendor to document that XU
> control and export it as something else.

Why "something else" ? The XU interface has been designed by the USB-IF to be 
a kernelspace to userspace API. That's how Microsoft, and I think Apple, 
implemented it (it might not be a reference though).

> In the latter case, the developer that did the reverse engineering can just
> send us a patch adding the new V4L control/firmware upgrade logic/whatever
> to us.

UVC is a class specification. I don't want to cripple the driver with tons of 
device-specific code. We already have Apple iSight- and Logitech-specific code 
and way too many quirks for my taste.

> So, I'm yet not convinced ;) In fact, I think we should just deprecate the
> XU private ioctls.

http://www.quickcamteam.net/uvc-h264/USB_Video_Payload_H.264_0.87.pdf

That's a brain-dead proposal for a new H.264 payload format pushed by Logitech 
and Microsoft. The document is a bit outdated, but the final version will 
likely be close. It requires direct XU access from applications. I don't like 
it either, and the alternative will be to not support H.264 UVC cameras at all 
(something I might consider, by blacklisting the product completely). Are you 
ready to refuse supporting large classes of USB hardware ?

> > The media controller has been designed to export the device internal
> > topology to userspace and to make it configurable. That makes it an
> > ideal candidate for the task at hand, which is exporting the device
> > internal topology to userspace. The uvcvideo driver doesn't allow
> > applications to configure the device through the media controller API,
> > so there will be no change for V4L2-only applications.

-- 
Regards,

Laurent Pinchart
