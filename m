Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:36656 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480AbZGQBcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 21:32:33 -0400
Received: by pzk35 with SMTP id 35so336516pzk.33
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 18:32:32 -0700 (PDT)
Subject: Re: AVerMedia AVerTV GO 007 FM, no radio sound (with routing
 enabled)
From: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
To: Laszlo Kustan <lkustan@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
References: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 08:32:26 +0700
Message-Id: <1247794346.3921.22.camel@AcerAspire4710>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I read somewhere that the radio had ever worked for this card but has
stopped working with newer kernels. I had the same problem when I used
my card (AverMedia AverTV GO 007 FM Plus) with card=57 before. Radio had
worked with old kernel versions.
Try this:
hg clone http://linuxtv.org/hg/v4l-dvb
Edit v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c, go to
entry [SAA7134_BOARD_AVERMEDIA_GO_007_FM], in .radio = { ... },
change .amux = LINE1 to .amux = TV
make
then
sudo make install
and reboot.
I don't know why someone has changed it to LINE1. But if the
modification works for you, I think we need to modify a bit.
Please let us know if it works.

