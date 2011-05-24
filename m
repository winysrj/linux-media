Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52935 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1EXM3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:29:40 -0400
Date: Tue, 24 May 2011 15:29:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Message-ID: <20110524122933.GC1768@valkosipuli.localdomain>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com>
 <201105201749.27977.laurent.pinchart@ideasonboard.com>
 <4DD6BE21.30605@redhat.com>
 <201105202147.22435.laurent.pinchart@ideasonboard.com>
 <4DD6D69E.2050701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD6D69E.2050701@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro and Laurent,

On Fri, May 20, 2011 at 06:01:18PM -0300, Mauro Carvalho Chehab wrote:
> Em 20-05-2011 16:47, Laurent Pinchart escreveu:
[clip]
> >> By allowing access to those undocumented XU controls an Evil
> >> Manufacturer(tm) could try to sell its own proprietary software that will
> >> work on Linux where all other software will deadly fail or will produce
> >> very bad results. We've seen that history before.
> 
> As you're putting some names, let me be clearer. In the past we had bad stuff
> like this one:
> 	http://kerneltrap.org/node/3729
> 
> that ended by the need of somebody to rewrite the entire pwc driver, because
> the only way to get a decent image using a Philips camera, with the 
> "open source" driver were to run a closed-source binary.
> 
> undocumented controls that can do everything, as you said, can create a
> similar situation to what we had in the past.
> 
> > We have several alternatives. One of them, that is being shipped in some 
> > systems, is a uvcvideo driver patched by the Evil Manufacturer(tm), 
> > incompatible with the mainline version. Another one is a closed-source 
> > userspace driver based on libusb shipped by the Evil Manufacturer(tm). Yet 
> > another one is webcams that work on Windows only. Which one do you prefer ?
> 
> I prefer to ask the vendor about the XU controls that he needs and add a proper
> interface for them.

As the UVC standard allows implementing custom functionality in a standard
way (UVC), I wouldn't necessarily prevent using that. I definitely agree
that the XU functionality should be properly documented by vendors, and what
can be supported using a standardised interface must be.

[clip]

> > Why "something else" ? The XU interface has been designed by the USB-IF to be 
> > a kernelspace to userspace API. That's how Microsoft, and I think Apple, 
> > implemented it (it might not be a reference though).
> > 
> >> In the latter case, the developer that did the reverse engineering can just
> >> send us a patch adding the new V4L control/firmware upgrade logic/whatever
> >> to us.
> > 
> > UVC is a class specification. I don't want to cripple the driver with tons of 
> > device-specific code. We already have Apple iSight- and Logitech-specific code 
> > and way too many quirks for my taste.
> 
> Unfortunately, by being a generic driver for an USB class, and with vendors not
> quite following the specs, there's no way to avoid having device-specific stuff
> there. Other similar drivers like snd-usb-audio and sound hda driver has lots
> of quirks. In particular, the hda driver contains more lines to the patch-*.c
> drivers (with the device-specific stuff) than the driver core:
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

In this case the functionality the hardware provides is rather well defined
--- audio streams and a set of mixer controls. It's just the implementation
which varies, but that can still be made fit behind a standard interface
which provides standardised functionality for the applications.

In the case of the UVC hardware, there's a standard which is mostly followed
relatively well by vendors. What likely cannot be standardised is, for
example, the firmware update for Logitech webcams mentioned above, which the
UVC standard still allows. This will stay specific to Logitech devices
probably forever.

As far as I understand, this discussion isn't really even related to the
patchset. The XU access is still provided to user space without the
patchset.

> >> So, I'm yet not convinced ;) In fact, I think we should just deprecate the
> >> XU private ioctls.
> > 
> > http://www.quickcamteam.net/uvc-h264/USB_Video_Payload_H.264_0.87.pdf
> > 
> > That's a brain-dead proposal for a new H.264 payload format pushed by Logitech 
> > and Microsoft. The document is a bit outdated, but the final version will 
> > likely be close. It requires direct XU access from applications. I don't like 
> > it either, and the alternative will be to not support H.264 UVC cameras at all 
> > (something I might consider, by blacklisting the product completely). Are you 
> > ready to refuse supporting large classes of USB hardware ?
> 
> What's the difference between:
> 	1) exposing XU access to userspace and having no applications using it;
> 	2) just blacklisting them.
> 
> The end result is the same.

I think that in this case it wouldn't be a choice between the two, but 1)
being "exposing XU access to user space and requiring applications to
support that". This case is documented, unlike the firmware update, and does
not have anything to do with the XU ioctl interface --- the only connection
to XUs is that the user needs to know that an XU is there to interpret the
image data in a certain way. The "user" in this case could be libv4l, so
that the applications wouldn't need to care.

This is a class of UVC hardware as far as I understand, and Logitech being a
major vendor there will likely be a bunch of those devices. My wish is still
that a proper spec will be written before anyone starts manufacturing those
in large quantities. :-)

Regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
