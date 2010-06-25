Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41709 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0FYJco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 05:32:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Samuel Xu <samuel.xu.tech@gmail.com>
Subject: Re: Question on newly build uvcvideo.ko
Date: Fri, 25 Jun 2010 11:32:51 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTilsMviOOwo1IWpyfNkd5jeSMU9SozqvgcamBdF_@mail.gmail.com>
In-Reply-To: <AANLkTilsMviOOwo1IWpyfNkd5jeSMU9SozqvgcamBdF_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251132.52431.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

On Friday 25 June 2010 11:25:13 Samuel Xu wrote:
> HI:
> I am using a ASUS netbook with a USB 2.0 web camera (04f2:b071 Chicony
> Electronics Co., Ltd 2.0M UVC WebCam / CNF7129)
> I installed Linux, and the default uvcvideo.ko works (I tried
> gstreamer-properties, which can find CNF7129 device and show correct
> video camera test).
> While I want to try the newest V4L2 build, So I follow
> http://www.linuxtv.org/wiki to:
> 1: get the src code v4l-dvb-9652f85e688a.tar.gz
> 2: make and make install on my netbook.
> 3: reboot system
> 
> lsmod shows me uvcvideo module has been loaded, while
> gstreamer-properties can't find CNF7129 device, so I can't use this
> USB 2.0 web camera now.

Can you look at the kernel log (dmesg) and report messages printed by the 
uvcvideo driver ?

> I also tried re-install original workable Linux, and make v4l again.
> Then copy the newly build uvcvideo.ko to
> /lib/modules/2.6.33.xx/kernel/drivers/media/video/uvc/
> module still can be found from lsmod, while gstreamer-properties still
> can't find CNF7129 device.

That's to be expected, as the new v4l-dvb build you installed replaced the 
core v4l modules (such as videodev.ko), and the new version isn't compatible 
with the uvcvideo driver that came with your kernel.

> Does it mean I must do some code modification for 04f2:b071 device
> before I build v4l driver?

In theory, no.

-- 
Regards,

Laurent Pinchart
