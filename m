Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HXNgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 09:36:05 -0400
Date: Fri, 24 Aug 2012 15:35:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Detlev Zundel <dzu@denx.de>
cc: Anatolij Gustschin <agust@denx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other
 register settings
In-Reply-To: <m2pq6g5tm3.fsf@lamuella.denx.de>
Message-ID: <Pine.LNX.4.64.1208241527370.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-2-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1208241227140.20710@axis700.grange> <m2pq6g5tm3.fsf@lamuella.denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Detlev

On Fri, 24 Aug 2012, Detlev Zundel wrote:

> Hello Guennadi,
> 
> > Hi Anatolij
> >
> > On Fri, 24 Aug 2012, Anatolij Gustschin wrote:
> >
> >> Add controls for horizontal and vertical blanking, analog control
> >> and control for undocumented register 32.
> >
> > Sorry, I don't think this is a good idea to export an undocumented 
> > register as a control.
> 
> Why exactly is that?  Even though it is not documented, we need to
> fiddle with it to make our application work at all.  So we tend to
> believe that other users of the chip will want to use it also.

Below I asked to provide details about how you have to change this 
register value: toggle dynamically at run-time or just set once at 
initialisation? Even if toggle: are this certain moments, related to 
standard camera activities (e.g., starting and stopping streaming, 
changing geometry etc.) or you have to set this absolutely asynchronously 
at moments of time, that only your application knows about?

> Furthermore I don't see that we fundamentally reject patches for other
> parts in the Linux kernel where people found out things not in the
> official datasheets.

The problem is not, that this register is undocumented, the problem rather 
is, that IMHO exporting an API to user-space, setting an undocumented 
register to arbitrary values is, hm, at least pretty dubious.

> But I agree that better documentation would be valuable - we are trying
> to find out more information on the original 

That would be great, thanks!

> > At most I would add a platform parameter for it, if really needed. Or
> > do you have to switch it at run-time? If so, you would have some idea
> > - at what time to switch it to what value and what effect that
> > produces. Then you could define a _logical_ control. If you absolutely
> > need to write random values to various registers, you can use
> > VIDIOC_DBG_S_REGISTER and VIDIOC_DBG_G_REGISTER.
> 
> I made a mistake of using them once in an application before I noticed
> the comments immediately above in the header file[1]:
> 
>   /*
>    *      A D V A N C E D   D E B U G G I N G
>    *
>    *      NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
>    *      FOR DEBUGGING, TESTING AND INTERNAL USE ONLY!
>    */
>   
>   /* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */
>   
> At that time I was burned by the API changing (the undocumented register
> does not go away) and thus this time we want to follow the advice in the
> header file.  So I really hope that you do not suggest that we use this
> in an application or do you?

Not in a production application of course, no. That's why I asked to 
explain how and why this register has to be changed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
