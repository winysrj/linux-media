Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:42982 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753348Ab0ICUGw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Sep 2010 16:06:52 -0400
Date: Fri, 3 Sep 2010 22:06:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Poyo VL <poyo_vl@yahoo.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch drivers/media/video/mt9v022.c
In-Reply-To: <934905.16227.qm@web45811.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.64.1009032201180.8788@axis700.grange>
References: <666098.4241.qm@web45811.mail.sp1.yahoo.com>
 <Pine.LNX.4.64.1008312227240.25720@axis700.grange> <934905.16227.qm@web45811.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, 1 Sep 2010, Poyo VL wrote:

> Of course, I attached the patch. 
> 
> Thanks for your time and sorry because I didn't read the documentation. 

Thanks, but still not quite right. Most importantly three compulsory 
things are missing: (1) a descriptive subject like

[PATCH] mt9v022: short description of your patch

(2) then in the body a longer description like:

This patch fixes a compiler warning in driver X by removing dead code.

And your "Signed-off-by:" line is also missing. Without these three things 
no patch can be accepted in the kernel (ok, (2) is missing sometimes, if a 
patch is really trivial and the subject explains sufficiently, but (1) and 
(3) must be there). All this is described in the referred document, so, 
looks like you still haven't read it very attentively.

Thanks
Guennadi

> ----- Original Message ----
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> To: Poyo VL <poyo_vl@yahoo.com>
> Sent: Tue, August 31, 2010 11:34:50 PM
> Subject: Re: Patch
> 
> Hi!
> 
> On Tue, 31 Aug 2010, Poyo VL wrote:
> 
> > Kernel: 2.6.35.4
> > File: include/media/v4l2-mediabus.h
> > 
> > Patch:
> > 
> > -    V4L2_MBUS_FMT_FIXED = 1,
> > +    V4L2_MBUS_FMT_NO_FORMAT = 0,
> > +    V4L2_MBUS_FMT_FIXED,
> > 
> > Added a 0 value to the v4l2_mbus_pixelcode structure, it is used on 
> > drivers/media/video/mt9v022.c on line 405 in a switch(mf->code) where code 
> > cannot be 0, so I get warning.
> > 
> > I know it is not extremly important... 
> 
> Thanks for your report and your patch! Fixing compiler warnings is 
> important too, so, this does deserve a patch. However, I think, we have to 
> patch not the generic code, but rather the mt9v022 driver. That "case 0:" 
> has been left there by accident since the very first version, whereas it 
> had to be killed a long time ago. So, the correct fix would be to just 
> kill these three lines there:
> 
> -    case 0:
> -        /* No format change, only geometry */
> -        break;
> 
> If you like, you can submit a patch to do that. But please follow patch 
> submission guidelines, as outlined in Documentation/SubmittingPatches in 
> your kernel tree. And don't forget to CC the linux-media mailing list.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
