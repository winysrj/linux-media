Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab1HaNmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:42:05 -0400
Message-ID: <4E5E3A12.4020902@infradead.org>
Date: Wed, 31 Aug 2011 10:41:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange> <Pine.LNX.4.64.1108311103130.8429@axis700.grange> <4E5E23CA.4030208@infradead.org> <201108311441.28464.hverkuil@xs4all.nl>
In-Reply-To: <201108311441.28464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-08-2011 09:41, Hans Verkuil escreveu:
> On Wednesday, August 31, 2011 14:06:34 Mauro Carvalho Chehab wrote:
>> Em 31-08-2011 06:06, Guennadi Liakhovetski escreveu:
>>>>>> I would propose to start by reorganizing the menu. E.g. make a submenu 
> for
>>>>>> old legacy bus drivers (parallel port, ISA), for platform drivers, and 
> for
>>>>>> 'rare' drivers (need a better name for that :-) ). For example the 
> Hexium
>>>>>> PCI drivers are very rare, and few people have them.
>>>>>
>>>>> Sure, this can be done, not sure whether I'm a suitable person for this 
>>>>> task - I don't have a very good overview of the present market 
>>>>> situation;-)
>>
>> It is hard to say what's "rare". While we know a few examples, nobody has a
>> worldwide situation about what's rare.
> 
> I actually have a pretty good overview of that when it comes to video capture.
> 
> Going through the menu it is IMHO reasonably to classify the following drivers 
> as rare:
> 
> w9966 (still haven't been able to find hardware to test this)
> cpia2 (after a long hunt I finally tracked down a cpia2-based webcam)
> mxb
> hexium (orion and gemini drivers)

Not many. Also, I'm sure that some DVB devices are also "rare". 

I think that the main question is: are you _sure_ that all the remaining devices
are "not rare"? If we're creating an item for those devices, we should be sure 
that we'll put there everything that falls into that category, otherwise it will
be missy.

Btw, there are also some cases where a device is found only on some specific
market, like the ISDB-S cards (only found in Japan, AFAIK). Those devices will
be "rare" outside Japan, as people would have a device there only if they have
an ISDB-S generator, or if they're on some place where the Japan Satellites
can be seen. The same applies to some drivers focused at the other Asian standards.
I doubt that, when one of such devices become "rare" (e. g. after years after
the end of such device sales) that we'll be able to detect it.

> As an aside: the cpia2 menu entry should really move to the 'V4L USB devices' 
> section.

Agreed.

> I think making a menu with 'legacy drivers' containing the parallel port 
> webcams (bw-qcam, c-qcam, w9966), the cpia2 driver, the ISA pms driver and the 
> 'rare' mxb and hexium drivers would go a long way to cleaning up the v4l menu.

a "parallel port" menu would make sense. Let's put it in the end. The same applies
to ISA drivers.

> And by reordering the rest of the menu so 'popular' drivers like saa7134 come 
> before zoran and the motion eye drivers etc. would also make it easier to 
> navigate the menu.

Not sure about that. Maybe using an alphabetical order would be better.

> The USB devices should be moved up to the top.

Agreed.

> I also think a 'Sensors' submenu will be useful. Right now most sensors are 
> under SoC camera, but once the soc-camera dependency is removed we can move 
> them all under their own submenu.

We're putting all I2C drivers under the menu "Encoders/decoders and other helper chips",
including the very few sensors drivers that don't belong to soc-camera.

They're organized there by function. I don't mind reordering it or breaking it into
sub-menus, provided that we will to the same thing for everything that falls into the
same category.


> 
> Regards,
> 
> 	Hans

Cheers,
Mauro
