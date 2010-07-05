Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0GEF0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 01:26:39 -0400
Message-ID: <4C316D0C.6070707@redhat.com>
Date: Mon, 05 Jul 2010 02:26:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jay Guillory <Jay.Guillory@conexant.com>
Subject: Re: [cx25821] Removed duplicate code and cleaned up
References: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad> <34B38BE41EDBA046A4AFBB591FA31132F4B404@NBMBX01.bbnet.ad>
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA31132F4B404@NBMBX01.bbnet.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-06-2010 01:27, Palash Bandyopadhyay escreveu:
> From 58fd4cad5f6acbe16bff86b8e878d2352cc73637 Mon Sep 17 00:00:00 2001
> Message-Id: <58fd4cad5f6acbe16bff86b8e878d2352cc73637.1276143362.git.palash.bandyopadhyay@conexant.com>
> From: palash <palash.bandyopadhyay@conexant.com>
> Date: Wed, 9 Jun 2010 21:11:20 -0700
> Subject: [cx25821] Removed duplicate code and cleaned up
> To: linux-media@vger.kernel.org
> 
> Signed-off-by: palash <palash.bandyopadhyay@conexant.com>
> 
>  delete mode 100644 drivers/staging/cx25821/cx25821-audups11.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video0.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video1.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video2.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video3.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video4.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video5.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video6.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-video7.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-videoioctl.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-vidups10.c
>  delete mode 100644 drivers/staging/cx25821/cx25821-vidups9.c

Hi Palash,

I've applied your patch at "staging/other" branch, and added there a few patches to cleanup
some troubles I saw on the driver. I was wanting to move it out of staging, but, unfortunately,
the driver is not ready yet.

One of the bad things I saw on the driver is this part:

$ grep /root/ drivers/staging/cx25821/*
drivers/staging/cx25821/cx25821-audio-upstream.c:			dev->_audiofilename = "/root/audioGOOD.wav";
drivers/staging/cx25821/cx25821-audio-upstream.h:char *_defaultAudioName = "/root/audioGOOD.wav";
drivers/staging/cx25821/cx25821-video-upstream.c:			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream.c:			    "/root/vidtest.yuv";
drivers/staging/cx25821/cx25821-video-upstream.c:			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream.c:			    "/root/pal422.yuv";
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:			    "/root/vidtest.yuv";
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:			    "/root/pal422.yuv";

The driver should not get any file name from userspace, not should read directly to any file.
Instead, it should be using V4L2 and ALSA API's for any kind of streams. Please fix it.

Cheers,
Mauro.

