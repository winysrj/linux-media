Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2JVVO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 17:14:29 -0400
Date: Mon, 22 Oct 2012 23:14:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
In-Reply-To: <201210221035.56897.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1210222313490.32591@axis700.grange>
References: <201210221035.56897.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Oct 2012, Hans Verkuil wrote:

> Hi all,
> 
> This is the tentative agenda for the media workshop on November 8, 2012.
> If you have additional things that you want to discuss, or something is wrong
> or incomplete in this list, please let me know so I can update the list.
> 
> - Explain current merging process (Mauro)
> - Open floor for discussions on how to improve it (Mauro)
> - Write down minimum requirements for new V4L2 (and DVB?) drivers, both for
>   staging and mainline acceptance: which frameworks to use, v4l2-compliance,
>   etc. (Hans Verkuil)
> - V4L2 ambiguities (Hans Verkuil)
> - TSMux device (a mux rather than a demux): Alain Volmat
> - dmabuf status, esp. with regards to being able to test (Mauro/Samsung)
> - Device tree support (Guennadi, not known yet whether this topic is needed)

+ asynchronous probing, I guess. It's probably implicitly included though.

Thanks
Guennadi

> - Creating/selecting contexts for hardware that supports this (Samsung, only
>   if time is available)
> 
> For those whose name is behind a topic: please prepare something before the
> meeting.
> 
> We have currently 17 or 18 attendees of a maximum of 25, so there is room
> for a few more people.
> 
> Regards,
> 
> 	Hans
> 
> _______________________________________________
> media-workshop mailing list
> media-workshop@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
