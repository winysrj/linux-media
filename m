Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA5MbNGe028839
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 17:37:23 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA5MbAdZ027890
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 17:37:10 -0500
Date: Wed, 5 Nov 2008 23:37:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <873ai5ommr.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811052336000.8283@axis700.grange>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
	<1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811042329330.8208@axis700.grange>
	<873ai5ommr.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add all yuv format combinations.
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

On Wed, 5 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Would you also like to make the third patch - updating pxa-camera with the 
> > three further YCbCr formats and adding a comment, that although the docs 
> > only claim support for UYUV the others can be used too, as long as we 
> > don't use post-processing. Can you also test other formats?
> Yes, give me a couple of days. Y*Y* and *Y*Y are tested already, I just want to
> try the planar format, and I'll post.

Great, thanks! Unfortunately, all I have here to test is monochrome and 
Bayer.

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
