Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4F9Xvpn015916
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 05:33:57 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4F9XR5u031266
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 05:33:27 -0400
Date: Thu, 15 May 2008 11:33:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820805150152p51f8f9fek5462aee7a6d3ba06@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805151105290.14292@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
	<998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
	<998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
	<Pine.LNX.4.64.0804221618510.8132@axis700.grange>
	<998e4a820805150152p51f8f9fek5462aee7a6d3ba06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

On Thu, 15 May 2008, ·ëöÎ wrote:

> why does soc-cmaera driver FIFO usually overrun? Now I use a thread to
> capture frames. But if overrun occur,frame will dropped.

What is your <struct pxacamera_platform_data>.mclk_10khz set to? What 
kernel version are you using? I do not know what you do in your FPGA, are 
you sure it doesn't modify your camera bus timing (pixel clock, VSYNC, 
HSYNC, master clock)?

> I have another question.I hope you can give me some advice. If I write
> a file to jffs2 norflash,FIFO overrun will occur without fail. Why
> writting norflash will affect FIFO or DMA.

Do you mean camera FIFO overruns occur, but fraims do not get dropped? The 
reason, why with NOR you have more problems might be, that you produce 
extra load on the memory bus? I don't remember id you already told us, 
what type of LCD you have on your system and what other bus masters you 
have? What's your frame format? 640x480x8bit?

Sorry, without working with your hardware I don't think I can effectively 
investigate your problem. On my setup I only get overrung if I 
purposefully introduce problems, by, for example, increasing mclk_10khz, 
or using only 2 buffers, or by writing to NFS-mounted storage.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
