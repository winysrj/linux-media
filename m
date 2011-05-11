Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1EKPy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 11:54:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Jiang, Scott" <Scott.Jiang@analog.com>
Subject: Re: why is there no enum_input in v4l2_subdev_video_ops
Date: Wed, 11 May 2011 11:28:03 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com> <201105101151.56086.laurent.pinchart@ideasonboard.com> <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CE3A5@NWD2CMBX1.ad.analog.com>
In-Reply-To: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CE3A5@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105111128.03704.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Scott,

On Wednesday 11 May 2011 10:43:30 Jiang, Scott wrote:
> On Tue, May 10, 2011 at 5:51 PM, Laurent Pinchart wrote: > > On Tuesday 10 
May 2011 08:14:10 Hans Verkuil wrote:
> >> > On Tue, May 10, 2011 at 5:42 AM, Laurent Pinchart wrote:
> >> >>> >> Why is there no enum_input operation in v4l2_subdev_video_ops?
> >> >> 
> >> >> Why do you need one ?
> >> > 
> >> > Because I want to query decoder how many inputs it can support.
> >> > So the question is where we should store inputs info, board specific
> >> > data or decoder driver?
> >> > I appreciate your advice.
> >> 
> >> ENUMINPUT as defined by V4L2 enumerates input connectors available on
> >> the board. Which inputs the board designer hooked up is something that
> >> only the top-level V4L driver will know. Subdevices do not have that
> >> information, so enuminputs is not applicable there.
> >> 
> >> Of course, subdevices do have input pins and output pins, but these are
> >> assumed to be fixed. With the s_routing ops the top level driver selects
> >> which input and output pins are active. Enumeration of those inputs and
> >> outputs wouldn't gain you anything as far as I can tell since the
> >> subdevice simply does not know which inputs/outputs are actually hooked
> >> up. It's the top level driver that has that information (usually passed
> >> in through board/card info structures).
> > 
> > I agree. Subdevs don't have enough knowledge of their surroundings to
> > make input enumeration really useful. They could enumerate their input
> > pins, but not the inputs that are actually hooked up on board.
> > 
> > The media controller framework is one way of solving this issue. It can
> > report links for every input pad.
> > 
> > Scott, can you tell us a bit more about the decoder you're working with ?
> > What kind of system is it used in ?
> 
> I'm working on ADV7183 and VS6624 connecting with blackfin through ppi.

Enumerating inputs only matters for the ADV7183. The issue is that the adv7183 
driver doesn't know how its inputs are routed on the board. I see several 
solutions to fix this issue.

- Create an adv7183 platform data structure, and fill it in board code with 
input routing information. The adv7183 driver can use that information to 
implement a (to be added) enum_input operation. I don't really like this 
solution, as the adv7183 really shouldn't care about how video signals are 
routed on the board.

- Pass the same information to the master v4l2_device driver that instantiates 
the adv7183. The information can then be used to implement the G_INPUT ioctl, 
or for internal purpose. You won't need any enum_input subdev operation in 
that case.

- Use the media controller API to expose routing information to userspace. 
Like in the previous solution, board code would pass input routing information 
to the v4l2_device driver that would use use to create links. Links will then 
be enumerable and configurable by userspace.

> By the way, ppi is a generic parallel interface, that means it can't know
> the fmt supported itself. Should I use enum_mbus_fmt to ask decoder for
> this info?
> I found it in v4l2_subdev_video_ops, but didn't know its usage exactly.

The enum_mbus_fmt can be used for that purpose, yes. You can use it to query 
the ADV7183 and VS6624 for their supported formats. You can also query the 
current format with g_mbus_fmt.

If you want to implement the media controller API, you should go for the pad-
level operations instead of enum_mbus_fmt/g_mbus_fmt (available in 2.6.39).

-- 
Regards,

Laurent Pinchart
