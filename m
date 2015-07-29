Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35463 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbbG2ILn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 04:11:43 -0400
Message-ID: <1438157501.4303.16.camel@pengutronix.de>
Subject: Re: coda: Problems with encoding in i.MX6DL.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Javier Martin <javiermartin@by.com.es>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Wed, 29 Jul 2015 10:11:41 +0200
In-Reply-To: <55B87201.1070801@by.com.es>
References: <55B87201.1070801@by.com.es>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Mittwoch, den 29.07.2015, 08:26 +0200 schrieb Javier Martin:
> Hello,
> I am running kernel 4.1 in a var-dvk-solo-linux evaluation board from 
> Variscite.
> 
> This is what I get at system start-up:
> 
> coda 2040000.vpu: Firmware code revision: 34588
> coda 2040000.vpu: Initialized CODA960.
> coda 2040000.vpu: Unsupported firmware version: 2.1.8
> coda 2040000.vpu: codec registered as /dev/video[0-1]

So the firmware is basically running ...

> Apparently, the firmware is being loaded properly although it complains 
> about that version not being supported.
>
> After queuing some YUV420 buffers with a simple application I perform a 
> VIDIOC_STREAMON in both the CAPTURE and the OUTPUT interfaces but I get 
> the following error:
> 
> coda 2040000.vpu: coda is not initialized.

... but then suddenly it's not.
(coda_is_initialized just checks whether PC != 0)

Could this have something to do with the PU power domain? Do all coda
registers read 0x0 ?
Do you have CONFIG_PM disabled? Check if d438462c20a3 ("ARM: imx6: gpc:
always enable PU domain if CONFIG_PM is not set") makes a difference.
I think that patch hasn't made it into stable yet.

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 91 at drivers/media/v4l2-core/videobuf2-core.c:1792 
> vb2_start_streaming+0xe0/0x15c()

That is because after copying buffers to the bitstream, the driver
currently marks them as done. When start_streaming fails, videobuf2
expects drivers to re-queue them. So we'd have to flush the bitstream
and re-queue the buffers so they can be copied to the bitstream all over
during the next try.
This warning is a result of incomplete error handling in the coda
start_streaming implementation.

[...]
> ---[ end trace 2b0ba71bfb12fec4 ]---
> 
> As anyone seen the same issue? Could be related to the "Unsupported 
> firmware version" complaint?

I don't think so. That reminds me, I have used 2.1.9 on i.MX6Q without
issues. I still need have to test 3.1.1, but I think that should work,
too.

> Do you know where to get the 2.1.5 firmware for the i.MX6D?

It was part of the L3.0.35_12.09.01_GA Freescale BSP
(firmware-imx-12.09.01), but I don't think that is the issue. If PC==0
it doesn't even execute the firmware.

best regards
Philipp

