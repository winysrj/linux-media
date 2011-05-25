Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44005 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1EYXUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 19:20:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Thu, 26 May 2011 01:20:54 +0200
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105240027.37467.laurent.pinchart@ideasonboard.com> <4DDBBCED.7090102@redhat.com>
In-Reply-To: <4DDBBCED.7090102@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105260120.54392.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Thanks for applying the patches. For the record, the compromise was to 
implement XU controls filtering to make sure that userspace applications won't 
have access to potentially dangerous controls, and to push vendors to properly 
document their XUs.

On Tuesday 24 May 2011 16:13:01 Mauro Carvalho Chehab wrote:
> Em 23-05-2011 19:27, Laurent Pinchart escreveu:
> > On Friday 20 May 2011 23:01:18 Mauro Carvalho Chehab wrote:
> >> Em 20-05-2011 16:47, Laurent Pinchart escreveu:
> >>> On Friday 20 May 2011 21:16:49 Mauro Carvalho Chehab wrote:

[snip]

> > UVC compliance, using the Microsoft driver, is a requirement for webcams
> > to receive the "designed for Windows Vista/7" certification. Vendors are
> > thus not trying to push all kind of proprietary, non UVC-compliant
> > features for their devices (most of them don't have the necessary
> > resources to implement a custom UVC driver).
> 
> If you look on how MCE remote controllers are implemented, you'll see that
> this is a really bad example. I was told by one of the MCE manufacturers
> that even them don't know the MCE protocol used there. Microsoft doesn't
> care about open specs. They only care about having the device working with
> their drivers.

Oh, for sure. That's why many UVC devices crash when you send them requests 
that are not used by the Windows UVC driver. Some vendors (namely Logitech) 
started testing their devices on Linux, hopefully that trend will catch up.

My point was that, as devices need to work with the Windows UVC drivers, many 
manufacturers will not add non-compliant, undocumented features to their 
devices as they don't have the resources to implement a custom UVC driver. 
Bigger vendors still do that though.

> > Can you imagine a vendor looking at the Linux driver, seeing that UVC XUs
> > can be accessed directly, and then deciding to design their hardware
> > based on that ? I can't :-) XUs are accessible in Windows through a
> > documented API. If vendors want to design devices that expose XU
> > controls, they will do it, regardless of whether Linux implements
> > support for that or not.
> 
> It is to fragile to assume that. At Windows, vendors write their own
> drivers, and are allowed to do whatever they want on a closed source.

For proprietary protocols that what happens. For UVC the situation is a bit 
better, as the Microsoft UVC driver is widely used nowadays. The Windows 
driver model allows vendors to write filter drivers though, so I agree that 
they can add support for proprietary device features.

> >>> We have several alternatives. One of them, that is being shipped in
> >>> some systems, is a uvcvideo driver patched by the Evil
> >>> Manufacturer(tm), incompatible with the mainline version. Another one
> >>> is a closed-source userspace driver based on libusb shipped by the
> >>> Evil Manufacturer(tm). Yet another one is webcams that work on Windows
> >>> only. Which one do you prefer ?
> >> 
> >> I prefer to ask the vendor about the XU controls that he needs and add a
> >> proper interface for them.
> > 
> > And I would rather having Nvidia documenting their hardware, but that's
> > not the world we live in :-)
> > 
> > Some XU controls are variable-size binary chunks of data. We can't expose
> > that as V4L2 controls, which is why I expose them using a documented UVC
> > API.
> 
> The V4L2 API allows string controls.

Hans was very much against using string controls to pass raw binary data.

[snip]

> >> Unfortunately, by being a generic driver for an USB class, and with
> >> vendors not quite following the specs, there's no way to avoid having
> >> device-specific stuff there. Other similar drivers like snd-usb-audio
> >> and sound hda driver has lots of quirks. In particular, the hda driver
> >> contains more lines to the patch-*.c drivers (with the device-specific
> >> stuff) than the driver core:

[snip]

> >>>> So, I'm yet not convinced ;) In fact, I think we should just deprecate
> >>>> the XU private ioctls.
> >>> 
> >>> http://www.quickcamteam.net/uvc-h264/USB_Video_Payload_H.264_0.87.pdf
> >>> 
> >>> That's a brain-dead proposal for a new H.264 payload format pushed by
> >>> Logitech and Microsoft. The document is a bit outdated, but the final
> >>> version will likely be close. It requires direct XU access from
> >>> applications. I don't like it either, and the alternative will be to
> >>> not support H.264 UVC cameras at all (something I might consider, by
> >>> blacklisting the product completely). Are you ready to refuse
> >>> supporting large classes of USB hardware ?
> >> 
> >> What's the difference between:
> >> 	1) exposing XU access to userspace and having no applications using it;
> >> 	2) just blacklisting them.
> >> 
> >> The end result is the same.
> > 
> > Why would there be no applications using it ? The UVC H.264 XUs are
> > documented in the above spec, so application can use them.
> 
> The Linux kernel were designed to abstract hardware differences. We should
> not move this task to userspace.

I agree in principle, but we will have to rethink this at some point in the 
future. I don't think it will always be possible to handle all hardware 
abstractions in the kernel. Some hardware require floating point operations in 
their drivers for instance.

There's an industry trend there, and we need to think about solutions now 
otherwise we will be left without any way forward when too many devices will 
be impossible to support from kernelspace (OMAP4 is a good example there, some 
device drivers require communication with other cores, and the communication 
API is implemented in userspace).

[snip]

-- 
Regards,

Laurent Pinchart
