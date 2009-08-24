Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753136AbZHXSGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 14:06:11 -0400
Date: Mon, 24 Aug 2009 20:06:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
In-Reply-To: <200908220850.07435.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0908241947471.8736@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek

On Sat, 22 Aug 2009, Marek Vasut wrote:

> From 479aafc9a6540efec8a691a84aff166eb0218a72 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Sat, 22 Aug 2009 05:14:23 +0200
> Subject: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Ok, I see, you rebased your patches on my soc-camera patch-stack, this is 
good, thanks. But you missed a couple of my comments - you still have a 
few static functions in the ov9640.c marked inline: ov9640_set_crop() is 
not used at all, ov9640_set_bus_param() gets assigned to a struct member, 
so, cannot be inline. ov9640_alter_regs() is indeed only called at one 
location, but see Chapter 15 in Documentation/CodingStyle. You left at 
least one multi-line comment wrongly formatted. You left some broken 
printk format lines, etc. You moved your header under drivers/... - that's 
good. But, please, address all my comments that I provided in a private 
review, or explain why you do not agree. Otherwise I feel like I wasted my 
time. Besides, your mailer has wrapped lines. Please, read 
Documentation/email-clients.txt on how to configure your email client to 
send patches properly. In the worst case, you can inline your patches 
while reviewing, and then attach them for a final submission. This is, 
however, discouraged, because it makes review and test of your 
intermediate patches with wrapped lines more difficult. Also, please check 
your patches with scripts/checkpatch.pl.

[patch skipped]

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
