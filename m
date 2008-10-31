Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VHLOMp023413
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:21:24 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m9VHLM8E018775
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:21:22 -0400
To: Antonio Ospite <ospite@studenti.unina.it>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 31 Oct 2008 18:21:20 +0100
In-Reply-To: <20081029232544.661b8f17.ospite@studenti.unina.it> (Antonio
	Ospite's message of "Wed\, 29 Oct 2008 23\:25\:44 +0100")
Message-ID: <87mygkof3j.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Antonio Ospite <ospite@studenti.unina.it> writes:

> Use 16 bit depth for YUYV so the pxa-camera image buffer has the correct size,
> see the formula:
>
> 	*size = icd->width * icd->height *
> 		((icd->current_fmt->depth + 7) >> 3);
>
> in drivers/media/video/pxa_camera.c: pxa_videobuf_setup().
>
> Don't swap Cb and Cr components, to respect PXA Quick Capture Interface
> data format.
>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

As a side note, I wonder how you found the right swap :
 - I based the code on Intel PXA Developer Manual, table 27-19 (page 1127)
 - and on MT9M111 specification sheet, table 3 (page 14)
My guess is that the PXA manual is wrong somehow ...

Anyway, I'm happy with the patch. Guennadi, could you add this patch to your
queue please ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
