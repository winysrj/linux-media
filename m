Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39359 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab1JEXOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 19:14:50 -0400
Date: Thu, 6 Oct 2011 02:14:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
Message-ID: <20111005231445.GC8614@valkosipuli.localdomain>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <201110032344.08963.laurent.pinchart@ideasonboard.com>
 <4E8A2F76.4020209@infradead.org>
 <201110052208.00714.laurent.pinchart@ideasonboard.com>
 <4E8CCF07.2010400@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8CCF07.2010400@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Oct 05, 2011 at 06:41:27PM -0300, Mauro Carvalho Chehab wrote:
> Em 05-10-2011 17:08, Laurent Pinchart escreveu:
[clip]
> >The pad-level API doesn't replace the V4L2 API, it complements it. I'm of
> >course not advocating modifying any driver to replace V4L2 ioctls by direct
> >subdev access. However, the pad-level API needs to be exposed to userspace, as
> >some harware simply can't be configured through a video node only.
> >
> >As Hans also mentionned in his reply, the pad-level API is made of two parts:
> >an in-kernel API made of subdev operations, and a userspace API accessed
> >through ioctls. As the userspace API is needed for some devices, the kernel
> >API needs to be implemented by drivers. We should phase out the non pad-level
> >format operations in favor of pad-level operations, as the former can be
> >implemented using the later. That has absolutely no influence on the userspace
> >API.
> 
> What I'm seeing is that:
> 	- the drivers that are implementing the MC/pad API's aren't
> compatible with generic V4L2 applications;

This is currently true up to a certain degree; you'll need to configure such
devices using media-ctl at least. Even then, such embedded systems do often
have automatic exposure and white balance algorithms above the V4L2 (often
proprietary implementations).

To be really useful for a regular user, such algorithms would also be
needed.

The two problems are separate but they still both need to be resolved to be
able to use general purpose V4L2 applications on such systems in a
meaningful way.

> 	- there's no way to write a generic application that works with all
> drivers, even implementing MC/pad API's there as each driver is taking different
> a approach on how to map things at the different API's, and pipeline configuration
> is device-dependent;

The pipeline configuration is device specific but the interfaces are not.
Thus it's possible to write a generic plugin which configures the device.

The static configuration can be kept in a text file in the first phase and
later on hints may be added for synamic configuration on e.g. where digital
gain, scaling and cropping should be performed and which resolutions to
advertise in enum_framesizes.

But we do not have such plugin yet.

> 	- there's no effort to publish patches to libv4l to match the changes
> at the kernel driver.

I'd prefer concentrating all efforts towards a single, generic plugin. As
noted before, a plugin for OMAP 3 ISP exists, but I don't think it does
anything a generic plugin couldn't do, so it hasn't been merged.

I'm working on patches to move the text-based pipeline configuration to
libmediactl and libv4l2subdev and will post them to the list in the coming
few days, among with a few other improvements. This is one of the first
required steps towards such generic plugin.

Unfortunately I haven't been able to use much of my time on this; help would
indeed be appreciated from any interested party.

[clip]

> I'm fine on providing raw interfaces, just like we have for some types of device
> (like the block raw interfaces used by CD-ROM drivers) as a bonus, but this should
> never replace an API where an application developed by a third party could work
> with all media hardware, without needing hardware specific details.

I agree.

[clip]

> >>>>If the application wants a different image resolution, it will use
> >>>>S_FMT. In this case, what userspace expects is that the driver will
> >>>>scale, if supported, or return -EINVAL otherwise.
> >>>
> >>>With the OMAP3 ISP, which is I believe what Javier was asking about, the
> >>>application will set the format on the OMAP3 ISP resizer input and output
> >>>pads to configure scaling.
> >>
> >>The V4L2 API doesn't tell where a function like scaler will be implemented.
> >>So, it is fine to implement it at tvp5151 or at the omap3 resizer, when a
> >>V4L2 call is sent.
> >
> >By rolling a dice ? :-)
> 
> By using good sense. I never had a case where I had doubts about where the
> scaling should be implemented on the drivers I've coded. For omap3/tvp5151, the
> decision is also clear: it should be done at the bridge (omap3) resizer, as the
> demod doesn't support scaling.

Good sense in this case would require knowledge of the tv tuner in the
camera ISP driver. One could also, and actually does, connect sensors which
can do scaling in two steps to the same ISP. How does the ISP driver now
know where to do scaling?

OMAP 3 ISP as such is a relatively simple one; there are ISPs which have two
scalers and ability to write the image to memory also in between the two.

I don't think a driver, be that tv tuner / sensor or ISP driver, has enough
information to perform the pipeline configuration which is mandatory to
implement the standard V4L2 ioctls for e.g. format setting and cropping. We
actually had such an implementation of the OMAP 3 ISP driver around 2009
(but without MC or V4L2 subdevs, still the underlying technical issues are
the same) and it was a disaster. The patches were posted to linux-media a
few times back then if you're interested. It was evident something had to be
done, and now we have the Media controller and V4L2 subdev user space APIs.

I want to reiterate that I'm very much in favour of supporting generic V4L2
applications on these devices. The additional support that these application
need on top of the drivers requires making policy decisions that
applications intended for embedded devices (such as Fcam) often run on
embedded devices need to make themselves. To support both using the same
drivers, these policy decisions must be taken in the user space, not in the
kernel. In my opinion libv4l is in perfect spot to fill this gap.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
