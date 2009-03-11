Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754299AbZCKKCm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 06:02:42 -0400
Date: Wed, 11 Mar 2009 11:02:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: atmel v4l2 soc driver
In-Reply-To: <49B789F8.3070906@atmel.com>
Message-ID: <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
References: <49B789F8.3070906@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Sedji Gaouaou wrote:

> I am currently porting an atmel isi driver to the soc layer,

This is good!

> and I encounter some problems.
> I have based my driver on pax-camera. and sh_mobile_ceu_camera.c.
> The point is I can't see any video entry in /dev when I do ls dev/ on my
> board...
> So I wonder when is soc_camera_video_start(which call video_register_device)
> called? Is that at the probe?

Well, you could just do

grep soc_camera_video_start drivers/media/video/*.c

Then you would immediately see, that each specific camera (sensor, 
decoder, whatever) driver explicitly calls this function.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
