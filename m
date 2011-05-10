Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49044 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1EJJvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 05:51:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: why is there no enum_input in v4l2_subdev_video_ops
Date: Tue, 10 May 2011 11:51:55 +0200
Cc: "Jiang, Scott" <Scott.Jiang@analog.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com> <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDFA4@NWD2CMBX1.ad.analog.com> <76572cb10f933c769617a2c5120a5d25.squirrel@webmail.xs4all.nl>
In-Reply-To: <76572cb10f933c769617a2c5120a5d25.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101151.56086.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Tuesday 10 May 2011 08:14:10 Hans Verkuil wrote:
> > On Tue, May 10, 2011 at 5:42 AM, Laurent Pinchart wrote:
> >>> >> Why is there no enum_input operation in v4l2_subdev_video_ops?
> >> 
> >> Why do you need one ?
> > 
> > Because I want to query decoder how many inputs it can support.
> > So the question is where we should store inputs info, board specific data
> > or decoder driver?
> > I appreciate your advice.
> 
> ENUMINPUT as defined by V4L2 enumerates input connectors available on the
> board. Which inputs the board designer hooked up is something that only
> the top-level V4L driver will know. Subdevices do not have that
> information, so enuminputs is not applicable there.
> 
> Of course, subdevices do have input pins and output pins, but these are
> assumed to be fixed. With the s_routing ops the top level driver selects
> which input and output pins are active. Enumeration of those inputs and
> outputs wouldn't gain you anything as far as I can tell since the
> subdevice simply does not know which inputs/outputs are actually hooked
> up. It's the top level driver that has that information (usually passed in
> through board/card info structures).

I agree. Subdevs don't have enough knowledge of their surroundings to make 
input enumeration really useful. They could enumerate their input pins, but 
not the inputs that are actually hooked up on board.

The media controller framework is one way of solving this issue. It can report 
links for every input pad.

Scott, can you tell us a bit more about the decoder you're working with ? What 
kind of system is it used in ?

-- 
Regards,

Laurent Pinchart
