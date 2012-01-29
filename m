Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50571 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2A2SGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 13:06:46 -0500
Date: Sun, 29 Jan 2012 20:06:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	g.liakhovetski@gmx.de, teturtia@gmail.com
Subject: [RFC] More on subdev selections API: composition
Message-ID: <20120129180641.GA16140@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I had a discussion with Tomasz a few days ago on the selection API and how
the composition fits to the proposal I made some time ago. I understand that
in V4L2 API the composition bounds rectangle, onto which the scaled images
are composed, is static in size. This makes no sense for subdevs as far as I
can see.

In composition use cases there are also more than one sink pad whereas
otherwise there is just a single pad in a subdev. In all use cases more than
one source pad likely isn't uncommon.

The problem with multiple sink pads is that which one you're referring to
when you're configuring the first processing step on the source. Without
composition there are no issues.

What I can think of is to create a special composition target which is not
bound to any pad, but reflects the size of the rectangle on which streams
may be composed from source pad. Cropping on source pad refers to the
coordinates of the composition rectangle. Composition target on sink pad in
the original proposal would be renamed as the scaling target. There would
also be no composition on source pads as it does not make that much sense.

To make configuration simple, accessing any unsupported rectangles should
return EINVAL. So devices not supporting composition would work as proposed
earlier: the compose rectangle would be omitted and the sink crop (if
supported) would refer to either scaling or crop targets or even the sink
format directly.

<URL:http://www.retiisi.org.uk/v4l2/tmp/format2.eps>

Alternatively I think we could as well drop composition support at this
point as we have no drivers using it. We still need to plan ahead how it
could be supported as the need likely arises at some point. As far as I see
the current interface proposal is compatible with composition.

Should we discuss this further on #v4l-meeting, I propose Tuesday 2012-01-31
15:00 Finnish time (13:00 GMT).

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
