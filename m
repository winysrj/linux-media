Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAJerng019628
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:40:53 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAAJecwL007980
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 14:40:38 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 10 Nov 2008 20:39:36 +0100
In-Reply-To: <Pine.LNX.4.64.0811101323490.4248@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	10 Nov 2008 13\:36\:38 +0100 \(CET\)")
Message-ID: <87fxlz8j5z.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> These patches should finish the necessary preparations for the pxa-camera 
> driver to finally correctly present its planar YUV format and to be able 
> to select camera formats, it actually can support, and perform further 
> format conversions as they emerge.

Hi Guennadi,

Would you tell me against what tree you're based (a git URL would be wonderful)
?  Because I got rejects, having not the ov7272.c file in my git tree
(mainline), which would mean you're ahead and I'm late ...

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
