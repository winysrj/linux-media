Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3MQuIC003020
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 17:26:56 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA3MQgCa013253
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 17:26:42 -0500
Date: Mon, 3 Nov 2008 23:26:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811032131410.7744@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811032322420.7744@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
	<87mygg4l5l.fsf@free.fr>
	<Pine.LNX.4.64.0811032131410.7744@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 3 Nov 2008, Guennadi Liakhovetski wrote:

> In fact, I think, it might even be, that both datasheets are correct and 
> the testing was wrong. In packed mode pxa270 probably just pipes the data 
> through one-to-one. So, if both datasheets are correct you would get UYUV 
> in application buffers. Now, if you tell the application, that it's YUYV 
> the picture will be wrong of course. And if you just swap the bytes _at_ 
> _the_ _sensor_ the picture will be right, even though the pxa is only 
> documented to work in UYUV mode. In packed mode it probably just doesn't 
> care. Or am I missing something? Antonio, how did you test - in packed or 
> planar mode and what format have you configured at the application level?

Ok, just thinking one step further - Antonio most certainly was testing 
V4L2_PIX_FMT_YUYV, i.e., packed with his application, any other YCbCr 
format would be rejected by mt9m111 and YUYV _is_ packed. So, I think this 
is indeed the case - there are mo errors in datasheets, we just named the 
formats wrongly in pxa-camera and mt9m111 drivers.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
