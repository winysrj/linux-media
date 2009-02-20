Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:46383 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZBTU3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 15:29:49 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2080579fgg.17
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2009 12:29:47 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 21:29:47 +0100
Message-ID: <bcb3ef430902201229l2ece1a88k50d15e3886c29e01@mail.gmail.com>
Subject: mantis build error on vanilla kernel 2.6.28.6 [Re: Terratec Cinergy C
	HD (PCI, DVB-C): how to make it work?]
From: MartinG <gronslet@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I was told at #linuxtv on freenode to use a vanilla kernel, so I did:

$ wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.6.tar.bz2
$ tar xjf linux-2.6.28.6.tar.bz2
$ cd linux-2.6.28.6/
$ make menuconfig
$ sudo make modules_install install
(reboot)

$ wget -c http://jusst.de/hg/mantis/archive/tip.tar.bz2
$ tar xjf tip.tar.bz2
$ cd mantis-5292a47772ad/
$ make
...
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c: In
function 'snd_card_saa7134_hw_params':
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:496:
error: implicit declaration of function 'snd_assert'
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:497:
error: expected expression before 'return'
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:498:
error: expected expression before 'return'
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:499:
error: expected expression before 'return'
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c: In
function 'snd_card_saa7134_new_mixer':
/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.c:950:
error: expected expression before 'return'
make[3]: *** [/home/gronslet/Download/mantis-5292a47772ad/v4l/saa7134-alsa.o]
Error 1
make[2]: *** [_module_/home/gronslet/Download/mantis-5292a47772ad/v4l] Error 2
make[2]: Leaving directory `/mythmedia/buffer/linux-2.6.28.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/gronslet/Download/mantis-5292a47772ad/v4l'
make: *** [all] Error 2


What did I miss here?

-MartinG
