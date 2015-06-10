Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35146 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbbFJJxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 05:53:44 -0400
Message-ID: <55780923.5060106@iki.fi>
Date: Wed, 10 Jun 2015 12:53:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [GIT PULL] ts2020 changes (+few more)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9056a23ba19d911d4a079b8ca543fb8ebffa7c56:

   [media] dvb-frontend: Replace timeval with ktime_t (2015-06-09 
21:09:51 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git ts2020_pull

for you to fetch changes up to 66baf807b9d4bfe2b7c246058bbffd8592e0abb8:

   lmedm04: Enable dont_poll for TS2020 tuner. (2015-06-10 12:38:58 +0300)

----------------------------------------------------------------
Antti Palosaari (7):
       ts2020: re-implement PLL calculations
       ts2020: improve filter limit calc
       ts2020: register I2C driver from legacy media attach
       ts2020: convert to regmap I2C API
       m88ds3103: rename variables and correct logging
       m88ds3103: use regmap for I2C register access
       em28xx: PCTV 461e use I2C client for demod and SEC

David Howells (5):
       ts2020: Add a comment about lifetime of on-stack pdata in 
ts2020_attach()
       TS2020: Calculate tuner gain correctly
       ts2020: Provide DVBv5 API signal strength
       ts2020: Copy loop_through from the config to the internal data
       ts2020: Allow stats polling to be suppressed

Malcolm Priestley (1):
       lmedm04: Enable dont_poll for TS2020 tuner.

  drivers/media/dvb-frontends/Kconfig          |   6 +-
  drivers/media/dvb-frontends/m88ds3103.c      | 753 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------
  drivers/media/dvb-frontends/m88ds3103.h      |   4 +-
  drivers/media/dvb-frontends/m88ds3103_priv.h |  10 +-
  drivers/media/dvb-frontends/ts2020.c         | 590 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
  drivers/media/dvb-frontends/ts2020.h         |  17 +++-
  drivers/media/pci/cx23885/cx23885-dvb.c      |   3 +
  drivers/media/usb/dvb-usb-v2/dvbsky.c        |   2 +
  drivers/media/usb/dvb-usb-v2/lmedm04.c       |   1 +
  drivers/media/usb/em28xx/em28xx-dvb.c        | 136 
+++++++++++++++----------
  10 files changed, 779 insertions(+), 743 deletions(-)

-- 
http://palosaari.fi/
