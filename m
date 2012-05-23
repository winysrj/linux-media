Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:49886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EWHp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 03:45:57 -0400
Date: Wed, 23 May 2012 09:45:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [git:v4l-dvb/for_v3.5] [media] media: mx2_camera: Fix mbus format
 handling
In-Reply-To: <CACKLOr0e7_UXSnq9GwRQx35eaGbZ1mwQMQ7-L8Riprz3rerzcw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205230938470.21980@axis700.grange>
References: <E1SUH8r-0005cc-3k@www.linuxtv.org> <Pine.LNX.4.64.1205160050270.25352@axis700.grange>
 <Pine.LNX.4.64.1205221918150.11851@axis700.grange>
 <CACKLOr0e7_UXSnq9GwRQx35eaGbZ1mwQMQ7-L8Riprz3rerzcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 23 May 2012, javier Martin wrote:

> Hi Guennadi, Mauro,
> 
> >> Looks like I have missed this patch, unfortunately, it hasn't been cc'ed
> >> to me. It would have been better to merge it via my soc-camera tree, also
> >> because with this merge window there are a couple more changes, that
> >> affect the generic soc-camera API and the mx2-camera driver in particular.
> >> So far I don't see anything, what could break here, but if something does
> >> - we know who will have to fix it;-)
> 
> Sorry about that. I usually send patches for mx2-camera to you as well
> but this time I missed it. The fact that your name does not appear
> when executing 'get_mantainer' doesn't help me to remember either.

No idea whether there is a way to help that script deliver a better 
result, sorry. I certainly would rather avoid listing each soc-camera file 
in MAINTAINERS. I don't think it's a sufficient reason to justify moving 
them all into a separate subdirectory.

> > I'm afraid, I get an impression, that your patch breaks support for the
> > pass-through mode in the mx2-camera driver. Where previously not natively
> > supported formats would be just read in by the camera interface without
> > any conversion (see the first entry in the mx27_emma_prp_table[] array),
> > you now return an error in mx2_camera_set_bus_param().
> 
> I think you are right. It seems I should provide a default for other
> mbus formats instead of returning an error. It's good you noticed
> because I haven't got any device to test this pass-through mode, so I
> try my best to add new functionallity without breaking it.
> 
> >If I'm write, I'll ask Mauro to revert your patch. Please correct me if I'm mistaken.

s/write/right/

> Is this the way to proceed or should I send a fix on top of it? This
> patch is merged in 'for_v3.5', if Mauro reverts it and I send a new
> version,  would it be also merged 'for_v3.5' or should it wait for
> version 3.6?

I think, it would be better to revert and re-do it for the following 
reason: since neither you nor me can test those pass-through cases, I 
think, it is easier to review patches and try to avoid regressions by 
looking at patches, that take you from a (presumably working) state A step 
by step to a state B, where each patch is seemingly correct, than by 
looking at a patch "a" that introduces a breakage and "b" that hopefully 
should fix it back.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
