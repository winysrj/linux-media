Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751001AbZDTIOP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 04:14:15 -0400
Date: Mon, 20 Apr 2009 10:14:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <aec7e5c30904200100wb117328sb97ea0262d163547@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904201010130.4403@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
 <Pine.LNX.4.64.0904171235010.5119@axis700.grange>
 <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com>
 <Pine.LNX.4.64.0904200921090.4403@axis700.grange>
 <aec7e5c30904200100wb117328sb97ea0262d163547@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009, Magnus Damm wrote:

> So linux-next fa169db2b277ebafa466d625ed2d16b2d2a4bc82 with
> 20090415/series applies without any rejects and compiles just fine for
> Migo-R. However, during runtime I experience the same problem as with
> 2.6.30-rc plus 0033->0035 + 0036 or v2:
> 
> / # /mplayer -flip -vf mirror -quiet tv://
> MPlayer dev-SVN-rUNKNOWN-4.2-SH4-LINUX_v0701 (C) 2000-2008 MPlayer Team
> 
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> v4l2: unable to open '/dev/video0': No such device or address
> v4l2: ioctl set mute failed: Bad file descriptor
> v4l2: 0 frames successfully processed, 0 frames dropped.
> 
> 
> Exiting... (End of file)
> / #
> 
> Removing 0036 unbreaks the code and mplayer/capture.c works as expected.
> 
> I also tried out v2 of your soc-camera-platform patch but it still
> does not work.
> 
> Can you please test on your Migo-R board? I'd be happy to assist you
> in setting up your environment.

I did test it and it worked - exactly as you say - with the entire patch 
stack + v2 of "soc-camera: convert to platform device," the only 
difference that I can see so far, is that I used modules. So, you can 
either look in dmesg for driver initialisation whether ov772x and tw9910 
have found theit i2c chips, or just wait until I test a monolitic build 
myself. It can be problematic if the i2c-host driver initialises too 
late... If you want to test a modular build it would be enough to just 
have sh_mobile_ceu_camera.ko as a module, the rest can stay built in.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
