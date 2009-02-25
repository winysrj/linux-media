Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:60832 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346AbZBYXYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 18:24:08 -0500
Subject: Re: [linux-dvb] Compiling mantis-5292a47772ad
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <20090225215749.GA4385@upcore.net>
References: <20090225215749.GA4385@upcore.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 00:25:14 +0100
Message-Id: <1235604314.2704.2.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 25.02.2009, 22:57 +0100 schrieb Magnus Nilsson:
> Hello,
> 
> I'm trying to compile mantis-5292a47772ad under 2.6.28.7 (have tried
> this under 2.6.28.5 and 2.6.24 (which I'm currently running) with same
> results).
> 
> The error I'm getting is:
> 
> [root@mythbox /usr/local/src/mantis-5292a47772ad]# make all
> *snip*
>   CC [M]  /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.o
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_hw_params':
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:496: error: implicit declaration of function 'snd_assert'
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:497: error: expected expression before 'return'
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:498: error: expected expression before 'return'
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:499: error: expected expression before 'return'
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c: In function 'snd_card_saa7134_new_mixer':
> /usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.c:950: error: expected expression before 'return'
> make[3]: *** [/usr/local/src/mantis-5292a47772ad/v4l/saa7134-alsa.o] Error 1
> make[2]: *** [_module_/usr/local/src/mantis-5292a47772ad/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.28.7'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/usr/local/src/mantis-5292a47772ad/v4l'
> make: *** [all] Error 2
> *snip*
> 
> I'm not quite sure which version of the mantis driver I'm using now, but
> it's at least from september 2008. I'm running this under Debian lenny,
> with a VP-2040 and a Terratec Cinergy 1200C.
> 
> Thanks,
> Magnus
> 

at least this kernel backport patch is missing.
http://linuxtv.org/hg/v4l-dvb/rev/b4d664a2592a

But you can also simply disable saa7134-alsa dma sound support in make
xconfig/menuconfig etc.

Cheers,
Hermann


