Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaBMVb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 16:31:56 -0500
Date: Thu, 13 Feb 2014 22:31:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Steven Toth <stoth@kernellabs.com>
cc: Pavel Machek <pavel@ucw.cz>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Video capture in FPGA -- simple hardware to emulate?
In-Reply-To: <CALzAhNVC1KRuhMks_2YUSF1e8iVEfsyvKZmphyXMqpJ+0d228Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1402132223480.24792@axis700.grange>
References: <20140213195224.GA10691@amd.pavel.ucw.cz>
 <CALzAhNVC1KRuhMks_2YUSF1e8iVEfsyvKZmphyXMqpJ+0d228Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 13 Feb 2014, Steven Toth wrote:

> On Thu, Feb 13, 2014 at 2:52 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > I'm working on project that will need doing video capture from
> > FPGA. That means I can define interface between kernel and hardware.
> >
> > Is there suitable, simple hardware we should emulate in the FPGA? I
> > took a look, and pxa_camera seems to be one of the simple ones...

Too bad this one

http://opencores.org/project,100

is only in planning... Maybe you could collaborate with them?

> Thats actually a pretty open-ended question. You might get better
> advice if you describe your hardware platform in a little more detail.

+1. As usually you have to begin with what you need. Will it be using an 
external DMA engine or will it have one built into it? If you've got a 
DMAC core already, it will define your V4L2 dma operations choice - 
contiguous or SG, unless, as Steven mentioned, you go over USB. Then you 
decide what sensor interface you need - parallel or CSI, etc.

> Are you using a USB or PCIe controller to talk to the fpga, or does
> the fpga contain embedded IP cores for USB or PCIe?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
