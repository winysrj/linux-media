Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA5M4jMq009945
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 17:04:45 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA5M4UYp010615
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 17:04:31 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87bpwvyx19.fsf@free.fr>
	<1225835978-14548-1-git-send-email-robert.jarzmik@free.fr>
	<1225835978-14548-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811042329330.8208@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 05 Nov 2008 23:04:28 +0100
In-Reply-To: <Pine.LNX.4.64.0811042329330.8208@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	4 Nov 2008 23\:40\:17 +0100 \(CET\)")
Message-ID: <873ai5ommr.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Would you also like to make the third patch - updating pxa-camera with the 
> three further YCbCr formats and adding a comment, that although the docs 
> only claim support for UYUV the others can be used too, as long as we 
> don't use post-processing. Can you also test other formats?
Yes, give me a couple of days. Y*Y* and *Y*Y are tested already, I just want to
try the planar format, and I'll post.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
