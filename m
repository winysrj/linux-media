Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADKGnKa002183
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 15:16:49 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mADKGYTx006573
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 15:16:34 -0500
Date: Thu, 13 Nov 2008 21:16:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <uy6zoyqvn.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0811132113070.8536@axis700.grange>
References: <uy6zoyqvn.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Question of v4l2-chip-ident.h for tw9910 driver
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

On Thu, 13 Nov 2008, morimoto.kuninori@renesas.com wrote:

> 
> Dear All
> 
> Now, I'm creating new tw9910 driver.
> It is based on soc_camera framework.
> 
> But I don't understand where is the best position to add new identify
> on ${LINUX}/include/media/v4l2-chip-ident.h for tw9910.
> 
> And what number is good ?
> 
> Please teach me above.
> 
> The manufacturer of tw9910 is TECHWELL.INC

I'm not maintaining that file, so, this is not definite, but I would just 
leave some space around existing entries and take some arbitrary number 
above that, say, like 45100 / 45500 / 46000? Another possibility is to 
take something that reminds your chip notation, 9910?

Just choose whatever you like, submit a patch and see if it gets accepted 
or rejected:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
