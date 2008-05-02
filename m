Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42DMd23031859
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 09:22:39 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m42DMRmV031858
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 09:22:27 -0400
Date: Fri, 2 May 2008 15:22:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481B1094.4020303@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805021519350.4920@axis700.grange>
References: <4811F4EE.9060409@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804281604400.7897@axis700.grange>
	<481AE400.8090709@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021156400.4920@axis700.grange>
	<481AF860.9060603@hni.uni-paderborn.de>
	<481B04AE.8020609@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021417140.4920@axis700.grange>
	<481B1094.4020303@hni.uni-paderborn.de>
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

> question: The function pxa_camera_dma_irq reset the passed FIFO channel if an
> overrun occur.
> But it should clear the others FIFOs too? Or is this wrong?

>From the datasheet:

"Reset input FIFO (RESETF)-- When set, the FIFO pointers of all three 
FIFOs are reset. This bit is automatically cleared after resetting the 
pointers."

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
