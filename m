Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAE0512m022045
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 19:05:01 -0500
Received: from mail04.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAE04nIk019289
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 19:04:50 -0500
Date: Fri, 14 Nov 2008 09:04:38 +0900
From: morimoto.kuninori@renesas.com
In-reply-to: <Pine.LNX.4.64.0811132113070.8536@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <ufxlvuq95.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
References: <uy6zoyqvn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0811132113070.8536@axis700.grange>
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Question of v4l2-chip-ident.h for tw9910 driver
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


Hi Guennadi

Thank you for nice advice.

> > The manufacturer of tw9910 is TECHWELL.INC
> 
> I'm not maintaining that file, so, this is not definite, but I would just 
> leave some space around existing entries and take some arbitrary number 
> above that, say, like 45100 / 45500 / 46000? Another possibility is to 
> take something that reminds your chip notation, 9910?
> 
> Just choose whatever you like, submit a patch and see if it gets accepted 
> or rejected:-)

I didn't know that that file has not be maintained.
OK, I'll use 9910.

Thank you again

/Morimoto

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
