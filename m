Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42CKEaU024502
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:20:14 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m42CJqJ3027545
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:19:52 -0400
Date: Fri, 2 May 2008 14:19:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481B04AE.8020609@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805021417140.4920@axis700.grange>
References: <4811F4EE.9060409@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804281604400.7897@axis700.grange>
	<481AE400.8090709@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021156400.4920@axis700.grange>
	<481AF860.9060603@hni.uni-paderborn.de>
	<481B04AE.8020609@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: pxa_camera with one buffer don't work
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

On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:

> > I used a modified capture_example.c (with the modification you point me some
> > emails ago). If I change the
> > req.count to 1 and remove the restriction I get the select timeout.
> I forget to say, that I use V4L2_PIX_FMT_YUYV

Aha, this, certainly, can make a difference! Unfortunately, I don't have a 
possibility to test with YUYV, so, someone with the hardware has to 
investigate this further (CC-ing the original YUYV-support in PXA270 
author), or I need access to such hardware.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
