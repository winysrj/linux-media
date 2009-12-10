Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60771 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbZLJORU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 09:17:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pablo Baena <pbaena@gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
Date: Thu, 10 Dec 2009 15:19:04 +0100
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com>
In-Reply-To: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912101519.04700.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pablo,

On Monday 07 December 2009 18:18:11 Pablo Baena wrote:
> I get a kernel panic when running the attached sample code.
> 
> I run it as:
> 
> $ gcc capture.c -o capture
> $ export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
> $ ./capture -d/dev/video0 -c1000 -r
> 
> -r tells it to capture using read(), which libv4l emulates.
> 
> In the example code, I use read() to fetch from the webcam directly,
> without using select() to wait for a frame. In the v4l documentation,
> it states that read() should block until it has a new frame available.
> 
> This is a Bus 002 Device 005: ID 0c45:62c0 Microdia Sonix USB 2.0 Camera.
> 
> I can't capture the kernel panic because everything hangs and I have
> no kernel debugger to try to get that info. I attach a poor quality
> image taken with a webcam from the screen. I even tried having a
> vmware virtual machine to try to better capture the panic, but in the
> virtual machine it doesn't hang.
> 
> This is Ubuntu 9.10, Linux pablo-laptop 2.6.31-16-generic #52-Ubuntu
> SMP Thu Dec 3 22:00:22 UTC 2009 i686 GNU/Linux.
> 
> But I got reports that the same camera on Debian 5.3 is also panicking.
> 
> Please advice if you need more information to solve this problem.

I can't reproduce the problem here (with another camera).

To investigate I will need a copy of the source code and binary kernel module 
for the uvcvideo driver running on your system as well as a complete complete 
backtrace.

-- 
Regards,

Laurent Pinchart
