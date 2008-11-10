Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAKXR0l031768
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:33:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAAKXEbJ004732
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:33:15 -0500
Date: Mon, 10 Nov 2008 21:33:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87fxlz8j5z.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811102127020.8315@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<87fxlz8j5z.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0/5] pixel format handling in camera host drivers - part
 2
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

On Mon, 10 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > These patches should finish the necessary preparations for the pxa-camera 
> > driver to finally correctly present its planar YUV format and to be able 
> > to select camera formats, it actually can support, and perform further 
> > format conversions as they emerge.
> 
> Hi Guennadi,
> 
> Would you tell me against what tree you're based (a git URL would be wonderful)
> ?  Because I got rejects, having not the ov7272.c file in my git tree
> (mainline), which would mean you're ahead and I'm late ...

My tree is still based on commit 67d112842586aa11506b7a8afec29391bf8f3cca 
in linux-next of 9 days ago, but ov772x wasn't there yet, so, I 
cherry-picked it. But you can try a more recent linux-next, ov722x is 
already there and even with two commits!:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
