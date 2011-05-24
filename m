Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54715 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1EXUZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 16:25:39 -0400
Date: Tue, 24 May 2011 23:25:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Message-ID: <20110524202533.GA3266@valkosipuli.localdomain>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com>
 <201105202147.22435.laurent.pinchart@ideasonboard.com>
 <4DD6D69E.2050701@redhat.com>
 <201105240027.37467.laurent.pinchart@ideasonboard.com>
 <4DDBBCED.7090102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDBBCED.7090102@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro and Laurent,

On Tue, May 24, 2011 at 11:13:01AM -0300, Mauro Carvalho Chehab wrote:
> Em 23-05-2011 19:27, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > On Friday 20 May 2011 23:01:18 Mauro Carvalho Chehab wrote:
[clip]
> >> I prefer to ask the vendor about the XU controls that he needs and add a
> >> proper interface for them.
> > 
> > And I would rather having Nvidia documenting their hardware, but that's not 
> > the world we live in :-)
> > 
> > Some XU controls are variable-size binary chunks of data. We can't expose that 
> > as V4L2 controls, which is why I expose them using a documented UVC API.
> 
> The V4L2 API allows string controls.

String controls are zero terminated, aren't they?

XU controls may contain zeros in them; Laurent, please correct me if I'm
wrong.

[clip]
> >>> The only Evil Manufacturer(tm) I know of that really uses XUs is
> >>> Logitech. They've been quite supportive so far, and have documented at
> >>> least part of their XU controls.
> >>
> >> If they're quite supportive, they are not an Evil Manufacturer. We can ask
> >> them to document the XU controls they need and add a proper documented
> >> support for them.
> > 
> > They won't document everything. LED control is documented. Pan/tilt is 
> > documented. Firmware update isn't.
> > 
> > Firmware update can even require a crypto handshake with the device. That's 
> > understandable, as they want to avoid people breaking their devices and 
> > sending them back to tech support.
> 
> A Firmware update should require root access. Normal users/applications should
> not be allowed to touch at the firmware without root access, as otherwise
> some application may damage a device or put some weird stuff there.
> 
> The XU controls (or whatever interface) for firmware upgrade should require
> CAP_SYS_ADMIN. I agree that the vendor should not be required to open the
> firmware upgrade protocol, but it can document what XU controls will be used
> for that, in order for the driver to require the proper security capability bits.

That's true; if the ioctl has a capability to e.g. render the device
unusable then requiring CAP_SYS_ADMIN is a good idea.

[clip]
> >>> Why "something else" ? The XU interface has been designed by the USB-IF
> >>> to be a kernelspace to userspace API. That's how Microsoft, and I think
> >>> Apple, implemented it (it might not be a reference though).
> >>>
> >>>> In the latter case, the developer that did the reverse engineering can
> >>>> just send us a patch adding the new V4L control/firmware upgrade
> >>>> logic/whatever to us.
> >>>
> >>> UVC is a class specification. I don't want to cripple the driver with
> >>> tons of device-specific code. We already have Apple iSight- and
> >>> Logitech-specific code and way too many quirks for my taste.
> >>
> >> Unfortunately, by being a generic driver for an USB class, and with vendors
> >> not quite following the specs, there's no way to avoid having
> >> device-specific stuff there. Other similar drivers like snd-usb-audio and
> >> sound hda driver has lots of quirks. In particular, the hda driver
> >> contains more lines to the patch-*.c drivers (with the device-specific
> >> stuff) than the driver core:
> >>
> >> $ wc -l sound/pci/hda/*.c
> >>     267 sound/pci/hda/hda_beep.c
> >>    5072 sound/pci/hda/hda_codec.c
> >>     637 sound/pci/hda/hda_eld.c
> >>    1084 sound/pci/hda/hda_generic.c
> >>     818 sound/pci/hda/hda_hwdep.c
> >>    2854 sound/pci/hda/hda_intel.c
> >>     727 sound/pci/hda/hda_proc.c
> >>    4988 sound/pci/hda/patch_analog.c
> >>     572 sound/pci/hda/patch_ca0110.c
> >>    1314 sound/pci/hda/patch_cirrus.c
> >>     776 sound/pci/hda/patch_cmedia.c
> >>    3905 sound/pci/hda/patch_conexant.c
> >>    1749 sound/pci/hda/patch_hdmi.c
> >>   20167 sound/pci/hda/patch_realtek.c
> >>     335 sound/pci/hda/patch_si3054.c
> >>    6434 sound/pci/hda/patch_sigmatel.c
> >>    6107 sound/pci/hda/patch_via.c
> >>   57806 total
> >>
> >> Yeah, device-specific stuff sucks, but sometimes there's no way to properly
> >> support a device.
> > 
> > Luckily there are proper ways to support UVC XUs, by exposing them to 
> > userspace :-)
> 
> This is not the proper way. If you get a Realtek audio device (the biggest one 
> from the list above), it will just works, as kernelspace will abstract the 
> hardware for you.
> 
> However, if you move patch_realtek to userspace, the driver would not work
> without a Realtek specific stuff in userspace, that could eventually be
> closed source.
> 
> We should never allow such things, otherwise we'll be distrying
> the open source ecosystem.

I fully agree with this: the driver definitely needs to provide a high level
interface on V4L2 node when reasonably possible. I think it would make sense
to provide XU controls that could be used for firmware update and require
SYS_CAP_ADMIN. Then regular applications couldn't access the XU interface,
be it firmware update or something else.

For what it's worth, the Linux kernel supports register level access to I2C
devices from user space --- see Documentation/i2c/dev-interface. Thia
interface is used seldom (as far as I know) due to obvious advantages of
higher level interfaces. I think the UVC XU controls are both conceptually
and in purpose very similar to this.

Kind regards,
Sakari

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
