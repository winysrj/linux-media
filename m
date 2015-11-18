Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36490 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbKRPOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 10:14:31 -0500
Received: by qgad10 with SMTP id d10so29912800qga.3
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2015 07:14:31 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Nov 2015 17:14:30 +0200
Message-ID: <CAFrxexg3nVqAvG5mT8HKiDUpm5DDH0uKvuGb2zvJRfVEs2BqmQ@mail.gmail.com>
Subject: saa7134 card help request
From: Alec Rusanda <alecg.rusanda@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, i have trouble installing a saa7134 card who is a pain in the
grrrrrr......
My board is a AOP-9104A with chipset PI7C8140A MA 0514BT with 4 channels.

I`m running a FedoraCore 23 64bit (4.2.3-300.fc23.x86_64) at the
moment (i can change it on whatever is need less windows) and have
tried to set in /etc/modprobe.d/saa7134.conf

" options saa7134 card=21,21,21,21   || also 33,42,61,81,109  "

but on each one i get " saa7134: saa7134[1]: Huh, no eeprom present (err=-5)? "

I have also found on internet a script for probing each card model:

#!/bin/bash
card=1
while [ $card -lt 175 ] ; do
    /etc/init.d/motion stop
    lsmod | cut -d ' ' -f 1 | grep saa713 | xargs rmmod
    modprobe saa7134 card=$card,$card,$card,$card
    /etc/init.d/motion restart
    echo "Give it a shot for card $card"
    read junk
    /etc/init.d/motion stop
    card=$(($card+1))
done

Unfortunately, on this one i got also errors :
rmmod: ERROR: Module saa7134_alsa is in use
rmmod: ERROR: Module saa7134 is in use by: saa7134_alsa

Also on rmmod --force i get :

rmmod: ERROR: could not remove 'saa7134_alsa': Device or resource busy
rmmod: ERROR: could not remove module saa7134_alsa: Device or resource busy
rmmod: ERROR: could not remove 'saa7134': Resource temporarily unavailable
rmmod: ERROR: could not remove module saa7134: Resource temporarily unavailable

# lsmod | grep saa713
saa7134_alsa           20480   -1
saa7134                   188416   1  saa7134_alsa
videobuf2_core         49152    1  saa7134
videobuf2_dma_sg   20480    1  saa7134
tveeprom                   24576   1  saa7134
rc_core                      28672   1  saa7134
v4l2_common           16384    2  saa7134,videobuf2_core
videodev                   163840  3  saa7134,v4l2_common,videobuf2_core
snd_pcm                   114688  5
snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel,saa7134_alsa,snd_hda_core
snd                            77824  11 snd_hda_codec_realtek ,
snd_hwdep,snd_timer, snd_hda_codec_hdmi,
                                   snd_pcm,snd_seq,
snd_hda_codec_generic,  snd_hda_codec,  snd_hda_intel,
snd_seq_device, saa7134_alsa


Thank you in advanced, and wish a great day all.
