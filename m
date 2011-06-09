Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:37680 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab1FIMoK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 08:44:10 -0400
Message-ID: <4DF0C015.1090807@linuxtv.org>
Date: Thu, 09 Jun 2011 14:44:05 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 05/13] [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
References: <cover.1307563765.git.mchehab@redhat.com> <20110608172302.3e2294af@pedra>
In-Reply-To: <20110608172302.3e2294af@pedra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/08/2011 10:23 PM, Mauro Carvalho Chehab wrote:
> While this ioctl is defined inside dvb/audio.h, it is not docummented
> at the API specs, nor implemented on any driver inside the Linux Kernel.
> So, it doesn't make sense to keep it here.
> 
> As this is not used anywere, removing it is not a regression. So,
> there's no need to use the normal features-to-be-removed process.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
> index d47bccd..c1b3555 100644
> --- a/include/linux/dvb/audio.h
> +++ b/include/linux/dvb/audio.h
> @@ -118,18 +118,6 @@ typedef __u16 audio_attributes_t;
>  #define AUDIO_SET_ATTRIBUTES       _IOW('o', 17, audio_attributes_t)
>  #define AUDIO_SET_KARAOKE          _IOW('o', 18, audio_karaoke_t)
>  
> -/**
> - * AUDIO_GET_PTS
> - *
> - * Read the 33 bit presentation time stamp as defined
> - * in ITU T-REC-H.222.0 / ISO/IEC 13818-1.
> - *
> - * The PTS should belong to the currently played
> - * frame if possible, but may also be a value close to it
> - * like the PTS of the last decoded frame or the last PTS
> - * extracted by the PES parser.
> - */
> -#define AUDIO_GET_PTS              _IOR('o', 19, __u64)
>  #define AUDIO_BILINGUAL_CHANNEL_SELECT _IO('o', 20)
>  
>  #endif /* _DVBAUDIO_H_ */

Please don't apply this patch. In general, many ioctls aren't
implemented in mainline drivers, because most if not all supported
devices inside the kernel tree are either PCI or USB add-in devices and
usually quite simple compared to a STB.

This ioctl is used at least by enigma2 in userspace and implemented in
drivers for several generations of the dreambox.

Regards,
Andreas
