Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:7170 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1HaMld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:41:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
Date: Wed, 31 Aug 2011 14:41:28 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange> <Pine.LNX.4.64.1108311103130.8429@axis700.grange> <4E5E23CA.4030208@infradead.org>
In-Reply-To: <4E5E23CA.4030208@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311441.28464.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 31, 2011 14:06:34 Mauro Carvalho Chehab wrote:
> Em 31-08-2011 06:06, Guennadi Liakhovetski escreveu:
> >>>> I would propose to start by reorganizing the menu. E.g. make a submenu 
for
> >>>> old legacy bus drivers (parallel port, ISA), for platform drivers, and 
for
> >>>> 'rare' drivers (need a better name for that :-) ). For example the 
Hexium
> >>>> PCI drivers are very rare, and few people have them.
> >>>
> >>> Sure, this can be done, not sure whether I'm a suitable person for this 
> >>> task - I don't have a very good overview of the present market 
> >>> situation;-)
> 
> It is hard to say what's "rare". While we know a few examples, nobody has a
> worldwide situation about what's rare.

I actually have a pretty good overview of that when it comes to video capture.

Going through the menu it is IMHO reasonably to classify the following drivers 
as rare:

w9966 (still haven't been able to find hardware to test this)
cpia2 (after a long hunt I finally tracked down a cpia2-based webcam)
mxb
hexium (orion and gemini drivers)

As an aside: the cpia2 menu entry should really move to the 'V4L USB devices' 
section.

I think making a menu with 'legacy drivers' containing the parallel port 
webcams (bw-qcam, c-qcam, w9966), the cpia2 driver, the ISA pms driver and the 
'rare' mxb and hexium drivers would go a long way to cleaning up the v4l menu.

And by reordering the rest of the menu so 'popular' drivers like saa7134 come 
before zoran and the motion eye drivers etc. would also make it easier to 
navigate the menu.

The USB devices should be moved up to the top.

I also think a 'Sensors' submenu will be useful. Right now most sensors are 
under SoC camera, but once the soc-camera dependency is removed we can move 
them all under their own submenu.

Regards,

	Hans
