Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:61130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1BZNDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:03:55 -0500
Date: Sat, 26 Feb 2011 14:03:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201102261331.26681.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1102261350001.31455@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <20110225135314.GF23853@valkosipuli.localdomain> <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
 <201102261331.26681.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 26 Feb 2011, Hans Verkuil wrote:

> On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
> 
> <snip>
> 
> > > > configure the sensor to react on an external trigger provided by the flash 
> > > > controller is needed, and that could be a control on the flash sub-device. 
> > > > What we would probably miss is a way to issue a STREAMON with a number of 
> > > > frames to capture. A new ioctl is probably needed there. Maybe that would be 
> > > > an opportunity to create a new stream-control ioctl that could replace 
> > > > STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream 
> > > > operation, and easily map STREAMON and STREAMOFF to the new ioctl in 
> > > > video_ioctl2 internally).
> > > 
> > > How would this be different from queueing n frames (in total; count
> > > dequeueing, too) and issuing streamon? --- Except that when the last frame
> > > is processed the pipeline could be stopped already before issuing STREAMOFF.
> > > That does indeed have some benefits. Something else?
> > 
> > Well, you usually see in your host driver, that the videobuffer queue is 
> > empty (no more free buffers are available), so, you stop streaming 
> > immediately too.
> 
> This probably assumes that the host driver knows that this is a special queue?
> Because in general drivers will simply keep capturing in the last buffer and not
> release it to userspace until a new buffer is queued.

Yes, I know about this spec requirement, but I also know, that not all 
drivers do that and not everyone is happy about that requirement:)

> That said, it wouldn't be hard to add some flag somewhere that puts a queue in
> a 'stop streaming on last buffer capture' mode.

No, it wouldn't... But TBH this doesn't seem like the most elegant and 
complete solution. Maybe we have to think a bit more about it - which 
soncequences switching into the snapshot mode has on the host driver, 
apart from stopping after N frames. So, this is one of the possibilities, 
not sure if the best one.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
