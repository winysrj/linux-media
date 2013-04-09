Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3DIIOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 04:14:12 -0400
Date: Tue, 9 Apr 2013 10:14:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Simon Horman <horms@verge.net.au>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera
 example
In-Reply-To: <20130409080731.GC18478@verge.net.au>
Message-ID: <Pine.LNX.4.64.1304091013221.9051@axis700.grange>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
 <20130409080731.GC18478@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon

On Tue, 9 Apr 2013, Simon Horman wrote:

> On Mon, Apr 08, 2013 at 05:05:31PM +0200, Guennadi Liakhovetski wrote:
> > Mostly just a re-spin of v7 with minor modifications.
> > 
> > Guennadi Liakhovetski (7):
> >   media: V4L2: add temporary clock helpers
> >   media: V4L2: support asynchronous subdevice registration
> >   media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
> >   soc-camera: add V4L2-async support
> >   sh_mobile_ceu_camera: add asynchronous subdevice probing support
> >   imx074: support asynchronous probing
> >   ARM: shmobile: convert ap4evb to asynchronously register camera
> >     subdevices
> 
> Hi Guennadi,
> 
> can the last patch be applied (to my tree) independently
> of the other patches (applied elsewhere) ?

No, please, wait. It strongly depends on the whole patch series.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
