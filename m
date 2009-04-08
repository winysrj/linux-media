Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:35799 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765712AbZDHQiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 12:38:20 -0400
Message-ID: <49DCD287.3090203@oracle.com>
Date: Wed, 08 Apr 2009 09:36:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [-rc1 build failure] cx231xx-audio.c:(.text+0xd4e43): undefined
 reference to `snd_card_free'
References: <20090406215632.3eb96373@pedra.chehab.org> <20090408075642.GA2462@elte.hu>
In-Reply-To: <20090408075642.GA2462@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ingo Molnar wrote:
> * Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>>  drivers/media/video/cx231xx/Kconfig               |   35 +
>>  drivers/media/video/cx231xx/Makefile              |   14 +
> 
> FYI, there's a new build breakage here:
> 
>  drivers/built-in.o: In function `cx231xx_audio_fini':
>  cx231xx-audio.c:(.text+0xd4e43): undefined reference to `snd_card_free'
>  drivers/built-in.o: In function `cx231xx_audio_isocirq':
>  cx231xx-audio.c:(.text+0xd4fb7): undefined reference to `snd_pcm_link_rwlock'
>  cx231xx-audio.c:(.text+0xd5021): undefined reference to `snd_pcm_link_rwlock'
>  cx231xx-audio.c:(.text+0xd50bb): undefined reference to `snd_pcm_period_elapsed'
>  drivers/built-in.o: In function `snd_cx231xx_capture_open':
> 
> config attached.
> 
> I suspect the key problem is that sound is modular while cx231xx is 
> built-in:
> 
>  CONFIG_SOUND=m
>  CONFIG_VIDEO_CX231XX=y
>  CONFIG_VIDEO_CX231XX_ALSA=y
> 
> This has a similar pattern to past build breakages in this area.
> 
> 	Ingo

patch posted yesterday:
http://lkml.org/lkml/2009/4/7/400


-- 
~Randy
