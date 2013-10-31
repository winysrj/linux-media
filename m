Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:25528 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3JaKNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 06:13:01 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVJ00IF831O7C00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Oct 2013 06:13:00 -0400 (EDT)
Date: Thu, 31 Oct 2013 08:12:55 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: Miroslav =?UTF-8?B?U2x1Z2XFiA==?= <thunder.mmm@gmail.com>,
	linux-media@vger.kernel.org,
	Miroslav =?UTF-8?B?U2x1Z2XFiA==?= <thunder.m@email.cz>
Subject: Re: cx23885: Add basic analog radio support
Message-id: <20131031081255.65111ad6@samsung.com>
In-reply-to: <524F0F57.5020605@netscape.net>
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com>
 <524F0F57.5020605@netscape.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Oct 2013 15:56:23 -0300
Alfredo Jesús Delaiti  <alfredodelaiti@netscape.net> escreveu:

> Hi all
> 
> 
> El 14/01/12 15:25, Miroslav Slugeň escribió:
> > New version of patch, fixed video modes for DVR3200 tuners and working
> > audio mux.
> 
> I tested this patch (https://linuxtv.org/patch/9498/) with the latest 
> versions of git (September 28, 2013) with my TV card (Mygica X8507) and 
> it works.
> I found some issue, although it may be through a bad implementation of mine.
> 
> Details of them:
> 
> 1) Some warning when compiling
> 
> ...
>    CC [M] 
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
> : initialization from incompatible pointer type [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner') 
> [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
> warning: initialization from incompatible pointer type [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio') 
> [enabled by default]
>    CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
> ...
> 
> --------------------------------------------------------
> static const struct v4l2_ioctl_ops radio_ioctl_ops = {
> 
>         .vidioc_s_tuner       = radio_s_tuner, /* line 1910 */
>         .vidioc_s_audio       = radio_s_audio, /* line 1911 */
> 
> --------------------------------------------------------
> 
> 2)
> No reports signal strength or stereo signal with KRadio. XC5000 neither 
> reported (modprobe xc5000 debug=1). Maybe a feature XC5000.
> To listen in stereo, sometimes, you have to turn on the Digital TV then 
> Analog TV and then radio.
> 
> 3)
> To listen Analog TV I need changed to NTSC standard and then PAL-Nc (the 
> norm in my country is PAL-Nc). If I leave the tune in NTSC no problem 
> with sound.
> The patch (https://linuxtv.org/patch/9505/) corrects the latter, if used 
> tvtime with xawtv not always.
> If I see-Digital TV (ISDB-T), then so as to listen the radio I have 
> first put the TV-Analog, because I hear very low and a strong white noise.
> The latter is likely to be corrected by resetting the tuner, I have to 
> study it more.
> 
> I put below attached the patch applied to the plate: X8507.
> 
> Have you done any update of this patch?

Hi Alfredo,

My understanding is that the patch you've enclosed is incomplete and
depends on Miroslav's patch.

As he have you his ack to rework on it, could you please prepare a
patch series addressing the above comments for us to review?

Than
-- 

Cheers,
Mauro
