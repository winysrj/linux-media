Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:46777 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbcEPQHy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 12:07:54 -0400
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com [209.85.213.46])
	by imap.netup.ru (Postfix) with ESMTPA id 6D9BF7BC297
	for <linux-media@vger.kernel.org>; Mon, 16 May 2016 18:58:36 +0300 (MSK)
Received: by mail-vk0-f46.google.com with SMTP id f66so218462760vkh.2
        for <linux-media@vger.kernel.org>; Mon, 16 May 2016 08:58:36 -0700 (PDT)
MIME-Version: 1.0
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 16 May 2016 11:58:15 -0400
Message-ID: <CAK3bHNUPOORumndTHSQyLa0OAnE1Ob4SLR=CoLZMbi5C-P4e4w@mail.gmail.com>
Subject: [GIT PULL] NetUP Universal DVB (revision 1.4)
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull code from my repository (details below). Repository is
based on linux-next. If it's better to send patch-by-patch basis
please let me know - i will prepare emails.

This patches adding support for our NetUP Universal DVB card revision
1.4 (ISDB-T added to this revision). This achieved by using new Sony
tuner HELENE (CXD2858ER) and new Sony demodulator ARTEMIS (CXD2854ER).
And other fixes for our cards in this repository too.


The following changes since commit 862c0314778e27de4cd4c47f12fe7e4232a7181d:

  [media] Fix DVB-T tuning (2016-05-16 10:37:45 -0400)

are available in the git repository at:

  https://github.com/aospan/linux-netup-1.4.git

for you to fetch changes up to fecf505c4bef3a5f1783370db4de66f3de465443:

  [media] fix typo in SONY demodulator description (2016-05-16 10:57:04 -0400)

----------------------------------------------------------------
Abylay Ospan (14):
      [media] Add support Sony HELENE Sat/Ter Tuner
      [media] Add support Sony CXD2854ER demodulator
      [media] Fix DVB-S/S2 tune for sony ascot3a tuner
      [media] New hw revision 1.4 of NetUP Universal DVB card added
      [media] Fix CAM module memory read/write
      MAINTAINERS: Add a maintainer for netup_unidvb, cxd2841er,
horus3a, ascot2e
      [media] Add carrier offset calculation for DVB-T
      [media] Sanity check when initializing DVB-S/S2 demodulator
      [media] Fix DVB-T frequency offset calculation
      [media] ISDB-T retune and offset fix and DVB-C bw fix
      [media] fix DVB-S/S2 tuning
      [media] support DVB-T2 for SONY CXD2841/54
      [media] Change frontend allocation strategy for NetUP Universal DVB cards
      [media] fix typo in SONY demodulator description

 MAINTAINERS                                        |    5 +
 drivers/media/dvb-frontends/Kconfig                |    7 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/cxd2841er.c            | 1467
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/media/dvb-frontends/cxd2841er.h            |   24 +-
 drivers/media/dvb-frontends/cxd2841er_priv.h       |    1 +
 drivers/media/dvb-frontends/helene.c               | 1042
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/helene.h               |   79 +++++
 drivers/media/dvb-frontends/horus3a.c              |   26 +-
 drivers/media/pci/netup_unidvb/Kconfig             |    7 +-
 drivers/media/pci/netup_unidvb/netup_unidvb.h      |   10 +
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c   |    4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  170 +++++++----
 13 files changed, 2432 insertions(+), 411 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/helene.c
 create mode 100644 drivers/media/dvb-frontends/helene.h

-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
