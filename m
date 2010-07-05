Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:57268 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0GEHJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 03:09:37 -0400
Received: from cps (nbwsmx1.bbnet.ad [157.152.183.211]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 2BDF7242F64 for <linux-media@vger.kernel.org>; Sun, 4 Jul 2010 23:51:43 -0700 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jay Guillory" <Jay.Guillory@conexant.com>
Date: Sun, 4 Jul 2010 23:49:21 -0700
Subject: RE: [cx25821] Removed duplicate code and cleaned up
Message-ID: <34B38BE41EDBA046A4AFBB591FA3113201B9A82A@NBMBX01.bbnet.ad>
References: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
 <34B38BE41EDBA046A4AFBB591FA31132F4B404@NBMBX01.bbnet.ad>,<4C316D0C.6070707@redhat.com>
In-Reply-To: <4C316D0C.6070707@redhat.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mauro.

  I'll discuss with the team and come up with a solution for this.

  BTW, any update on the Polaris patches? I had resent the 1/2 an 2/2 patches.

Thanks,
Palash

________________________________________
From: Mauro Carvalho Chehab [mchehab@redhat.com]
Sent: Sunday, July 04, 2010 10:26 PM
To: Palash Bandyopadhyay
Cc: linux-media@vger.kernel.org; Jay Guillory
Subject: Re: [cx25821] Removed duplicate code and cleaned up

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
drivers/staging/cx25821/cx25821-audio-upstream.c:                       dev->_audiofilename = "/root/audioGOOD.wav";
drivers/staging/cx25821/cx25821-audio-upstream.h:char *_defaultAudioName = "/root/audioGOOD.wav";
drivers/staging/cx25821/cx25821-video-upstream.c:                            PIXEL_FRMT_411) ? "/root/vid411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream.c:                           "/root/vidtest.yuv";
drivers/staging/cx25821/cx25821-video-upstream.c:                            PIXEL_FRMT_411) ? "/root/pal411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream.c:                           "/root/pal422.yuv";
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:                        PIXEL_FRMT_411) ? "/root/vid411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:                       "/root/vidtest.yuv";
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:                        PIXEL_FRMT_411) ? "/root/pal411.yuv" :
drivers/staging/cx25821/cx25821-video-upstream-ch2.c:                       "/root/pal422.yuv";

The driver should not get any file name from userspace, not should read directly to any file.
Instead, it should be using V4L2 and ALSA API's for any kind of streams. Please fix it.

Cheers,
Mauro.


Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

