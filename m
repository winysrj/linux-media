Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40387 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2L1W4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 17:56:36 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so5326510eek.20
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 14:56:35 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: [GIT PULL FOR v3.9] the rest for TeVii s421, s632 DVB cards and Montage ds3000, rs2000 demods
Date: Sat, 29 Dec 2012 01:56:37 +0300
Message-ID: <3107952.IAy7bspQ8Z@useri>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c19bec500168108bf28710fae304523679ffb40f:

  [media] vivi: Constify structures (2012-12-28 13:32:51 -0200)

are available in the git repository at:

  git://git.linuxtv.org/liplianin/media_tree.git ts2020_1_v3.9

for you to fetch changes up to 3a36fae7540e031a811e6c28cd37c7db4baf142b:

  m88rs2000: make use ts2020 (2012-12-29 01:40:33 +0300)

----------------------------------------------------------------
Igor M. Liplianin (4):
      Tevii S421 and S632 support, Kconfig part
      m88rs2000: SNR, BER implemented
      ds3000: lock led procedure added
      m88rs2000: make use ts2020

 drivers/media/dvb-frontends/ds3000.c    |  12 +++++
 drivers/media/dvb-frontends/ds3000.h    |   2 +
 drivers/media/dvb-frontends/m88rs2000.c | 412 ++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------------
 drivers/media/dvb-frontends/m88rs2000.h |   6 ---
 drivers/media/dvb-frontends/ts2020.c    | 381 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
 drivers/media/dvb-frontends/ts2020.h    |   1 +
 drivers/media/pci/cx23885/cx23885-dvb.c |   1 +
 drivers/media/pci/cx88/cx88-dvb.c       |   1 +
 drivers/media/pci/dm1105/dm1105.c       |   1 +
 drivers/media/usb/dvb-usb-v2/Kconfig    |   1 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c  |   9 +++-
 drivers/media/usb/dvb-usb/Kconfig       |   1 +
 drivers/media/usb/dvb-usb/dw2102.c      |  56 ++++++++++++--------
 13 files changed, 395 insertions(+), 489 deletions(-)

