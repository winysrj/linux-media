Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:59095 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0INNsb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 09:48:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 00/11] Media controller (core and V4L2)
Date: Tue, 14 Sep 2010 15:48:29 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009141425.28000.laurent.pinchart@ideasonboard.com> <4C8F79E2.4020604@redhat.com>
In-Reply-To: <4C8F79E2.4020604@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141548.29941.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tuesday 14 September 2010 15:34:26 Mauro Carvalho Chehab wrote:
> Em 14-09-2010 09:25, Laurent Pinchart escreveu:
> > On Thursday 09 September 2010 03:44:15 Mauro Carvalho Chehab wrote:
> >> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> >>> Hi everybody,
> >>> 
> >>> Here's the fourth version of the media controller patches. All comments
> >>> received so far have hopefully been incorporated.
> >>> 
> >>> Compared to the previous version, the patches have been rebased on top
> >>> of 2.6.35 and a MEDIA_IOC_DEVICE_INFO ioctl has been added.
> >>> 
> >>> I won't submit a rebased version of the V4L2 API additions and OMAP3
> >>> ISP patches right now. I will first clean up (and document) the V4L2
> >>> API additions patches, and I will submit them as a proper RFC instead
> >>> of sample code.
> >> 
> >> Hi Laurent,
> >> 
> >> Sorry for a late review on the media controller API. I got flooded by
> >> patches and other work since the merge window.
> > 
> > No worries. I was on holidays last week anyway.
> > 
> >> Anyway, just finished my review, and sent a per-patch comment for most
> >> patches.
> > 
> > Thanks.
> > 
> >> One general comment about it: the userspace API should be documented via
> >> DocBook, to be consistent with V4L2 and DVB API specs.
> > 
> > I feared so :-) I'll work on it.
> > 
> >> It should also be clear at the API specs there that not all media
> >> drivers will implement the media controller API,
> > 
> > I agree.
> > 
> >> as its main focus is to allow better control of SoC devices, where there
> >> are needs to control some intrinsic characteristics of parts of the
> >> devices, complementing the V4L2 spec.
> > 
> > Some consumer devices (ivtv for instance) will also benefit from the
> > media controller, the API is not specific to SoC devices only.
> 
> I'm still in doubt about adding support for it at not so complex hardware
> devices. Yes, there are some consumer devices that can benefit on it, like
> cx25821, where it offers to 16 input/output video streams that can be
> grouped and changed from input into output (as far as I understood). So,
> for such devices, yes, it makes sense to use. But a simpler devices that
> has just one or two stream inputs, alsa and IR, I don't see much sense on
> using it.

The media controller API is also used to find out which audio, dvb, fb, ir and 
v4l devices belong together. Applications such as mythtv are interested in 
that.

> >> This means that it is needed to add some comments at the kernelspace API
> >> doc, saying that the drivers implementing the media controller API are
> >> required to work properly even when userspace is not using the media
> >> controller API;
> > 
> > That's another issue. Drivers should make a best effort to allow pure
> > V4L2 applications to work with a subset of the video device nodes, but
> > they will only offer a subset of the hardware capabilities.
> 
> Ok, but this subset is enough for 99.9% of the cases on non-embedded
> hardware.

Yes, I was thinking about embedded hardware.
 
> > For SoC devices it's even worse, it might be way too difficult to
> > implement support for pure V4L2 applications in the kernel driver(s). In
> > that case a device-specific libv4l plugin will configure the driver using
> > the media controller API for pure V4L2 applications.
> 
> SoC devices used on embedded hardware will have different requirements. I'm
> ok on having an ancillary open source application to help to set the
> device, as we've discussed at Helsinki's meeting, but this should be an
> exception, handled case by case, and not the rule.
> 
> >> This also means that it is needed to add some comments at the userspace
> >> API doc, saying that userspace applications should not assume that
> >> media drivers will implement the media controller API.
> > 
> > Agreed. Many V4L2 drivers will not implement the media controller API.
> > 
> >> So, userspace applications implementing the media controller and V4L2
> >> API's are required to work properly if the device doesn't present a
> >> media controler API interface.
> > 
> > Applications can require support for the media controller API, but they
> > should only do so for specific cases (for instance applications tied to
> > specific SoC hardware, or graphical user interfaces on top of the media
> > controller API similar to qv4l2).
> 
> Yes.
> 
> >> It should also say that no driver should just implement the media
> >> controller API.
> > 
> > I haven't thought about that, as it would be pretty useless :-)
> 
> Well, it doesn't hurt to write it at the spec ;) I won't doubt that people
> might try to merge bad things, abusing on the api, and later saying that
> they have an "open source driver" that it is not open at all. We've seen
> cases like that in the past, where one "open" webcam driver used to work
> only with an specific closed-source userspace application [1]. We need to
> take extra care with any API that might be used to control devices in raw
> mode, as we'll never allow any driver to abuse on it to deny open source
> applications to use it.
> 
> [1] http://marc.info/?l=linux-kernel&m=109356393610149&w=2

-- 
Regards,

Laurent Pinchart
