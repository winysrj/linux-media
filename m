Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATHVnRP010595
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 12:31:49 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mATHVaLn000873
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 12:31:36 -0500
Date: Sat, 29 Nov 2008 18:31:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811280000250.8230@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811291822100.8352@axis700.grange>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811251914260.6290@axis700.grange>
	<87ljv4506r.fsf@free.fr>
	<Pine.LNX.4.64.0811280000250.8230@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH v4 1/2] soc-camera: pixel format negotiation - core
 support
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

Hi Robert,

this is what I have written:

> +	icd->current_fmt = icd->user_formats[0].host_fmt;

and this is what you've written:

On Sat, 29 Nov 2008, Robert Jarzmik wrote:

> +	icd->current_fmt = &icd->user_formats[0].host_fmt;

I think, this is different. Further I think your version would produce a 
compiler warning like this:

drivers/media/video/soc_camera.c: In function 'soc_camera_init_user_formats':
drivers/media/video/soc_camera.c:219: warning: assignment from incompatible pointer type

and is indeed wrong. Please fix and please test your patches before 
submitting - compile and run. Or am I wrong?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
