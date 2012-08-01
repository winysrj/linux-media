Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:63387 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2HAJLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 05:11:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: workshop-2011@linuxtv.org, Rob Clark <rob.clark@linaro.org>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Wed, 1 Aug 2012 11:11:12 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20120713173708.GB17109@thunk.org> <5005A14D.8000809@redhat.com> <50181CBF.102@redhat.com>
In-Reply-To: <50181CBF.102@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208011111.12597.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 31 July 2012 19:58:23 Mauro Carvalho Chehab wrote:
> In order to sum-up the discussions around the media summit,
> this is what we've got so far:
> 
> Proposals									     	proposed by
> =====================================================================================|=========================================================================================
> Common device tree bindings for media devices						Sylvester Nawrocki / Guennadi Liakhovetski
> ALSA and V4L/Media Controller								Steven Toth / Laurent Pinchart
> ARM and needed features for V4L/DVB							Steven Toth
> Intel media SDK										Steven Toth
> V4L compiance tool									Hans Verkuil
> V4L2 API ambiguities									Hans Verkuil
> Media Controller library								Laurent Pincart / Sakari Ailus
> SoC Vendors feedback – how to help them to go upstream – Android's V4L2 cam library	Laurent Pincart / Guennadi Liakhovetski / Palash Bandyopadhyay / Naveen Krishnamurthy
> Synchronization, shared resource and optimizations					Pawel Osciak
> V4L2/DVB issues from userspace perspective						Rémi Denis-Courmont
> 
> As we'll have only one day for the summit, we may need to remove some
> themes, or maybe to get an extra time during LPC for the remaining
> discussions.
> 	
> Possible attendents:
> ===================
> 
> Guennadi Liakhovetski
> Laurent Pinchart
> Mauro Carvalho Chehab
> Michael Krufky
> Naveen Krishnamurthy
> +1 seat from ST (waiting Naveen to define who will be the other seat)
> Palash Bandyopadhyay
> Pawel Osciak
> Rémi Denis-Courmont
> Sakari Ailus
> Steven Toth
> Sylvester Nawrocki
> 
> Am I missing something?
> 
> Are there other proposals or people intending to participate?

Yes: I would like to discuss how to add support for HDMI CEC to the kernel.
In particularly I need some feedback from the GPU driver developers on what
their ideas are, since CEC is something that touches both V4L2 and GPU.

I'm not sure what the best place is to do this, it's a fairly specialized
topic. It might be better suited to just get a few interested devs together
in the evening or during some other suitable time and just see if we can
hammer out some scheme. I'll have a presentation on the topic ready.

Rob, what are your ideas on this?

Who else might be interested in this?

Regards,

	Hans
