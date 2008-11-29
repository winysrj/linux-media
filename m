Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATCVYu5025957
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 07:31:34 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATCUMO7003433
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 07:30:22 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
	<1227554928-25471-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811272343480.8230@axis700.grange>
	<Pine.LNX.4.64.0811290026200.7032@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 29 Nov 2008 13:30:17 +0100
In-Reply-To: <Pine.LNX.4.64.0811290026200.7032@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat\,
	29 Nov 2008 00\:27\:16 +0100 \(CET\)")
Message-ID: <87prker9ye.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2] pxa_camera: use the new translation structure
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

>> I think, this function would be better named buswicth_supported().
>
> ...even better buswidth_supported:-)
Yep. Tomorrow, with your comments on soc_camera, I'll repost the 2 patches.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
