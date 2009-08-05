Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:42291 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZHETlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 15:41:52 -0400
Received: from [192.168.1.21] (151.59.219.5) by cp-out8.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A79A60C00049589 for linux-media@vger.kernel.org; Wed, 5 Aug 2009 21:41:52 +0200
Message-ID: <4A79E07F.1000301@iol.it>
Date: Wed, 05 Aug 2009 21:41:51 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it> <4A7140DD.7040405@iol.it>	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>	 <4A729117.6010001@iol.it>	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>	 <4A739DD6.8030504@iol.it>	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>	 <4A79320B.7090401@iol.it>	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>	 <4A79CEBD.1050909@iol.it> <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
In-Reply-To: <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> Try running this:
> 
> find /lib/modules/ -name "em28*"
> 
> Then pastebin the output and send us a link.

efa@01ath3200:~$ find /lib/modules/ -name "em28*"
/lib/modules/2.6.24-21-generic/empia/em28xx-audioep.ko
/lib/modules/2.6.24-21-generic/empia/em28xx-dvb.ko
/lib/modules/2.6.24-21-generic/empia/em28xx-cx25843.ko
/lib/modules/2.6.24-21-generic/empia/em28xx.ko
/lib/modules/2.6.24-21-generic/empia/em28xx-audio.ko
/lib/modules/2.6.24-21-generic/empia/em28xx-aad.ko
/lib/modules/2.6.27-14-generic/empia/em28xx-audioep.ko
/lib/modules/2.6.27-14-generic/empia/em28xx-dvb.ko
/lib/modules/2.6.27-14-generic/empia/em28xx-cx25843.ko
/lib/modules/2.6.27-14-generic/empia/em28xx.ko
/lib/modules/2.6.27-14-generic/empia/em28xx-audio.ko
/lib/modules/2.6.27-14-generic/empia/em28xx-aad.ko
/lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx
/lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
/lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
/lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko
/lib/modules/2.6.28-14-generic/empia/em28xx-audioep.ko
/lib/modules/2.6.28-14-generic/empia/em28xx-dvb.ko
/lib/modules/2.6.28-14-generic/empia/em28xx-cx25843.ko
/lib/modules/2.6.28-14-generic/empia/em28xx.ko
/lib/modules/2.6.28-14-generic/empia/em28xx-audio.ko
/lib/modules/2.6.28-14-generic/empia/em28xx-aad.ko
/lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx
/lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
/lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
/lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko
/lib/modules/2.6.28-13-generic/kernel/drivers/media/video/em28xx
/lib/modules/2.6.27-9-generic/empia/em28xx-audioep.ko
/lib/modules/2.6.27-9-generic/empia/em28xx-dvb.ko
/lib/modules/2.6.27-9-generic/empia/em28xx-cx25843.ko
/lib/modules/2.6.27-9-generic/empia/em28xx.ko
/lib/modules/2.6.27-9-generic/empia/em28xx-audio.ko
/lib/modules/2.6.27-9-generic/empia/em28xx-aad.ko
/lib/modules/2.6.27-11-generic/empia/em28xx-audioep.ko
/lib/modules/2.6.27-11-generic/empia/em28xx-dvb.ko
/lib/modules/2.6.27-11-generic/empia/em28xx-cx25843.ko
/lib/modules/2.6.27-11-generic/empia/em28xx.ko
/lib/modules/2.6.27-11-generic/empia/em28xx-audio.ko
/lib/modules/2.6.27-11-generic/empia/em28xx-aad.ko

there's all the history of modules I compiled for past kernels, and that 
I keep installed

> Also send us the output of:
> 
> uname -a

efa@01ath3200:~$ uname -a
Linux 01ath3200 2.6.28-14-generic #47-Ubuntu SMP Sat Jul 25 00:28:35 UTC 
2009 i686 GNU/Linux

the last stable from Ubuntu 9.04

Valerio
