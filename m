Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBT9PjKt029562
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 04:25:45 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBT9PTI2007477
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 04:25:29 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1LHEH3-0001Ax-0s
	for video4linux-list@redhat.com; Mon, 29 Dec 2008 10:18:57 +0100
Date: Mon, 29 Dec 2008 10:18:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812291016250.3949@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: Micron mt9m001
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

I've got a direct request regarding the mt9m001 driver, which I tried to 
reply to, however, I haven't been able to do so even after multiple 
attempts to persuade the recepient's spam-filter that I am not a spammer. 
So, the only way for me to try to deliver my reply is to send it to the 
list and hope the OP reads it some time...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

---------- Forwarded message ----------
Date: Mon, 29 Dec 2008 08:55:14 +0100 (CET)
From: Guennadi Liakhovetski <lyakh@axis700.grange>
To: singingfalls <mohair@singingfalls.com>
Subject: Re: Micron mt9m001

Hello Stan

On Sun, 28 Dec 2008, singingfalls wrote:

> Forgive my forwardness. I have a microscope camera with the Micron
> mt9m001 chip. Is there a driver for Hardy Ubuntu?

At first, one small request to you - if you reply to this email or if you 
otherwise would like to contact me (or any other video4linux developer) in 
the future, please, also cc the respective mailing list 
(video4linux-list@redhat.com for video4linux, or another respective list 
for different topics). This way others can also benefit from our 
discussion.

As for your question, the problem is not a specific distribution / kernel 
version, but the way the mt9m001 camera chip is connected to your CPU. As 
you mention Ubuntu I take it your microscope is connected to a PC or a 
Mac. I am not an expert in microscopes, but those I saw in shops connect 
to PCs over USB. If this also the case with yours, then it means, that 
mt9m001 is first connected to at least some kind of a I2C+video--to--USB 
converter chip, or even some microprocessor with own firmware.

The in-kernel mt9m001 driver handles the mt9m001 chip _only_ - up to its 
I2C interface. It doesn't handle any interfacing chips. So, most likely, 
this driver will not be able to drive your microscope in its present form. 
What would be needed is an additional driver to control the interface 
ch"p. And that will not be easy, because if your microscope is an 
"ordinary" one bought at an "ordinary" store, presumably, we will never be 
able to get details (datasheets / technical documentation) about that 
interface controller. And I am not sure if anyone will ever be interested 
in reverse-engineering a driver for it.

So, I am sorry to say this, but if my guesses are correct, then most 
likely you won't be able to interface your microscope to Linux.

However, please do write to the list, it might also turn out that I'm 
wrong and that someone already handles your device with a completely 
different driver. But please provide more detail if you write to the list 
- how your microscope is connected to your PC and what it is called.

> Stan Petrowski
> www.singingfalls.com

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
