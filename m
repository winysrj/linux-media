Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39398 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2FMQwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 12:52:25 -0400
Received: by yenl2 with SMTP id l2so152091yen.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 09:52:25 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 18:52:24 +0200
Message-ID: <CAPz3gm=aE1JcacNyjQisPg5MjAjE-CF2ne44n5YSP=iANJg-8g@mail.gmail.com>
Subject: cx88-alsa and alsamixer
From: shacky <shacky83@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I'm using the cx88-alsa module on Ubuntu 11.04 on kernel 2.6.38-12-server.
It is correctly loaded and it recognizes my DVB-S PCI card (Hauppauge
WinTV Nova-S Plus):

dvr@LV1:~$ arecord -l
**** Lista di CAPTURE dispositivi hardware ****
scheda 0: NVidia [HDA NVidia], dispositivo 0: VT1708S Analog [VT1708S Analog]
  Sottoperiferiche: 2/2
  Sottoperiferica #0: subdevice #0
  Sottoperiferica #1: subdevice #1
scheda 1: CX8801 [Conexant CX8801], dispositivo 0: CX88 Digital [CX88 Digital]
  Sottoperiferiche: 1/1
  Sottoperiferica #0: subdevice #0

The problem is that even if I see the cx88-alsa managed card in
alsamixer, I cannot set any level for the capture device, so whenever
I record something from that audio input the sound is very loud and
distorted.

I tried with the "volume=" parameter of mplayer, but it does not work.

Could you help me, please?

Thank you very much!
Bye.
