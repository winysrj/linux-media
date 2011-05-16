Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:60159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1EPUpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 16:45:18 -0400
Date: Mon, 16 May 2011 22:45:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
In-Reply-To: <4DCE5726.1030705@redhat.com>
Message-ID: <Pine.LNX.4.64.1105162238500.29373@axis700.grange>
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com>
 <4DCE5726.1030705@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 14 May 2011, Mauro Carvalho Chehab wrote:

> Em 18-04-2011 17:15, Jesse Barker escreveu:
> > One of the big issues we've been faced with at Linaro is around GPU
> > and multimedia device integration, in particular the memory management
> > requirements for supporting them on ARM.  This next cycle, we'll be
> > focusing on driving consensus around a unified memory management
> > solution for embedded systems that support multiple architectures and
> > SoCs.  This is listed as part of our working set of requirements for
> > the next six-month cycle (in spite of the URL, this is not being
> > treated as a graphics-specific topic - we also have participation from
> > multimedia and kernel working group folks):
> > 
> >   https://wiki.linaro.org/Cycles/1111/TechnicalTopics/Graphics
> 
> As part of the memory management needs, Linaro organized several discussions
> during Linaro Development Summit (LDS), at Budapest, and invited me and other
> members of the V4L and DRI community to discuss about the requirements.
> I wish to thank Linaro for its initiative.

[snip]

> Btw, the need of managing buffers is currently being covered by the proposal
> for new ioctl()s to support multi-sized video-buffers [1].
> 
> [1] http://www.spinics.net/lists/linux-media/msg30869.html
> 
> It makes sense to me to discuss such proposal together with the above discussions, 
> in order to keep the API consistent.

The author of that RFC would have been thankful, if he had been put on 
Cc: ;) But anyway, yes, consistency is good, but is my understanding 
correct, that functionally these two extensions - multi-size and 
buffer-forwarding/reuse are independent? We have to think about making the 
APIs consistent, e.g., by reusing data structures. But it's also good to 
make incremental smaller changes where possible, isn't it? So, yes, we 
should think about consistency, but develop and apply those two extensions 
separately?

Thanks
Guennadi

> On my understanding, the SoC people that are driving those changes will
> be working on providing the API proposals for it. They should also be
> providing the needed patches, open source drivers and userspace application(s) 
> that allows testing and validating the GPU <==> V4L transfers using the newly API.
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
