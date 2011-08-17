Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1HQGOP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 02:14:15 -0400
Message-ID: <4E4B5C27.3000008@redhat.com>
Date: Tue, 16 Aug 2011 23:13:59 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Embedded device and the  V4L2 API support - Was: [GIT PATCHES FOR
 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <201108151430.42722.laurent.pinchart@ideasonboard.com> <4E49B60C.4060506@redhat.com> <201108161057.57875.laurent.pinchart@ideasonboard.com> <4E4A8D27.1040602@redhat.com> <4E4AE583.6050308@gmail.com>
In-Reply-To: <4E4AE583.6050308@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that there are too many miss understandings or maybe we're just
talking the same thing on different ways.

So, instead of answering again, let's re-start this discussion on a
different way.

One of the requirements that it was discussed a lot on both mailing
lists and on the Media Controllers meetings that we had (or, at least
in the ones where I've participated) is that:

	"A pure V4L2 userspace application, knowing about video device
	 nodes only, can still use the driver. Not all advanced features 
	 will be available."

This is easily said than done. Also, different understandings can be
obtained by a simple phrase like that.

The solution for this problem is to make a compliance profile that
drivers need to implement. We should define such profile, change
the existing drivers to properly implement it and enforce it for the
newcoming drivers.

Btw, I think we should also work on a profile for other kinds of hardware
as well, but the thing is that, as some things can now be implemented
using two different API's, we need to define the minimal requirements
for the V4L2 implementation.


For me, the above requirement means that, at least, the following features
need to be present:

1) The media driver should properly detect the existing hardware and
should expose the available sensors for capture via the V4L2 API.

For hardware development kits, it should be possible to specify the
hardware sensor(s) at runtime via some tool at the v4l-utils tree 
(or on another tree hosted at linuxtv.org or clearly indicated at
the Kernel tree Documentation files) or via a modprobe parameter.

2) Different sensors present at the hardware may be exposed either
via S_INPUT or, if they're completely independent, via two different
node interface;

3) The active sensor basic controls to adjust color, bright, aperture time
and exposition time, if the hardware directly supports them;

4) The driver should implement the streaming ioctls and/or the read() method;

5) It should be possible to configure the frame rate, if the sensor supports it;

6) It should be possible to configure the crap area, if the sensor supports it.

7) It should be possible to configure the format standard and resolution

...
(the above list is not exhaustive. It is just a few obvious things that are
clear to me - I'm almost sure that I've forgot something).

We'll also end by having some optional requirements, like the DV timings ioctls
that also needs to be covered by the SoC hardware profile.

In practice, the above requirements should be converted into a list of features
and ioctl's that needs to be implemented on every SoC driver that implements
a capture or output video streaming device.

My suggestion is that we should start the discussions by filling the macro
requirements. Once we agree on that, we can make a list of the V4L and MC
ioctl's and convert them into a per-ioctl series of requirements.

Regards,
Mauro


