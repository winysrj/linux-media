Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1KCPni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 11:43:38 -0400
Received: by iage36 with SMTP id e36so1465381iag.19
        for <linux-media@vger.kernel.org>; Thu, 03 Nov 2011 08:43:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 11:43:38 -0400
Message-ID: <CAOcJUbybUwq9Oc=torsnfiUO5ThQoH4pugjamSnxy9UMom2=gw@mail.gmail.com>
Subject: [PULL] git://linuxtv.org/mkrufky/tuners if_freq
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I've pushed some additional patches since my last "mxl111sf bug-fix"
patches, all into a single branch.  This fixes an actual bug in the
mxl111sf driver, and also adds the get_if_frequency calls to three
tuner drivers.  Please merge.

Please note that I still have a pending pull request from the same
tree waiting for merge - the "atscdemod" branch.  Please merge both
branches as soon as you can.


The following changes since commit a63366b935456dd0984f237642f6d4001dcf8017:
  Michael Krufky (1):
        [media] mxl111sf: update demod_ops.info.name to "MaxLinear
MxL111SF DVB-T demodulator"

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners if_freq

Michael Krufky (7):
      mxl111sf: fix return value of mxl111sf_idac_config
      mxl111sf: check for errors after mxl111sf_write_reg in
mxl111sf_idac_config
      mxl111sf: remove pointless if condition in mxl111sf_config_spi
      mxl111sf: fix build warning: variable âretâ set but not used in
function âmxl111sf_i2c_readagainâ
      mxl111sf: add mxl111sf_tuner_get_if_frequency
      mxl5007t: add mxl5007t_get_if_frequency
      tda18271: add tda18271_get_if_frequency

 drivers/media/common/tuners/mxl5007t.c      |   49 +++++++++++++++++++++++
 drivers/media/common/tuners/tda18271-fe.c   |   10 +++++
 drivers/media/common/tuners/tda18271-priv.h |    2 +
 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c    |    3 +-
 drivers/media/dvb/dvb-usb/mxl111sf-phy.c    |    7 ++-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c  |   56 ++++++++++++++++++++++++++-
 6 files changed, 121 insertions(+), 6 deletions(-)

Best regards,

Michael Krufky
