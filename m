Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55247 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbcCUSXb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 14:23:31 -0400
Date: Mon, 21 Mar 2016 15:23:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	<linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
Message-ID: <20160321152323.01e29553@recife.lan>
In-Reply-To: <56F038A0.1010004@xs4all.nl>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
	<1457550566-5465-2-git-send-email-javier@osg.samsung.com>
	<56EC2294.603@xs4all.nl>
	<56EC3BF3.5040100@xs4all.nl>
	<20160321114045.00f200a0@recife.lan>
	<56F00DAA.8000701@xs4all.nl>
	<56F01AE7.6070508@xs4all.nl>
	<20160321145034.6fa4e677@recife.lan>
	<56F038A0.1010004@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 19:08:32 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/21/2016 06:50 PM, Mauro Carvalho Chehab wrote:
> > Hi Hans,
> > 
> > Em Mon, 21 Mar 2016 17:01:43 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >>> A reasonable solution to simplify converting legacy drivers without creating
> >>> these global ugly pad indices is to add a new video (and probably audio) op
> >>> 'g_pad_of_type(type)' where you ask the subdev entity to return which pad carries
> >>> signals of a certain type.    
> >>
> >> This basically puts a layer between the low-level pads as defined by the entity
> >> and the 'meta-pads' that a generic MC link creator would need to handle legacy
> >> drivers. The nice thing is that this is wholly inside the kernel so we can
> >> modify it at will later without impacting userspace.  
> > 
> > I prepared a long answer to your email, but I guess we're not at the
> > same page.
> > 
> > Let be clear on my view. Please let me know where you disagree:
> > 
> > 1) I'm not defending Javier's patchset. I have my restrictions to
> > it too. My understanding is that he sent this as a RFC for feeding
> > our discussions for the media summit.
> > 
> > Javier, please correct me if I'm wrong.
> > 
> > 2) I don't understand what you're calling as "meta-pads". For me, a
> > PAD is a physical set of pins.   
> 
> Poorly worded on my side. I'll elaborate below.
> 
> > 3) IMO, the best is to have just one PAD for a decoder input. That makes
> > everything simple, yet functional.
> > 
> > In my view, the input PAD will be linked to several "input connections".
> > So, in the case of tvp5150, it will have:
> > 
> > 	- composite 1
> > 	- composite 2
> > 	- s-video
> > 
> > 4) On that view, the input PAD is actually a set of pins. In the
> > case of tvp5150, the pins that compose the input PADs are
> > AIP1A and AIP1B.
> > 
> > The output PAD is also a set of pins YOUT0 to YOUT7, plus some other
> > pins for sync. Yet, it should, IMHO, have just one output PAD at
> > the MC graph.  
> 
> Indeed. So a tvp5150 has three sink pads and one source pad (pixel port).

I would actually map tvp5150 with just one sink pad, with 3 links
(one for each connector).

In other words, I'm mapping tvp5150 input mux via links, and the
output of its mux as the sink pad.

IMHO, this works a way better than one sink pad per input at its
internal mux.

Regards,
Mauro
