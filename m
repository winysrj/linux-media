Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752024AbZLYKA1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 05:00:27 -0500
Date: Fri, 25 Dec 2009 11:00:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: How to know which camera is /dev/videoX
In-Reply-To: <uy6krzull.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0912251058050.4173@axis700.grange>
References: <uy6krzull.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

On Fri, 25 Dec 2009, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> Now my board (EcoVec) can use 2 soc-camera (mt9t112 / tw9910),
> and mt9t112 can attach/detach.
> 
> If mt9t112 is attached,
> /dev/video0 = mt9t112
> /dev/video1 = tw9910
> 
> But if mt9t112 is detached, it will
> /dev/video0 = tw9910
> 
> Now I would like to know which camera is /dev/video0.
> my /dev/video0 is
> 
> > ls -l /dev/video0
> > crw--w----  1 root 1000 81, 0 Jun  9  2009 /dev/video0
> 
> I cheked 81:0 's name
> 
> > cat /sys/dev/char/81\:0/name
> > sh_mobile_ceu.1
> 
> Above name is host of soc-camera for me.
> Are there any way to know camera name (mt9t112/tw9910) ?

You should be able to get their i2c addresses per

~ ls -l /sys/bus/soc-camera/devices/0-0/
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 bus -> ../../../../../bus/soc-camera
lrwxrwxrwx    1 root     root            0 Jan  1 00:01 control -> ../../../../../class/i2c-adapter/i2c-0/0-0048
...

does this help?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
