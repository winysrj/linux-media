Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49027 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LXI24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 03:28:56 -0500
Received: by mail-ee0-f49.google.com with SMTP id c4so3348834eek.36
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2012 00:28:55 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] separate Montage ts2020 from ds3000 and rs2000, support for new TeVii cards
Date: Mon, 24 Dec 2012 11:23:56 +0300
Message-ID: <1541475.yBqmJOQMfq@useri>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:

  [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)

are available in the git repository at:

  git://git.linuxtv.org/liplianin/media_tree.git ts2020_v3.9

for you to fetch changes up to 2ff52e6f487c2ee841f3df9709d1b4e4416a1b15:

  ts2020: separate from m88rs2000 (2012-12-24 01:26:12 +0300)

----------------------------------------------------------------
Igor M. Liplianin (4):
      Tevii S421 and S632 support
      m88rs2000: SNR BER implemented
      ds3000: lock led procedure added
      ts2020: separate from m88rs2000

Konstantin Dimitrov (3):
      ds3000: remove ts2020 tuner related code
      ts2020: add ts2020 tuner driver
      make the other drivers take use of the new ts2020 driver

 drivers/media/dvb-frontends/Kconfig     |   7 +++
 drivers/media/dvb-frontends/Makefile    |   1 +
 drivers/media/dvb-frontends/ds3000.c    | 255 +++++++++++++-------------------------------------------------------------------------
 drivers/media/dvb-frontends/ds3000.h    |  10 ++--
 drivers/media/dvb-frontends/m88rs2000.c | 420 +++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------
 drivers/media/dvb-frontends/m88rs2000.h |   6 ---
 drivers/media/dvb-frontends/ts2020.c    | 372 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/ts2020.h    |  50 +++++++++++++++++
 drivers/media/pci/cx23885/Kconfig       |   1 +
 drivers/media/pci/cx23885/cx23885-dvb.c |  11 +++-
 drivers/media/pci/cx88/Kconfig          |   2 +
 drivers/media/pci/cx88/cx88-dvb.c       |  11 +++-
 drivers/media/pci/dm1105/Kconfig        |   1 +
 drivers/media/pci/dm1105/dm1105.c       |  11 +++-
 drivers/media/usb/dvb-usb-v2/Kconfig    |   1 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c  |   9 +++-
 drivers/media/usb/dvb-usb/Kconfig       |   2 +
 drivers/media/usb/dvb-usb/dw2102.c      | 143 ++++++++++++++++++++++++++++++++++++++++++++----
 18 files changed, 772 insertions(+), 541 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/ts2020.c
 create mode 100644 drivers/media/dvb-frontends/ts2020.h

