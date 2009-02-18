Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756445AbZBRVNY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 16:13:24 -0500
Date: Wed, 18 Feb 2009 22:13:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New v4l2 driver for atmel boards
In-Reply-To: <499BCAF9.2060101@atmel.com>
Message-ID: <Pine.LNX.4.64.0902182202090.6371@axis700.grange>
References: <499BCAF9.2060101@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moved to the new v4l list)

On Wed, 18 Feb 2009, Sedji Gaouaou wrote:

> Hi everybody,
> 
> I am writing here to know if it is the proper place to send a driver that I
> have written for atmel's boards.
> I would like to know as well if there is a git tree against which I should
> based my patch or should I based it against the latest rc?

Hi Sedji,

what hardware is it for? avr32 or at91 (ARM)? And what API are you using 
to communicate with sensors? Currently there are two APIs in the kernel - 
int-device and soc-camera, and they both should at some point (soon) 
converge to the new "V4L2 driver framework." They all have (one of) the 
goal(s) to reuse sensor (or whatever subdevice) drivers with various 
hosts. Which of them are you using?

I've recently got test hardware from Atmel for an AP7000 board (NGW100), 
and was planning to convert the existing external ISI driver from Atmel to 
the soc-camera API, but I have no idea when I find time for that.

As for against which tree to submit patches, I think, 
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git should 
be a good starting point.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
