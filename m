Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48207 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZLYOAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 09:00:23 -0500
Subject: Re: How to know which camera is /dev/videoX
From: Andy Walls <awalls@radix.net>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Guennadi <g.liakhovetski@gmx.de>,
	Linux-V4L2 <linux-media@vger.kernel.org>
In-Reply-To: <uy6krzull.wl%morimoto.kuninori@renesas.com>
References: <uy6krzull.wl%morimoto.kuninori@renesas.com>
Content-Type: text/plain
Date: Fri, 25 Dec 2009 08:58:49 -0500
Message-Id: <1261749529.3093.2.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-12-25 at 10:54 +0900, Kuninori Morimoto wrote:
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

Maybe some of these will help:

$ v4l2-ctl --list-devices
$ v4l2-ctl -d /dev/video0 -D
$ v4l2-ctl -d /dev/video0 --log-status
$ v4l2-ctl -d /dev/video1 -D
$ v4l2-ctl -d /dev/video1 --log-status

Regards,
Andy

> Best regards
> --
> Kuninori Morimoto
>  


