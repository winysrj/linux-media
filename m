Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K8BtP-000879-8S
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 12:24:56 +0200
Received: from [192.168.1.2] (02-145.155.popsite.net [66.217.132.145])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m5GAOaqY017600
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 06:24:37 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1213579027.3164.36.camel@palomino.walls.org>
References: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
	<1213567472.3173.50.camel@palomino.walls.org>
	<1213573393.2683.85.camel@pc10.localdom.local>
	<1213579027.3164.36.camel@palomino.walls.org>
Date: Mon, 16 Jun 2008 06:24:13 -0400
Message-Id: <1213611853.3175.2.camel@palomino.walls.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] cx18 - dmesg errors and ir transmit
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, 2008-06-15 at 21:17 -0400, Andy Walls wrote:

> I have just examined the lirc_pvr150 code, the kernel i2c-core, the cx18
> and ivtv code.  Changes will be needed in:
> 
> 1. lirc_pvr150.c
> 	- add request_module("cx18") near the end
> 
> 	- change the explicit call to ivtv_reset_ir_gpio() to a 
> 		cx18 equivalent or somehow change to an ioctl()
> 		so that the code is more flexible.

Oops, an ioctl() isn't a sensible interface between kernel space
modules.  Scratch that part.

-Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
