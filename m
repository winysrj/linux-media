Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85KH2r2008968
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 16:17:03 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85KGo2w007652
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 16:16:51 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20080905103917.GQ4941@pengutronix.de>
	<Pine.LNX.4.64.0809051330390.5482@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 05 Sep 2008 22:16:40 +0200
In-Reply-To: <Pine.LNX.4.64.0809051330390.5482@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri\,
	5 Sep 2008 20\:12\:56 +0200 \(CEST\)")
Message-ID: <87zlmm73h3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [soc-camera] about the y_skip_top parameter
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

> Hm, AFAIR, the reason was different. I was told, that "all" cameras 
> corrupt the first line, that's why that parameter has been introduced. I 
> don't think it was related to PXA270. In any case, why don't you just set 
> this parameter to whatever you need in your hist driver .add method, for 
> example, before calling camera's .init?

Actually I think there is now one camera at least which doesn't ... the mt9m111
:)

Maybe it has to do with the chip internals, which uses these first lines to
make its calculation on white balance, gamma auto correction etc ...

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
