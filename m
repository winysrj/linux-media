Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65006 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0BKV5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 16:57:42 -0500
Received: by bwz19 with SMTP id 19so958992bwz.28
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2010 13:57:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
References: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
	 <1a297b361002110651w75dd2e78k9c9a4444d35adf0a@mail.gmail.com>
Date: Thu, 11 Feb 2010 22:57:38 +0100
Message-ID: <f509f3091002111357m68739fd5t124aef0093d35456@mail.gmail.com>
Subject: Re: [linux-dvb] Twinhan dtv 3030 mantis
From: Niklas Claesson <nicke.claesson@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can't compile, I fetched the latest source with "hg clone
http://jusst.de/hg/mantis-v4l-dvb" but there seems to be a file
missing: "mantis_input.h".

  CC [M]  /home/niklas/hg/mantis-v4l-dvb/v4l/hopper_vp3028.o
/home/niklas/hg/mantis-v4l-dvb/v4l/hopper_cards.c:43:26: error:
mantis_input.h: No such file or directory

(I don't need the hopper-part I think, so I edited this line in
.config "CONFIG_DVB_HOPPER=n".)
And tried to compile again:

  CC [M]  /home/niklas/hg/mantis-v4l-dvb/v4l/mantis_vp1034.o
/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.c:51:26: error:
mantis_input.h: No such file or directory
/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.c: In function
'mantis_pci_probe':
/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.c:227: error: implicit
declaration of function 'mantis_input_init'
/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.c: In function
'mantis_pci_remove':
/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.c:250: error: implicit
declaration of function 'mantis_input_exit'
make[3]: *** [/home/niklas/hg/mantis-v4l-dvb/v4l/mantis_cards.o] Error 1

Did I do anything wrong?

Regards
Niklas Claesson
