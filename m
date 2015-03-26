Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41566 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbbCZHmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 03:42:39 -0400
Date: Thu, 26 Mar 2015 00:42:37 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] [ANN] Media Mini-Summit Final Agenda for March
 26th
Message-ID: <20150326004237.145446f9@concha.lan>
In-Reply-To: <5511B0BF.1030305@xs4all.nl>
References: <5511B0BF.1030305@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Mar 2015 11:45:19 -0700
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This is the final agenda for the media mini-summit in San Jose on March 26th.
> 
> Time: 9 AM to 5:30 PM (approximately)
> Room: San Carlos, 2nd floor
> 
> Attendees:
> 
> We'll get this list later from the Linux Foundation based on who signed on.
> 
> Agenda:
> 
> Times are approximate and will likely change, although the intention is to
> not change too much :-)
> 
> 9:00-9:15   Get everyone installed, laptops hooked up, etc.
> 9:15-9:30   Introduction
> 9:30-10:30  Media Controller support for DVB (Mauro Carvalho Chehab):
> 		1) dynamic creation/removal of pipelines
> 		2) change media_entity_pipeline_start to also define
> 		   the final entity
> 		3) how to setup pipelines that also envolve audio and DRM
> 		4) how to lock the media controller pipeline between enabling a
> 		   pipeline and starting it, in order to avoid race conditions
> 
> See this post for more detailed information:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg85910.html

There is another thread that it is also relevant for the discussions.
In order to help with the discussions, I prepared a set of slides that
explains how the DVB pipelines are and what are the issues with MC.

They're at:
	http://linuxtv.org/downloads/presentations/media_summit_2015_US/dtv_media_controller_discussion_v1.pdf

I added there the links for the related messages that were sent to the
mailing list. Please notice that the example at slide 8 is fictional,
as getting those hardware diagrams would generally require to sign an
NDA. So, the example were created from a slide that I found at the
Internet, under:
	http://www.eetasia.com/ARTICLES/2005AUG/4/2005AUG22_EMS_NP.gif

where I merged the missing entities demod and demux, and guessed that
the output could be sent through GPU and ALSA pipelines, and that
cross-bars would allow different pipeline arrangements.

So, while it is a fictional diagram, it is actually pretty close to
what would happen on a real hardware for a TV set or a Set Top Box.

Regards,
Mauro

> 
> 10:30-10:45 Break
> 10:45-12:00 Continue discussion
> 12:00-13:00 Lunch
> 13:00-14:30 Continue discussion
> 14:30-15:00 Media Tokens (Shuah Kahn)
> 15:00-15:30 Break
> 15:30-16:30 Subdev hotplug in the context of both FPGA dynamic reconfiguration and
> 	    project Ara (http://www.projectara.com/) (Laurent Pinchart).
> 16:30-17:30 Update on ongoing projects (Hans Verkuil):
> 		- work on colorspace improvements
> 		- removing duplicate subdev video ops and use pad ops instead
> 		- vivid & v4l2-compliance improvements
> 		- proposal for Android Camera v3-type requests (aka configuration stores)
> 
> Most of the time will be spent on DVB and the MC. Based on past experience this
> likely will take some time to get a consensus.
> 
> Regards,
> 
> 	Hans
> 
> _______________________________________________
> media-workshop mailing list
> media-workshop@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop


-- 

Cheers,
Mauro
