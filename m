Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42746 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753477AbZBSIsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 03:48:09 -0500
Date: Thu, 19 Feb 2009 09:48:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New v4l2 driver for atmel boards
In-Reply-To: <499D1A93.5090805@atmel.com>
Message-ID: <Pine.LNX.4.64.0902190946130.5156@axis700.grange>
References: <499BCAF9.2060101@atmel.com> <Pine.LNX.4.64.0902182202090.6371@axis700.grange>
 <499D1A93.5090805@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009, Sedji Gaouaou wrote:

> Hi Guennadi,
> 
> > what hardware is it for? avr32 or at91 (ARM)?
> I am working on AT91(ARM).
>  And what API are you using
> > to communicate with sensors? 
> I am using the ISI IP.
> Currently there are two APIs in the kernel -
> > int-device and soc-camera, and they both should at some point (soon)
> > converge to the new "V4L2 driver framework." They all have (one of) the
> > goal(s) to reuse sensor (or whatever subdevice) drivers with various hosts.
> > Which of them are you using?
> > 
> > I've recently got test hardware from Atmel for an AP7000 board (NGW100), and
> > was planning to convert the existing external ISI driver from Atmel to the
> > soc-camera API, but I have no idea when I find time for that.
> > 
> 
> I have a driver which is not using the soc-camera layer...
> Which driver is currently using this soc-camera layer so I can have a look at
> it and maybe I could try to convert mine.

That would be great. You can look at

drivers/media/video/pxa_camera.c
drivers/media/video/sh_mobile_ceu_camera.c

and, if you wait for my pool request, expected later today, and pull from 
the mercurial tree, also at

drivers/media/video/mx3_camera.c

but, even the former two should be enough for you to start with.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
