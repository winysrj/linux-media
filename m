Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50674 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbbELP0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 11:26:16 -0400
Message-ID: <55521B96.4030903@iki.fi>
Date: Tue, 12 May 2015 18:26:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: [GIT PULL] GoTView MasterHD 3 USB tuner
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b2624ff4bf46869df66148b2e1e675981565742e:

   [media] mantis: fix error handling (2015-05-12 08:12:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git si2168

for you to fetch changes up to 0fa6e6a14e433b5b5daf836b88cde9cca26290a8:

   rtl2832: add support for GoTView MasterHD 3 USB tuner (2015-05-12 
18:22:44 +0300)

----------------------------------------------------------------
Olli Salonen (6):
       si2168: add support for gapped clock
       dvbsky: use si2168 config option ts_clock_gapped
       si2168: add I2C error handling
       si2157: support selection of IF interface
       rtl28xxu: add I2C read without write
       rtl2832: add support for GoTView MasterHD 3 USB tuner

  drivers/media/dvb-frontends/rtl2832.c      |   4 ++++
  drivers/media/dvb-frontends/rtl2832.h      |   1 +
  drivers/media/dvb-frontends/rtl2832_priv.h |  25 +++++++++++++++++++++++++
  drivers/media/dvb-frontends/si2168.c       |   9 +++++++++
  drivers/media/dvb-frontends/si2168.h       |   3 +++
  drivers/media/dvb-frontends/si2168_priv.h  |   1 +
  drivers/media/pci/cx23885/cx23885-dvb.c    |   4 ++++
  drivers/media/pci/saa7164/saa7164-dvb.c    |   3 +++
  drivers/media/pci/smipcie/smipcie.c        |   1 +
  drivers/media/tuners/si2157.c              |   4 +++-
  drivers/media/tuners/si2157.h              |   6 ++++++
  drivers/media/tuners/si2157_priv.h         |   1 +
  drivers/media/usb/cx231xx/cx231xx-dvb.c    |   2 ++
  drivers/media/usb/dvb-usb-v2/af9035.c      |   1 +
  drivers/media/usb/dvb-usb-v2/dvbsky.c      |   5 ++++-
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c    | 125 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |   5 +++++
  drivers/media/usb/dvb-usb/cxusb.c          |   1 +
  drivers/media/usb/em28xx/em28xx-dvb.c      |   2 ++
  19 files changed, 197 insertions(+), 6 deletions(-)

-- 
http://palosaari.fi/
