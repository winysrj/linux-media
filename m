Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753618AbZCWPj4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 11:39:56 -0400
Date: Mon, 23 Mar 2009 16:40:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: atmel v4l2 soc driver
In-Reply-To: <49C7A8DF.3040101@atmel.com>
Message-ID: <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
 <49C7A8DF.3040101@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, Sedji Gaouaou wrote:

> I am writing a driver for the ov9655 sensor from Omnivision.
> To do so I am using the ov772x.c file as an example.
> But I don't understant, because it seems that I never enter the video_probe
> function...
> Do you have any idea what could I do wrong? Is it coming from a wrong i2c
> config?

Wouldn't ov9655 be similar enough to ov9650 as used in stk-sensor.c? Hans, 
would that one also be converted to v4l2-device? If so, Sedji, you don't 
need to write yet another driver for it.

What concerns your probing problem - you most likely are missing platform 
bindings in your board code. See arch/arm/mach-pxa/pcm990-baseboard.c for 
an example.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
