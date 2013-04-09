Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54489 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935595Ab3DIIHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 04:07:34 -0400
Date: Tue, 9 Apr 2013 17:07:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera
 example
Message-ID: <20130409080731.GC18478@verge.net.au>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 08, 2013 at 05:05:31PM +0200, Guennadi Liakhovetski wrote:
> Mostly just a re-spin of v7 with minor modifications.
> 
> Guennadi Liakhovetski (7):
>   media: V4L2: add temporary clock helpers
>   media: V4L2: support asynchronous subdevice registration
>   media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
>   soc-camera: add V4L2-async support
>   sh_mobile_ceu_camera: add asynchronous subdevice probing support
>   imx074: support asynchronous probing
>   ARM: shmobile: convert ap4evb to asynchronously register camera
>     subdevices

Hi Guennadi,

can the last patch be applied (to my tree) independently
of the other patches (applied elsewhere) ?
