Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3MW7GK005635
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 17:32:08 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3MVvVi015720
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 17:31:57 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
	<87mygg4l5l.fsf@free.fr>
	<Pine.LNX.4.64.0811032131410.7744@axis700.grange>
	<Pine.LNX.4.64.0811032322420.7744@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 03 Nov 2008 23:31:55 +0100
In-Reply-To: <Pine.LNX.4.64.0811032322420.7744@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	3 Nov 2008 23\:26\:43 +0100 \(CET\)")
Message-ID: <87k5bk30h0.fsf@free.fr>
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

> Ok, just thinking one step further - Antonio most certainly was testing 
> V4L2_PIX_FMT_YUYV, i.e., packed with his application, any other YCbCr 
> format would be rejected by mt9m111 and YUYV _is_ packed. So, I think this 
> is indeed the case - there are mo errors in datasheets, we just named the 
> formats wrongly in pxa-camera and mt9m111 drivers.

I don't agree. This has nothing to do with naming, this has to do with byte
order on qif bus and out of mt9m111 sensor.

But you can change my mind : just tell me where my thinking was
wrong in the previous mail where I stated bytes order (out of mt9m111 and in pxa
qif bus).

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
