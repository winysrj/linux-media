Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63307 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbbCXGZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 02:25:50 -0400
Date: Tue, 24 Mar 2015 07:25:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] [ANN] Media Mini-Summit Draft Agenda for March
 26th
In-Reply-To: <20150322210218.499f83e3@concha.lan>
Message-ID: <Pine.LNX.4.64.1503240712040.1710@axis700.grange>
References: <5506BDA8.3000700@xs4all.nl> <20150322210218.499f83e3@concha.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, 22 Mar 2015, Mauro Carvalho Chehab wrote:

> Em Mon, 16 Mar 2015 12:25:28 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > This is the draft agenda for the media mini-summit in San Jose on March 26th.
> > 
> > Time: 9 AM to 5 PM (approximately)
> > Room: TBC (Mauro, do you know this?)
> 
> I'll check on this Monday with LF and wiĺl give you a feedback.
> 
> > 
> > Attendees:
> > 
> > Mauro Carvalho Chehab	- mchehab@osg.samsung.com		- Samsung
> > Laurent Pinchart	- laurent.pinchart@ideasonboard.com	- Ideas on board
> > Hans Verkuil		- hverkuil@xs4all.nl			- Cisco
> > 
> > Mauro, do you have a better overview of who else will attend?
> 
> This time, we'll be using ELC registration site to track. I'll see how
> we can get this info with LF as well, but, as people can join it
> dynamically, the best is to get the list with them on Thursday evening,
> and double-check during the Summit to track last-minute changes.

I asked the LF how I should register to attend the mini-summit only, they 
said - no, no need to register, attending just a mini-summit is free. So, 
expect unregistered visitors like me ;)

Thanks
Guennadi

> 
> > 
> > Agenda:
> > 
> > Times are approximate and will likely change.
> > 
> > 9:00-9:15   Get everyone installed, laptops hooked up, etc.
> > 9:15-9:30   Introduction
> > 9:30-10:30  Media Controller support for DVB (Mauro):
> > 		1) dynamic creation/removal of pipelines
> > 		2) change media_entity_pipeline_start to also define
> > 		   the final entity
> > 		3) how to setup pipelines that also envolve audio and DRM
> > 		4) how to lock the media controller pipeline between enabling a
> > 		   pipeline and starting it, in order to avoid race conditions
> > 
> > See this post for more detailed information:
> > 
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg85910.html
> 
> Actually, there are two threads and two followup emails. The detailed info
> is at:
> 
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg85910.html
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg85979.html
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg83883.html
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg83884.html
> 
> I'll prepare a summary covering everything into a single file to make
> easier, and I'll prepare some slides with the topic highlights.
> 
> > 10:30-10:45 Break
> > 10:45-12:00 Continue discussion
> > 12:00-13:00 Lunch (Mauro, do you have any idea whether there is a lunch organized,
> > 	    or if we are on our own?)
> 
> I'm almost sure we are on our on for lunch. I'll double check this also
> with LF.
> 
> > 13:00-14:40 Continue discussion
> > 14:40-15:00 Break
> > 15:00-16:00 Subdev hotplug in the context of both FPGA dynamic reconfiguration and
> > 	    project Ara (http://www.projectara.com/) (Laurent).
> > 16:00-17:00 Update on ongoing projects (Hans):
> > 		- proposal for Android Camera v3-type requests (aka configuration stores)
> > 		- work on colorspace improvements
> > 		- vivid & v4l2-compliance improvements
> > 		- removing duplicate subdev video ops and use pad ops instead
> > 		- others?
> > 
> > Most of the time will be spent on DVB and the MC. Based on past experience this
> > likely will take some time to get a concensus.
> > 
> > Comments are welcome!
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > _______________________________________________
> > media-workshop mailing list
> > media-workshop@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop
> 
> 
> -- 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
