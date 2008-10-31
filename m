Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VHff0U002094
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:41:41 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9VHeZJq009643
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:40:36 -0400
Date: Fri, 31 Oct 2008 18:40:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87mygkof3j.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0810311839470.9711@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
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

On Fri, 31 Oct 2008, Robert Jarzmik wrote:

> Antonio Ospite <ospite@studenti.unina.it> writes:
> 
> > Use 16 bit depth for YUYV so the pxa-camera image buffer has the correct size,
> > see the formula:
> >
> > 	*size = icd->width * icd->height *
> > 		((icd->current_fmt->depth + 7) >> 3);
> >
> > in drivers/media/video/pxa_camera.c: pxa_videobuf_setup().
> >
> > Don't swap Cb and Cr components, to respect PXA Quick Capture Interface
> > data format.
> >
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> As a side note, I wonder how you found the right swap :
>  - I based the code on Intel PXA Developer Manual, table 27-19 (page 1127)
>  - and on MT9M111 specification sheet, table 3 (page 14)
> My guess is that the PXA manual is wrong somehow ...
> 
> Anyway, I'm happy with the patch. Guennadi, could you add this patch to your
> queue please ?

Do I understand it right, that although this wasn't a regression, this is 
a bug-fix, right? If so, it should go into 2.6.28. I'll take care of it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
