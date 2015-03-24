Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37940 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbbCXVg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:36:28 -0400
Date: Tue, 24 Mar 2015 14:36:22 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] [ANN] Media Mini-Summit Final Agenda for March
 26th
Message-ID: <20150324143622.24bce760@concha.lan>
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

One item is missing:

17:30 - Group photo

:)

It would also be nice to use 15 mins at the end to double check if the model
of subscribing via LF was a good idea, or if something needs to be improved
for the next Summits.

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
