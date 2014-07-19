Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbaGSCmZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:42:25 -0400
Message-ID: <53C9DB0E.4040007@iki.fi>
Date: Sat, 19 Jul 2014 05:42:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Matthias Schwarzott <zzam@gentoo.org>,
	Luis Alves <ljalvs@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: [GIT PULL 3.17] si2157 / si2168 changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3445857b22eafb70a6ac258979e955b116bfd2c6:

   [media] hdpvr: fix two audio bugs (2014-07-04 15:13:02 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs

for you to fetch changes up to 768f14155d06cb8eb944a6e611c0cb777664d9cc:

   si2157: Add get_if_frequency callback (2014-07-19 05:37:46 +0300)

----------------------------------------------------------------
Antti Palosaari (12):
       si2157: implement sleep
       si2168: implement sleep
       si2168: set cmd args using memcpy
       si2168: implement CNR statistic
       si2157: add read data support for fw cmd func
       si2168: remove duplicate command
       si2168: do not set values which are already on default
       si2168: receive 4 bytes reply from cmd 0x14
       si2168: advertise Si2168 A30 firmware
       si2157: advertise Si2158 A20 firmware
       si2168: few firmware download changes
       si2157: rework firmware download logic a little bit

Luis Alves (4):
       si2168: Set symbol rate for DVB-C
       si2168: Fix i2c_add_mux_adapter return value
       si2168: Remove testing for demod presence on probe.
       si2168: Support Si2168-A20 firmware downloading.

Matthias Schwarzott (4):
       cxusb: Prepare for si2157 driver getting more parameters
       em28xx-dvb: Prepare for si2157 driver getting more parameters
       si2157: Add support for spectral inversion
       si2157: Add get_if_frequency callback

Olli Salonen (8):
       si2168: Small typo fix (SI2157 -> SI2168)
       si2168: Add support for chip revision Si2168 A30
       si2157: Move chip initialization to si2157_init
       si2157: Add support for Si2158 chip
       si2157: Set delivery system and bandwidth before tuning
       cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support
       si2168: improve scanning performance
       si2157: Use name si2157_ops instead of si2157_tuner_ops

  drivers/media/dvb-core/dvb-usb-ids.h      |   1 +
  drivers/media/dvb-frontends/si2168.c      | 266 
+++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------
  drivers/media/dvb-frontends/si2168_priv.h |   9 +++--
  drivers/media/tuners/si2157.c             | 257 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
  drivers/media/tuners/si2157.h             |   7 +++-
  drivers/media/tuners/si2157_priv.h        |   9 +++--
  drivers/media/usb/dvb-usb/Kconfig         |   3 ++
  drivers/media/usb/dvb-usb/cxusb.c         | 192 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  drivers/media/usb/dvb-usb/cxusb.h         |   2 ++
  drivers/media/usb/em28xx/em28xx-dvb.c     |   1 +
  10 files changed, 510 insertions(+), 237 deletions(-)

-- 
http://palosaari.fi/
