Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53054 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752234Ab0BIJZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 04:25:07 -0500
Date: Tue, 9 Feb 2010 10:25:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>
Subject: Re: How to change fps on soc-camera ?
In-Reply-To: <u1vi3wnt2.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.1002090856050.4585@axis700.grange>
References: <u1vi3wnt2.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 6 Jan 2010, Kuninori Morimoto wrote:

> 
> Hi all
> 
> Now I have mt9t112 / ov772x soc-camera.
> And it can change fps by register setting.
> So, I would like to add such support to driver.
> 
> But I don't know how to order it from user program.
> Can you please teach me about it ?
> 
> # in my easy search, using ioctrl with VIDIOC_S_PARM
> # seems good, I'm not sure though

Yes, I think, you're right. It's the .timeperframe member of struct 
v4l2_captureparm, that you'd be looking at. And yes, you'd have to add 
support for it to soc-camera, by adding a suitable operation to struct 
soc_camera_host_ops, and calling it from soc_camera.c - if provided by 
the host driver. Then you add it to sh_mobile_ceu_camera.c and just call 
.s_parm from struct v4l2_subdev_video_ops. I'm replying to this email 
with two patches, please, see if they provide the necessary infrastructure 
for you and let me know the result - I'll push them upstream if you're 
fine with them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
