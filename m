Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43277 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYWSM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 17:18:12 -0500
Received: by bwz15 with SMTP id 15so2345378bwz.19
        for <linux-media@vger.kernel.org>; Fri, 25 Feb 2011 14:18:11 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCHES FOR 2.6.39] ds3000 frontend, dw2102 driver patches
Date: Sat, 26 Feb 2011 00:18:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102260018.07172.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Git repository was created for better handling long series of patches.
It includes dw2102 series and 5'th to 9'th from ds3000 series in right order.
Patces 1 to 4 already included in staging/for_v2.6.39 branch.

The following changes since commit a26a7a97ddce9c3152fca28e7eaacc96d9207148:

  [media] pvrusb2: Use sysfs_attr_init() where appropriate (2011-02-24 20:47:36 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git ds3000

Igor M. Liplianin (17):
      dw2102: Extend keymap parameter for not used remote
      dw2102: use separate firmwares for Prof 1100, TeVii S630, S660
      dw2102: add support for Geniatech SU3000 USB DVB-S2 card.
      dw2102: Add Terratec Cinergy S2 USB HD
      dw2102: Prof 7500: Lock LED implemented.
      dw2102: Prof 7500 remote fix.
      dw2102: Prof 1100 initialization fix
      dw2102: unnecessary NULL's removed
      dw2102: corrections for TeVii s660 LNB power control
      dw2102: fix TeVii s660 remote control
      dw2102: add support for the TeVii S480 PCIe.
      dw2102: Copyright, cards list updated
      ds3000: clean up in tune procedure
      ds3000: remove unnecessary dnxt, dcur structures
      ds3000: add carrier offset calculation
      ds3000: hardware tune algorithm
      cx88: add support for TeVii S464 PCI card.

 drivers/media/dvb/dvb-usb/dw2102.c         |  507 +++++++++++++++++++++---
 drivers/media/dvb/frontends/ds3000.c       |  600 +++++++++++++---------------
 drivers/media/dvb/frontends/ds3000.h       |    3 +
 drivers/media/dvb/frontends/stv0900.h      |    2 +
 drivers/media/dvb/frontends/stv0900_core.c |   23 +-
 drivers/media/video/cx88/cx88-cards.c      |   17 +
 drivers/media/video/cx88/cx88-dvb.c        |   23 +
 drivers/media/video/cx88/cx88-input.c      |    1 +
 drivers/media/video/cx88/cx88.h            |    1 +
 9 files changed, 798 insertions(+), 379 deletions(-)
