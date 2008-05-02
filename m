Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42Fwr1D032147
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:58:53 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42FwKcV011003
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 11:58:21 -0400
Message-ID: <481B3A18.8030302@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 17:58:16 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <4811F4EE.9060409@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804281604400.7897@axis700.grange>
	<481AE400.8090709@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021156400.4920@axis700.grange>
	<481AF860.9060603@hni.uni-paderborn.de>
	<481B04AE.8020609@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021417140.4920@axis700.grange>
	<481B1094.4020303@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021519350.4920@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0805021519350.4920@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
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

Guennadi Liakhovetski schrieb:
> On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:
>
>   
>> question: The function pxa_camera_dma_irq reset the passed FIFO channel if an
>> overrun occur.
>> But it should clear the others FIFOs too? Or is this wrong?
>>     
>
> From the datasheet:
>
> "Reset input FIFO (RESETF)-- When set, the FIFO pointers of all three 
> FIFOs are reset. This bit is automatically cleared after resetting the 
> pointers."
>
>   
But only the current DMA channel was stopped.

The V4L2_PIX_FMT_YUYV mode uses only on DMA channel. So there should be 
no difference to RGB / raw mode.

I will going on with porting my system to 2.6.25 and then test again.

Thanks
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
