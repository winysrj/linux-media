Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60563 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaHZAg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 20:36:56 -0400
Message-ID: <53FBD6A0.7000405@iki.fi>
Date: Tue, 26 Aug 2014 03:36:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Bimow Chen <Bimow.Chen@ite.com.tw>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [GIT PULL stable] IT9135 changes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
Could you pull these and send to stable as tagged per each patch. That 
patch set mainly increases sensitivity of the IT9135 chipset. It must be 
considered as a regression because IT9135 driver was replaced by AF9035 
(USB IF) + AF9033 (DVB-T demod) + IT913x (RF tuner) drivers starting 
from kernel 3.15.

I did a bunch of measurements with IT9135AX and IT9135BX devices. 
Sensitivity increases around 5 dB.

I measured -81dBm for IT9135BX and -79dBm for IT9135AX. Windows driver 
performs a little bit better still - for both chip versions around -82dBm.

I didn't noticed any sensitivity difference between old and new firmware.

regards
Antti


The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

   [media] media: ttpci: fix av7110 build to be compatible with 
CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git it9135_sensitivity_regression

for you to fetch changes up to 4a6845470d614a857c507c8f212c3d4b2c4b3dca:

   af9035: new IDs: add support for PCTV 78e and PCTV 79e (2014-08-26 
03:15:30 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       af9033: feed clock to RF tuner

Bimow Chen (2):
       af9033: update IT9135 tuner inittabs
       it913x: init tuner on attach

Malcolm Priestley (1):
       af9035: new IDs: add support for PCTV 78e and PCTV 79e

  drivers/media/dvb-core/dvb-usb-ids.h      |  2 ++
  drivers/media/dvb-frontends/af9033.c      | 13 +++++++++++++
  drivers/media/dvb-frontends/af9033_priv.h | 20 +++++++++-----------
  drivers/media/tuners/tuner_it913x.c       |  6 ++++++
  drivers/media/usb/dvb-usb-v2/af9035.c     |  4 ++++
  5 files changed, 34 insertions(+), 11 deletions(-)


-- 
http://palosaari.fi/
