Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0G979Oe008855
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 04:07:09 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0G96sot011686
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 04:06:54 -0500
Date: Fri, 16 Jan 2009 10:06:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uzlhrslr1.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901161004060.4940@axis700.grange>
References: <u1vv3u5j4.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0901160835240.4713@axis700.grange>
	<uzlhrslr1.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] ov772x: add image flip support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 16 Jan 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> Thank you for checking patch.
> 
> > This looks wrong to me. Please, use V4L2_CID_VFLIP and V4L2_CID_HFLIP 
> > controls for vertical and horisontal flips respectively.
> 
> I could understand.
> 
> And I have some questions.
> 
> There is ov772x camera that has been inversely connected to board.
> ap325 (SH7723) board is that board.
> 
> Because it get upside down image,
> I would like to get normal image by default.
> But should I add V4L2_CID_XXX support ?
> 
> And can I use V4L2_CID_VFLIP, V4L2_CID_HFLIP on mplayer ?
> I think I can not ...

I didn't find it either. Well, let's do it this way: you add 
V4L2_CID_VFLIP (and V4L2_CID_HFLIP if you like) support, and a flag to set 
flipped image by default, ok? Because implementing flipping functionality 
and not providing it to the user is sort of weird.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
