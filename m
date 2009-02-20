Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:35452 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbZBTXVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 18:21:01 -0500
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id 9AF723CA79B
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 00:20:59 +0100 (CET)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net [151.189.21.57])
	by mail-in-01-z2.arcor-online.net (Postfix) with ESMTP id 8A4B12BF432
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 00:20:59 +0100 (CET)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTPSA id 268303B2A16
	for <linux-media@vger.kernel.org>; Sat, 21 Feb 2009 00:20:59 +0100 (CET)
Subject: Re: mantis build error on vanilla kernel 2.6.28.6 [Re: Terratec
	Cinergy C  HD (PCI, DVB-C): how to make it work?]
From: hermann pitton <hermann-pitton@arcor.de>
To: Linux Media <linux-media@vger.kernel.org>
In-Reply-To: <bcb3ef430902201229l2ece1a88k50d15e3886c29e01@mail.gmail.com>
References: <bcb3ef430902201229l2ece1a88k50d15e3886c29e01@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Feb 2009 00:22:15 +0100
Message-Id: <1235172135.6647.4.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 20.02.2009, 21:29 +0100 schrieb MartinG:
> Ok, I was told at #linuxtv on freenode to use a vanilla kernel, so I did:
> 
> $ wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.6.tar.bz2
> $ tar xjf linux-2.6.28.6.tar.bz2
> $ cd linux-2.6.28.6/
> $ make menuconfig
> $ sudo make modules_install install
> (reboot)
> 
> $ wget -c http://jusst.de/hg/mantis/archive/tip.tar.bz2
> $ tar xjf tip.tar.bz2
> $ cd mantis-5292a47772ad/
> $ make
> ...
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c: In
> function 'snd_card_saa7134_hw_params':
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:496:
> error: implicit declaration of function 'snd_assert'
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:497:
> error: expected expression before 'return'
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:498:
> error: expected expression before 'return'
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:499:
> error: expected expression before 'return'
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c: In
> function 'snd_card_saa7134_new_mixer':
> /home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:950:
> error: expected expression before 'return'
> make[3]: *** [/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.o]
> Error 1
> make[2]: *** [_module_/home/gronslet/Download/mantis-5292a47772ad/v4l] Error 2
> make[2]: Leaving directory `/mythmedia/buffer/linux-2.6.28.6'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/gronslet/Download/mantis-5292a47772ad/v4l'
> make: *** [all] Error 2
> 
> 
> What did I miss here?
> 
> -MartinG

you can see changes on saa7134-alsa here.

http://linuxtv.org/hg/v4l-dvb/log/359d95e1d541/linux/drivers/media/video/saa7134/saa7134-alsa.c

Likely this kernel backport is missing.

http://linuxtv.org/hg/v4l-dvb/rev/b4d664a2592a

Cheers,
Hermann


