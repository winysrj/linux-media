Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:56459 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab1HKKQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 06:16:44 -0400
Date: Thu, 11 Aug 2011 13:16:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Message-ID: <20110811101638.GE5926@valkosipuli.localdomain>
References: <4E398381.4080505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E398381.4080505@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

On Wed, Aug 03, 2011 at 02:21:05PM -0300, Mauro Carvalho Chehab wrote:
> As already announced, we're continuing the planning for this year's 
> media subsystem workshop.
> 
> To avoid overriding the main ML with workshop-specifics, a new ML
> was created:
> 	workshop-2011@linuxtv.org
> 
> I'll also be updating the event page at:
> 	http://www.linuxtv.org/events.php
> 
> Over the one-year period, we had 242 developers contributing to the
> subsystem. Thank you all for that! Unfortunately, the space there is
> limited, and we can't affort to have all developers there. 
> 
> Due to that some criteria needed to be applied to create a short list
> of people that were invited today to participate. 
> 
> The main criteria were to select the developers that did significant 
> contributions for the media subsystem over the last 1 year period, 
> measured in terms of number of commits and changed lines to the kernel
> drivers/media tree.
> 
> As the used criteria were the number of kernel patches, userspace-only 
> developers weren't included on the invitations. It would be great to 
> have there open source application developers as well, in order to allow 
> us to tune what's needed from applications point of view. 
> 
> So, if you're leading the development of some V4L and/or DVB open-source 
> application and wants to be there, or you think you can give good 
> contributions for helping to improve the subsystem, please feel free 
> to send us an email.
> 
> With regards to the themes, we're received, up to now, the following 
> proposals:
> 
> ---------------------------------------------------------+----------------------
> THEME                                                    | Proposed-by:
> ---------------------------------------------------------+----------------------
> Buffer management: snapshot mode                         | Guennadi
> Rotation in webcams in tablets while streaming is active | Hans de Goede
> V4L2 Spec ??? ambiguities fix                              | Hans Verkuil
> V4L2 compliance test results                             | Hans Verkuil
> Media Controller presentation (probably for Wed, 25)     | Laurent Pinchart
> Workshop summary presentation on Wed, 25                 | Mauro Carvalho Chehab
> ---------------------------------------------------------+----------------------
> 
> From my side, I also have the following proposals:
> 
> 1) DVB API consistency - what to do with the audio and video DVB API's 
> that conflict with V4L2 and (somewhat) with ALSA?
> 
> 2) Multi FE support - How should we handle a frontend with multiple 
> delivery systems like DRX-K frontend?
> 
> 3) videobuf2 - migration plans for legacy drivers
> 
> 4) NEC IR decoding - how should we handle 32, 24, and 16 bit protocol
> variations?
> 
> Even if you won't be there, please feel free to propose themes for 
> discussion, in order to help us to improve even more the subsystem.

Drawing from our recent discussions over e-mail, I would like to add another
topic: the V4L2 on desktop vs. embedded systems.

The V4L2 is being used as an application interface on desktop systems, but
recently as support has been added to complex camera ISPs in embedded
systems it is used for a different purpose: it's a much lower level
interface for specialised user space which typically contains a middleware
layer which provides its own application interface (e.g. GSTphotography).
The V4L2 API in the two different kind of systems is exactly the same but
its role is different: the hardware drivers are not up to offering an
interface suitable for the use by general purpose applications.

To run generic purpose applications on such embedded systems, I have
promoted the use of libv4l (either plain or with plugins) to provide what is
missing from between the V4L2, Media controller and v4l2_subdev interfaces
provided by kernel drivers --- which mostly allow controlling the hardware
--- and what the general purpose applications need. Much of the missing
functionality is usually implemented in algorithm frameworks and libraries
that do not fit to kernel space: they are complex and often the algorithms
themselves are under very restrictive licenses. There is an upside: the
libv4l does contain an automatic exposure and a white balance algorithm
which are suitable for some use cases.

Defining functionality suitable for general purpose applications at the
level of V4L2 requires scores of policy decisions on embedded systems. One
of the examples is the pipeline configuration for which the Media controller
and v4l2_subdev interfaces are currently being used for. Applications such
as Fcam <URL:http://fcam.garage.maemo.org/> do need to make these policy
decisions by themselves. For this reason, I consider it highly important
that the low level hardware control interface is available to the user space
applications.

I think it is essential for the future support of such embedded devices in
the mainline kernel to come to a common agreement on how this kind of
systems should be implemented in a way that everyone's requirements are best
taken into account. I believe this is in everyone's interest.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
