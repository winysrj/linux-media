Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39891 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1KYANY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 19:13:24 -0500
Received: by bke11 with SMTP id 11so3611619bke.19
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 16:13:23 -0800 (PST)
Date: Fri, 25 Nov 2011 10:13:17 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	linux-media@vger.kernel.org, fabbione@redhat.com
Subject: Re: [PATCH] Fix tm6010 audio
Message-ID: <20111125101317.1794963d@glory.local>
In-Reply-To: <4ECE6EBC.8020006@redhat.com>
References: <4E8C5675.8070604@arcor.de>
	<20111017155537.6c55aec8@glory.local>
	<4E9C65CD.2070409@arcor.de>
	<20111108104500.2f0fc14f@glory.local>
	<4ECE6EBC.8020006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

> Em 07-11-2011 22:45, Dmitri Belimov escreveu:
> > Hi
> > 
> > I found why audio dosn't work for me and fix it.
> > 
> > 2Stefan:
> > The V4L2_STD_DK has V4L2_STD_SECAM_DK but not equal 
> > switch-case statement not worked
> > 
> > you can use 
> > if (dev->norm & V4L2_STD_DK) { 
> > }
> > 
> > This patch fix this problem.
> > 
> > Other, please don't remove any workarounds without important reason.
> > For your chip revision it can be work but for other audio will be
> > bad.
> > 
> > I can watch TV but radio not work. After start Gnomeradio I see 
> > VIDIOCGAUDIO incorrect
> > VIDIOCSAUDIO incorrect
> > VIDIOCSFREQ incorrect
> > 
> > Try found what happens with radio.
> 
> This patch has several issues. The usage of switch for video doesn't
> work well. A better approach follows. Not tested yet.
> 
> PS.: I couldn't test it: not sure why, but the audio source is not
> working for me: arecord is not able to read from the device input.

URB_MSG_AUDIO is zero size no data for fill to audio buffer.

for watch TV I used this command

mplayer -v tv:// -tv driver=v4l2:fps=25:outfmt=i420:width=720:height=576:alsa:adevice=hw.1,0:amode=1:audiorate=48000:forceaudio:immediatemode=0:freq=77.25:normid=15 -aspect 4:3 -vo xv

AFTER this command radio can works

URB_MSG_AUDIO is not zero and audio buffer filled.

I think incorrect init a register. When I start mplayer a register set correct mode and audio
via arecord and sox can work.

I try found it.

With my best regards, Dmitry.

> -
> [media] tm6000: Fix tm6010 audio standard selection
> 
> A V4L2 standards mask may contain several standards. A more restricted
> mask with just one standard is used when user needs to bind to an
> specific standard that can't be auto-detect among a more generic mask.
> 
> So, Improve the autodetection logic to detect the correct audio
> standard most of the time.
> 
> Based on a patch made by Dmitri Belimov <d.belimov@gmail.com>.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> diff --git a/drivers/media/video/tm6000/tm6000-core.c
> b/drivers/media/video/tm6000/tm6000-core.c index 9783616..55d097e
> 100644 --- a/drivers/media/video/tm6000/tm6000-core.c
> +++ b/drivers/media/video/tm6000/tm6000-core.c
> @@ -696,11 +696,13 @@ int tm6000_set_audio_rinput(struct tm6000_core
> *dev) if (dev->dev_type == TM6010) {
>  		/* Audio crossbar setting, default SIF1 */
>  		u8 areg_f0;
<snip>
> +				0x30, 0xf0);
>  			break;
>  		default:
>  			break;
