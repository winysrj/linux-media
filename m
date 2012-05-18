Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806Ab2ERTNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 15:13:21 -0400
Received: from dyn3-82-128-185-236.psoas.suomi.net ([82.128.185.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SVSc4-0002XP-0y
	for linux-media@vger.kernel.org; Fri, 18 May 2012 22:13:20 +0300
Message-ID: <4FB69F4F.1050502@iki.fi>
Date: Fri, 18 May 2012 22:13:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.5] RTL2831U changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Mauro,
PULL these for 3.5.

The following changes since commit a73d06b082bdf3eccfa910de75242798ff272a4e:

   em28xx: disable LNA - PCTV QuatroStick nano (520e) (2012-05-18 
21:23:05 +0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git rtl2831u

Antti Palosaari (6):
       rtl2830: implement .read_snr()
       rtl2830: implement .read_ber()
       rtl2830: implement .read_signal_strength()
       rtl2830: implement .get_frontend()
       rtl2830: prevent hw access when sleeping
       rtl28xxu: add small sleep for rtl2830 demod attach

  drivers/media/dvb/dvb-usb/rtl28xxu.c       |    3 +
  drivers/media/dvb/frontends/rtl2830.c      |  201 
+++++++++++++++++++++++++++-
  drivers/media/dvb/frontends/rtl2830_priv.h |    1 +
  3 files changed, 202 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
