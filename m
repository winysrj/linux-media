Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57226 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1EWW1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 18:27:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Tue, 24 May 2011 00:27:37 +0200
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105202147.22435.laurent.pinchart@ideasonboard.com> <4DD6D69E.2050701@redhat.com>
In-Reply-To: <4DD6D69E.2050701@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105240027.37467.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Friday 20 May 2011 23:01:18 Mauro Carvalho Chehab wrote:
> Em 20-05-2011 16:47, Laurent Pinchart escreveu:
> > On Friday 20 May 2011 21:16:49 Mauro Carvalho Chehab wrote:
> >> Em 20-05-2011 12:49, Laurent Pinchart escreveu:
> >>> On Friday 20 May 2011 17:32:45 Mauro Carvalho Chehab wrote:
> >>>> Em 15-05-2011 04:48, Laurent Pinchart escreveu:
> >>>>> Hi Mauro,
> >>>>> 
> >>>>> The following changes since commit
> >>> 
> >>> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> >>>>>   [media] DVB: return meaningful error codes in dvb_frontend
> >>>>>   (2011-05-09 05:47:20 +0200)
> >>>>> 
> >>>>> are available in the git repository at:
> >>>>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> >>>>> 
> >>>>> They replace the git pull request I've sent on Thursday with the same
> >>>>> subject.

[snip]

> >>>>> Laurent Pinchart (4):
> >>>>>       v4l: Release module if subdev registration fails
> >>>>>       uvcvideo: Register a v4l2_device
> >>>>>       uvcvideo: Register subdevices for each entity
> >>>>>       uvcvideo: Connect video devices to media entities
> >>>> 
> >>>> We've discussed already about using the media controller for uvcvideo,
> >>>> but I can't remember anymore what where your aguments in favor of
> >>>> merging it (and, even if I've remembered it right now, the #irc
> >>>> channel log is not the proper way to document the rationale to apply
> >>>> a patch).
> >>>> 
> >>>> The thing is: it is clear that SoC embedded devices need the media
> >>>> controller, as they have IP blocks that do weird things, and userspace
> >>>> may need to access those, as it is not possible to control such IP
> >>>> blocks using the V4L2 API.
> >>>> 
> >>>> However, I have serious concerns about media_controller API usage on
> >>>> generic drivers, as it is required that all drivers should be fully
> >>>> configurable via V4L2 API alone, otherwise we'll have regressions, as
> >>>> no generic applications use the media_controller.
> >>>> 
> >>>> In other words, if you have enough arguments about why we should add
> >>>> media_controller support at the uvcvideo, please clearly provide them
> >>>> at the patch descriptions, as this is not obvious. It would equally
> >>>> important do document, at the uvcvideo doc, what kind of information
> >>>> is provided via the media_controller and why an userspace application
> >>>> should care to use it.
> >>> 
> >>> First of all, the uvcvideo driver doesn't require application to use
> >>> the media controller API to operate. All configuration is handled
> >>> through a V4L2 video device node, and these patches do not modify
> >>> that. No change is required to applications to use the uvcvideo
> >>> driver.
> >>> 
> >>> There's however a reason why I want to add support for the media
> >>> controller API to the uvcvideo driver (I wouldn't have submitted the
> >>> patches otherwise
> >>> 
> >>> :-)). UVC-compliant devices are modeled as a connected graph of
> >>> :entities
> >>> 
> >>> (called terminals and units in the UVC world). The device topology can
> >>> be arbitrarily complex (or simple, which is fortunately often the
> >>> case) and is exported by the device to the host through USB
> >>> descriptors. The uvcvideo driver parses the descriptor, creates an
> >>> internal
> >>> representation of the device internal topology, and maps V4L2
> >>> operations to the various entities that the device contains.
> >>> The UVC specification standardizes a couple of entities (camera
> >>> terminal, processing unit, ...) and allows device vendors to create
> >>> vendor-specific entities called extension units (XUs in short). Those
> >>> XUs are usually used to expose controls that are not standardized by
> >>> UVC to the host. These controls can be anything from an activity LED
> >>> to a firmware update system. The uvcvideo tries to map those XU
> >>> controls to V4L2 controls when it makes sense (and when the controls
> >>> are documented by the device manufacturer, which is unfortunately
> >>> often not the case). If an XU control can't be mapped to a V4L2
> >>> control, it can be accessed through uvcvideo-specific (documented)
> >>> ioctls.
> >>> 
> >>> In order to access those XU controls, device-specific applications
> >>> (such as a firmware update application for instance) need to know what
> >>> XUs are present in the device and possibly how they are connected.
> >>> That information can't be exported through V4L2. That's why I'm adding
> >>> media controller support to the uvcvideo driver.
> >> 
> >> By allowing access to those undocumented XU controls an Evil
> >> Manufacturer(tm) could try to sell its own proprietary software that
> >> will work on Linux where all other software will deadly fail or will
> >> produce very bad results. We've seen that history before.
> 
> As you're putting some names, let me be clearer. In the past we had bad
> stuff like this one:
> 	http://kerneltrap.org/node/3729
> 
> that ended by the need of somebody to rewrite the entire pwc driver,
> because the only way to get a decent image using a Philips camera, with
> the "open source" driver were to run a closed-source binary.

I clearly remember that, and I think you know that I'm a strong advocate of 
open-source drivers (right ? :-)).

> undocumented controls that can do everything, as you said, can create a
> similar situation to what we had in the past.

The situation with the pwc driver was very different. The open-source driver 
was designed for the closed-source module. That's not at all what I'm 
proposing for the uvcvideo driver.

Furthermore, implementing proprietary closed-source drivers will always be 
possible, and can already be done for UVC devices with libusb. We're thus not 
talking about opening the door to possible (and, I believe, very unlikely) 
proprietary Linux drivers for UVC devices.

UVC compliance, using the Microsoft driver, is a requirement for webcams to 
receive the "designed for Windows Vista/7" certification. Vendors are thus not 
trying to push all kind of proprietary, non UVC-compliant features for their 
devices (most of them don't have the necessary resources to implement a custom 
UVC driver).

Can you imagine a vendor looking at the Linux driver, seeing that UVC XUs can 
be accessed directly, and then deciding to design their hardware based on that 
? I can't :-) XUs are accessible in Windows through a documented API. If 
vendors want to design devices that expose XU controls, they will do it, 
regardless of whether Linux implements support for that or not.

> > We have several alternatives. One of them, that is being shipped in some
> > systems, is a uvcvideo driver patched by the Evil Manufacturer(tm),
> > incompatible with the mainline version. Another one is a closed-source
> > userspace driver based on libusb shipped by the Evil Manufacturer(tm).
> > Yet another one is webcams that work on Windows only. Which one do you
> > prefer ?
> 
> I prefer to ask the vendor about the XU controls that he needs and add a
> proper interface for them.

And I would rather having Nvidia documenting their hardware, but that's not 
the world we live in :-)

Some XU controls are variable-size binary chunks of data. We can't expose that 
as V4L2 controls, which is why I expose them using a documented UVC API.

> >> That's why I'm concerned a lot about exposing such internal raw
> >> interfaces to userspace.
> >> 
> >> It should be noticed that such XU-specific Linux applications will
> >> depend if the vendor is working on Linux or if somebody else did some
> >> reverse engineering and discovered (for example) how to upgrade a
> >> firmware for a certain camera.
> > 
> > The only Evil Manufacturer(tm) I know of that really uses XUs is
> > Logitech. They've been quite supportive so far, and have documented at
> > least part of their XU controls.
> 
> If they're quite supportive, they are not an Evil Manufacturer. We can ask
> them to document the XU controls they need and add a proper documented
> support for them.

They won't document everything. LED control is documented. Pan/tilt is 
documented. Firmware update isn't.

Firmware update can even require a crypto handshake with the device. That's 
understandable, as they want to avoid people breaking their devices and 
sending them back to tech support.

> >> In the first case, we should simply ask the vendor to document that XU
> >> control and export it as something else.
> 
> s/something else/other controls/
> 
> (that line got mangled when I've removed another phase from the sentence
> while editing it)

It's not just a matter of exposing controls, see my comment below about the 
new UVC H.264 spec.

> > Why "something else" ? The XU interface has been designed by the USB-IF
> > to be a kernelspace to userspace API. That's how Microsoft, and I think
> > Apple, implemented it (it might not be a reference though).
> > 
> >> In the latter case, the developer that did the reverse engineering can
> >> just send us a patch adding the new V4L control/firmware upgrade
> >> logic/whatever to us.
> > 
> > UVC is a class specification. I don't want to cripple the driver with
> > tons of device-specific code. We already have Apple iSight- and
> > Logitech-specific code and way too many quirks for my taste.
> 
> Unfortunately, by being a generic driver for an USB class, and with vendors
> not quite following the specs, there's no way to avoid having
> device-specific stuff there. Other similar drivers like snd-usb-audio and
> sound hda driver has lots of quirks. In particular, the hda driver
> contains more lines to the patch-*.c drivers (with the device-specific
> stuff) than the driver core:
> 
> $ wc -l sound/pci/hda/*.c
>     267 sound/pci/hda/hda_beep.c
>    5072 sound/pci/hda/hda_codec.c
>     637 sound/pci/hda/hda_eld.c
>    1084 sound/pci/hda/hda_generic.c
>     818 sound/pci/hda/hda_hwdep.c
>    2854 sound/pci/hda/hda_intel.c
>     727 sound/pci/hda/hda_proc.c
>    4988 sound/pci/hda/patch_analog.c
>     572 sound/pci/hda/patch_ca0110.c
>    1314 sound/pci/hda/patch_cirrus.c
>     776 sound/pci/hda/patch_cmedia.c
>    3905 sound/pci/hda/patch_conexant.c
>    1749 sound/pci/hda/patch_hdmi.c
>   20167 sound/pci/hda/patch_realtek.c
>     335 sound/pci/hda/patch_si3054.c
>    6434 sound/pci/hda/patch_sigmatel.c
>    6107 sound/pci/hda/patch_via.c
>   57806 total
> 
> Yeah, device-specific stuff sucks, but sometimes there's no way to properly
> support a device.

Luckily there are proper ways to support UVC XUs, by exposing them to 
userspace :-)

> >> So, I'm yet not convinced ;) In fact, I think we should just deprecate
> >> the XU private ioctls.
> > 
> > http://www.quickcamteam.net/uvc-h264/USB_Video_Payload_H.264_0.87.pdf
> > 
> > That's a brain-dead proposal for a new H.264 payload format pushed by
> > Logitech and Microsoft. The document is a bit outdated, but the final
> > version will likely be close. It requires direct XU access from
> > applications. I don't like it either, and the alternative will be to not
> > support H.264 UVC cameras at all (something I might consider, by
> > blacklisting the product completely). Are you ready to refuse supporting
> > large classes of USB hardware ?
> 
> What's the difference between:
> 	1) exposing XU access to userspace and having no applications using it;
> 	2) just blacklisting them.
> 
> The end result is the same.

Why would there be no applications using it ? The UVC H.264 XUs are documented 
in the above spec, so application can use them.

> The V4L2 API is capable of handling H.264 payload format.
> 
> So, between the two above alternatives, I would choose 3:
> 	- to handle such XU access internally at the driver.

You should read the above spec. It used MJPEG as a container format and embeds 
YUV and H.264 payloads in the MJPEG headers, most of the time without any 
actual MJPEG data after the header. This needs to be configured an 
demultiplexed in software, and it's a mess. We don't want to implement that in 
the kernel. To support this, the proper solution is 3:

- implement a libv4l plugin that uses the UVC XU API.

-- 
Regards,

Laurent Pinchart
