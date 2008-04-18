Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IEfow3014201
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 10:41:50 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3IEfWXF017914
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 10:41:33 -0400
Date: Fri, 18 Apr 2008 16:41:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804181621560.5725@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
	<998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
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

On Fri, 18 Apr 2008, ·ëöÎ wrote:

> I write in tmpfs.But some frame is dropped.If I request more
> buffers,the number of dropped frames is reduced.Now I request 20
> buffers and write 100 frames.the 52,53,56,57 is dropped.

A couple more ideas to you:

as you get dropped frames even with 20 buffers, this means, that your 
problem most probably is not with delayed DMA IRQ processing - this way 
you get enough time. But if your Capture interface cannot satisfy its DMA 
request quickly enough, FIFO will overflow. And this may happen if you 
have other very active bus masters on your system. The framebuffer, and 
USB host are good candidates. Do you have something like a VGA (640x480) 
framebuffer running with 2 bytes per pixel? Or more? This alone will put a 
considerable pressure on the bus. Sometimes USB can produce a lot of DMA 
traffic, for example, I had problems with bluetooth dongles or other 
network controllers, i.e., with interrupt endpoints at full speed. Also if 
your RAM clock is not running at an optimal speed, your bus will be 
overloaded. But, I guess, you do have your memory clock running at 104MHz 
already.

Also verify what you have as mclk_10khz in your platform data. I can 
produce a lot of dropped frames by setting it to 2000 (i.e., 20MHz master 
clock). Verify that you don't have it too high, and, maybe, try to reduce 
it.

So, so far it doesn't look like a specific driver bug to me, more like a 
general system performance issue.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
