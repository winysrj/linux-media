Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1LEUvq018479
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 16:14:30 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1LE8Mq016601
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 16:14:08 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081107130136.fkdeaklvs40ocsws@webmail.hebergement.com>
	<Pine.LNX.4.64.0811290229070.7032@axis700.grange>
	<873ah8n8d3.fsf@free.fr>
	<Pine.LNX.4.64.0812011612000.3915@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 01 Dec 2008 22:13:57 +0100
In-Reply-To: <Pine.LNX.4.64.0812011612000.3915@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	1 Dec 2008 16\:14\:20 +0100 \(CET\)")
Message-ID: <87k5ajtx7u.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: About CITOR register value for pxa_camera
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

>
> As you might have seen, I posted two patches on the list earlier today 
> (with you on cc), which fix this Oops and one more bug in a formula. If 
> the patches look fine to you or better yet, if you can test them and they 
> pass your test, I'll push them upstream with a next request.
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>

The only comment I would have is about suspend/resume, when lcd clock rate might
have changed. But since the patch doesn't either break or improve the legacy
behaviour, I'm for leaving it as it is.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
