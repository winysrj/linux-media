Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45013 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbaIDVxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 17:53:05 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XPexk-0003KR-Mq
	for linux-media@vger.kernel.org; Fri, 05 Sep 2014 00:53:04 +0300
Message-ID: <5408DF3D.7070604@iki.fi>
Date: Fri, 05 Sep 2014 00:53:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] af9035/it9135 changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

   [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 9507ed6ce19644d0078e0d68af8e4ee73c7eba4b:

   af9035: remove I2C client differently (2014-09-05 00:45:49 +0300)

----------------------------------------------------------------
Antti Palosaari (41):
       af9033: feed clock to RF tuner
       af9033: provide dyn0_clk clock source
       af9035: enable AF9033 demod clock source for IT9135
       it913x: fix tuner sleep power leak
       it913x: avoid division by zero on error case
       it913x: fix IT9135 AX sleep
       af9035: remove AVerMedia eeprom override
       af9035: make checkpatch.pl happy
       af9033: make checkpatch.pl happy
       it913x: make checkpatch.pl happy
       it913x: rename tuner_it913x => it913x
       af9035: do not attach IT9135 tuner
       it913x: convert to I2C driver
       af9035: use I2C it913x tuner driver
       it913x: change reg read/write routines more common
       it913x: rename 'state' to 'dev'
       it913x: convert to RegMap API
       it913x: re-implement sleep
       it913x: remove dead code
       it913x: get rid of script loader and and private header file
       it913x: refactor code largely
       it913x: replace udelay polling with jiffies
       af9033: fix firmware version logging
       af9033: rename 'state' to 'dev'
       af9033: convert to I2C client
       af9033: clean up logging
       af9035: few small I2C master xfer changes
       af9033: remove I2C addr from config
       af9035: replace PCTV device model numbers with name
       MAINTAINERS: IT913X driver filenames
       af9033: implement DVBv5 statistic for signal strength
       af9033: implement DVBv5 statistic for CNR
       af9033: wrap DVBv3 read SNR to DVBv5 CNR
       af9033: implement DVBv5 stat block counters
       af9033: implement DVBv5 post-Viterbi BER
       af9033: wrap DVBv3 UCB to DVBv5 UCB stats
       af9033: wrap DVBv3 BER to DVBv5 BER
       af9033: remove all DVBv3 stat calculation logic
       dvb-usb-v2: add frontend_detach callback
       dvb-usb-v2: add tuner_detach callback
       af9035: remove I2C client differently

Bimow Chen (3):
       af9033: update IT9135 tuner inittabs
       it913x: init tuner on attach
       get_dvb_firmware: Update firmware of ITEtech IT9135

Malcolm Priestley (1):
       af9035: new IDs: add support for PCTV 78e and PCTV 79e

  Documentation/dvb/get_dvb_firmware                |  24 +++--
  MAINTAINERS                                       |   2 +-
  drivers/media/dvb-core/dvb-usb-ids.h              |   2 +
  drivers/media/dvb-frontends/af9033.c              | 738 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
  drivers/media/dvb-frontends/af9033.h              |  58 ++++------
  drivers/media/dvb-frontends/af9033_priv.h         |  21 ++--
  drivers/media/tuners/Kconfig                      |   1 +
  drivers/media/tuners/Makefile                     |   2 +-
  drivers/media/tuners/it913x.c                     | 478 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/tuners/{tuner_it913x.h => it913x.h} |  41 +++++---
  drivers/media/tuners/tuner_it913x.c               | 447 
-----------------------------------------------------------------------------
  drivers/media/tuners/tuner_it913x_priv.h          |  78 --------------
  drivers/media/usb/dvb-usb-v2/af9035.c             | 322 
++++++++++++++++++++++++++++++++++++++++++++-----------
  drivers/media/usb/dvb-usb-v2/af9035.h             |   6 +-
  drivers/media/usb/dvb-usb-v2/dvb_usb.h            |   3 +
  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c       |  24 ++++-
  16 files changed, 1252 insertions(+), 995 deletions(-)
  create mode 100644 drivers/media/tuners/it913x.c
  rename drivers/media/tuners/{tuner_it913x.h => it913x.h} (67%)
  delete mode 100644 drivers/media/tuners/tuner_it913x.c
  delete mode 100644 drivers/media/tuners/tuner_it913x_priv.h

-- 
http://palosaari.fi/
