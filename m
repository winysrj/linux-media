Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VI4FlH013615
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 14:04:15 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VI43e6022518
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 14:04:03 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0810311839470.9711@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 31 Oct 2008 19:04:01 +0100
In-Reply-To: <Pine.LNX.4.64.0810311839470.9711@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri\,
	31 Oct 2008 18\:40\:49 +0100 \(CET\)")
Message-ID: <874p2sod4e.fsf@free.fr>
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Do I understand it right, that although this wasn't a regression, this is 
> a bug-fix, right? If so, it should go into 2.6.28. I'll take care of it.
Yes, a bug fix, and yes, not a regression, just my silly mind trusting the
specifications :)

And yes, should go into 2.6.28-rc series IMO, thanks.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
