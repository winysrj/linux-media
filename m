Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44178 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3J3VyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 17:54:19 -0400
Received: from [82.128.187.194] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VbdiU-0004v5-5R
	for linux-media@vger.kernel.org; Wed, 30 Oct 2013 23:54:18 +0200
Message-ID: <52718009.8010906@iki.fi>
Date: Wed, 30 Oct 2013 23:54:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] RTL2832P + R828D [USB ID 15f4:0131]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patchset adds initial support for RTL2832P based device with USB ID 
15f4:0131. Device supports DVB-T/T2/C using Panasonic MN88472 
demodulator, but as there is no driver for that demodulator supports is 
reduced to DVB-T only, that is coming from RTL2832P integrated 
demodulator. I know there is someone working with that new demod driver 
too :)

Changes are very small and should not cause regression in any case.

I wrote small blog post of teardowning that device:
http://blog.palosaari.fi/2013/10/naked-hardware-14-dvb-t2-usb-tv-stick.html

regards
Antti

The following changes since commit 1957f0d71c5a6dc8c6f2435ec477ec777d080603:

   [media] s5p-mfc: remove deprecated IRQF_DISABLED (2013-10-28 16:51:50 
-0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832u_r828d

for you to fetch changes up to 27dd7e42dee0f991c98f1795991e5ba34a986ee2:

   rtl28xxu: add 15f4:0131 Astrometa DVB-T2 (2013-10-30 07:38:11 +0200)

----------------------------------------------------------------
Antti Palosaari (4):
       r820t: add support for R828D
       rtl2832: add new tuner R828D
       rtl28xxu: add RTL2832P + R828D support
       rtl28xxu: add 15f4:0131 Astrometa DVB-T2

  drivers/media/dvb-frontends/rtl2832.c   |  1 +
  drivers/media/dvb-frontends/rtl2832.h   |  1 +
  drivers/media/tuners/r820t.c            | 22 +++++++++++++---------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 42 
++++++++++++++++++++++++++++++++++++++++++
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
  5 files changed, 58 insertions(+), 9 deletions(-)



-- 
http://palosaari.fi/
