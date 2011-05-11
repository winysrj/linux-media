Return-path: <mchehab@gaivota>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:46898
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172Ab1EKPpE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 11:45:04 -0400
From: "Jiang, Scott" <Scott.Jiang@analog.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 11 May 2011 04:43:30 -0400
Subject: RE: why is there no enum_input in v4l2_subdev_video_ops
Message-ID: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CE3A5@NWD2CMBX1.ad.analog.com>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com>
 <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDFA4@NWD2CMBX1.ad.analog.com>
 <76572cb10f933c769617a2c5120a5d25.squirrel@webmail.xs4all.nl>
 <201105101151.56086.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105101151.56086.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

On Tue, May 10, 2011 at 5:51 PM, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hi,
>
> On Tuesday 10 May 2011 08:14:10 Hans Verkuil wrote:
>> > On Tue, May 10, 2011 at 5:42 AM, Laurent Pinchart wrote:
>> >>> >> Why is there no enum_input operation in v4l2_subdev_video_ops?
>> >>
>> >> Why do you need one ?
>> >
>> > Because I want to query decoder how many inputs it can support.
>> > So the question is where we should store inputs info, board specific data
>> > or decoder driver?
>> > I appreciate your advice.
>>
>> ENUMINPUT as defined by V4L2 enumerates input connectors available on the
>> board. Which inputs the board designer hooked up is something that only
>> the top-level V4L driver will know. Subdevices do not have that
>> information, so enuminputs is not applicable there.
>>
>> Of course, subdevices do have input pins and output pins, but these are
>> assumed to be fixed. With the s_routing ops the top level driver selects
>> which input and output pins are active. Enumeration of those inputs and
>> outputs wouldn't gain you anything as far as I can tell since the
>> subdevice simply does not know which inputs/outputs are actually hooked
>> up. It's the top level driver that has that information (usually passed in
>> through board/card info structures).
>
> I agree. Subdevs don't have enough knowledge of their surroundings to make
> input enumeration really useful. They could enumerate their input pins, but
> not the inputs that are actually hooked up on board.
>
> The media controller framework is one way of solving this issue. It can report
> links for every input pad.
>
> Scott, can you tell us a bit more about the decoder you're working with ? What
> kind of system is it used in ?

I'm working on ADV7183 and VS6624 connecting with blackfin through ppi.
By the way, ppi is a generic parallel interface, that means it can't know the fmt supported itself.
Should I use enum_mbus_fmt to ask decoder for this info?
I found it in v4l2_subdev_video_ops, but didn't know its usage exactly.

Regards,
Scott


