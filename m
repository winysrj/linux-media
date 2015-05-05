Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33604 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbbEEQya (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:54:30 -0400
Received: by lbbzk7 with SMTP id zk7so133610019lbb.0
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:54:28 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv4 0/6] GoTView MasterHD 3 USB tuner
Date: Tue,  5 May 2015 19:54:13 +0300
Message-Id: <1430844859-24947-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fourth version of this patch series as there had been new si2157 devices 
that were added to the media_tree since the last submission. The 
si2157-patch in this series now takes care of those devices as well.

Olli Salonen (6):
  si2168: add support for gapped clock
  dvbsky: use si2168 config option ts_clock_gapped
  si2168: add I2C error handling
  si2157: support selection of IF interface
  rtl28xxu: add I2C read without write
  rtl2832: add support for GoTView MasterHD 3 USB tuner

 drivers/media/dvb-frontends/rtl2832.c      |   4 +
 drivers/media/dvb-frontends/rtl2832.h      |   1 +
 drivers/media/dvb-frontends/rtl2832_priv.h |  25 ++++++
 drivers/media/dvb-frontends/si2168.c       |   9 +++
 drivers/media/dvb-frontends/si2168.h       |   3 +
 drivers/media/dvb-frontends/si2168_priv.h  |   1 +
 drivers/media/pci/cx23885/cx23885-dvb.c    |   4 +
 drivers/media/pci/saa7164/saa7164-dvb.c    |   3 +
 drivers/media/pci/smipcie/smipcie.c        |   1 +
 drivers/media/tuners/si2157.c              |   4 +-
 drivers/media/tuners/si2157.h              |   6 ++
 drivers/media/tuners/si2157_priv.h         |   1 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c    |   2 +
 drivers/media/usb/dvb-usb-v2/af9035.c      |   1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c      |   5 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    | 125 ++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |   5 ++
 drivers/media/usb/dvb-usb/cxusb.c          |   1 +
 drivers/media/usb/em28xx/em28xx-dvb.c      |   2 +
 19 files changed, 197 insertions(+), 6 deletions(-)

-- 
1.9.1

