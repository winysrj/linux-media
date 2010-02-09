Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44026 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750831Ab0BIIL6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 03:11:58 -0500
Date: Tue, 9 Feb 2010 09:12:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [linux-pm] [PATCH/RESEND] soc-camera: add runtime pm support
 for subdevices
In-Reply-To: <201002082310.08079.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1002090901550.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
 <201002082310.08079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Feb 2010, Rafael J. Wysocki wrote:

> On Monday 08 February 2010, Guennadi Liakhovetski wrote:
> > To save power soc-camera powers subdevices down, when they are not in use, 
> > if this is supported by the platform. However, the V4L standard dictates, 
> > that video nodes shall preserve configuration between uses. This requires 
> > runtime power management, which is implemented by this patch. It allows 
> > subdevice drivers to specify their runtime power-management methods, by 
> > assigning a type to the video device.
> 
> You need a support for that at the bus type/device type/device class level,
> because the core doesn't execute the driver callbacks directly.

That's exactly what this patch is doing - adding a device type with pm 
callbacks. What I wasn't sure about - and why I posted here - is whether 
that's a proper way to use pm_runtime_resume() and pm_runtime_suspend() 
calls - from a central module, targeting underlying devices, before 
powering them down and after powering them up?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
