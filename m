Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JE4Iku015915
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 10:04:18 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3JE415P014051
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 10:04:02 -0400
Date: Sat, 19 Apr 2008 16:04:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804191558490.5599@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
	<998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
	<998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
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

Hi

you still haven't replied how you count processed / dropped frames. 
Without this I cannot really understand where your problem may be.

On Sat, 19 Apr 2008, ·ëöÎ wrote:

> Thanks I will try according to what you said. Mybe I can find why I
> have this problem.But a driver come from MontaVista can also work
> well.No frame is dropped.
> 
> Now I find MontaVista driver have a problem.I execute VIDIOC_REQBUFS
> failed After I execute VIDIOC_STREAMOFF and munmap() .This time
> soc-camera driver can work well.You can give me some advice.

Do you mean, that after you captured video with MontaVista's driver, the 
soc-camera driver works without dropping frames too? And you didn't reboot 
between the tests? This looks like mvista's driver has configured the 
hardware in a more optimal way, which, however, I don't quite understand. 
As far as I know, pxa-camera initializes the hardware completely. Maybe I 
can have a look some time at the sources you've sent me to see what they 
might be initializing differently. No promise though.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
