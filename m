Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58664 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbaGNRQC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:16:02 -0400
Message-ID: <53C41050.7030404@iki.fi>
Date: Mon, 14 Jul 2014 20:16:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: [GIT PULL] si2157, si2168, cxusb, TechnoTrend TVStick CT2-4400
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olli hacked support for TechnoTrend TVStick CT2-4400.

http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400

USB ID 0b48:3014.
USB interface: Cypress CY7C68013A-56LTXC
Demodulator: Silicon Labs Si2168-30
Tuner: Silicon Labs Si2158-20

I have reviewed all the code.

regards
Antti


The following changes since commit 3445857b22eafb70a6ac258979e955b116bfd2c6:

   [media] hdpvr: fix two audio bugs (2014-07-04 15:13:02 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs

for you to fetch changes up to bd97124d726a97297f899d9725add87c873f4fc5:

   si2157: rework firmware download logic a little bit (2014-07-14 
20:05:40 +0300)

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

Olli Salonen (6):
       si2168: Small typo fix (SI2157 -> SI2168)
       si2168: Add support for chip revision Si2168 A30
       si2157: Move chip initialization to si2157_init
       si2157: Add support for Si2158 chip
       si2157: Set delivery system and bandwidth before tuning
       cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support

  drivers/media/dvb-core/dvb-usb-ids.h      |   1 +
  drivers/media/dvb-frontends/si2168.c      | 240 
++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------------
  drivers/media/dvb-frontends/si2168_priv.h |   8 +++--
  drivers/media/tuners/si2157.c             | 243 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
  drivers/media/tuners/si2157.h             |   2 +-
  drivers/media/tuners/si2157_priv.h        |   8 +++--
  drivers/media/usb/dvb-usb/Kconfig         |   3 ++
  drivers/media/usb/dvb-usb/cxusb.c         | 191 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  drivers/media/usb/dvb-usb/cxusb.h         |   2 ++
  9 files changed, 467 insertions(+), 231 deletions(-)

-- 
http://palosaari.fi/
