Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:49373 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0JMOkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 10:40:35 -0400
Message-ID: <4CB5C4DD.9080308@iki.fi>
Date: Wed, 13 Oct 2010 17:40:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	linux-media@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
Subject: [GIT PULL FOR 2.6.37] AF9013 + AF9015 changes, mostly remote controller
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

This patch series mainly moves af9015 remote controllers to rc-core. 
Also some other changes which should not have visible effects.

I did forced update since normal said: "To prevent you from losing 
history, non-fast-forward updates were rejected". Hopefully it does not 
cause merging problems for you.

t. Antti

The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:

   V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of 
sn9c102 (2010-10-01 18:14:35 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (19):
       af9013: optimize code size
       af9013: cache some reg values to reduce reg reads
       af9015: make checkpatch.pl happy
       af9015: remove needless variable set
       TerraTec remote controller keytable
       MSI DIGIVOX mini III remote controller keytable
       TrekStor DVB-T USB Stick remote controller
       Digittrade DVB-T USB Stick remote controller keytable
       AverMedia RM-KS remote controller keytable
       LeadTek Y04G0051 remote controller keytable
       TwinHan AzureWave AD-TU700(704J) remote controller
       A-Link DTU(m) remote controller
       MSI DIGIVOX mini II remote controller
       rename rc-msi-digivox.c -> rc-msi-digivox-iii.c
       Total Media In Hand remote controller
       fix MSI DIGIVOX mini III remote controller power buttons
       fix TerraTec remote controller PIP button
       fix A-Link DTU(m) remote controller PIP button
       af9015: move remote controllers to new RC core

Yann E. MORIN (1):
       v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)

  drivers/media/IR/keymaps/Makefile                 |   10 +
  drivers/media/IR/keymaps/rc-alink-dtu-m.c         |   68 ++++
  drivers/media/IR/keymaps/rc-avermedia-rm-ks.c     |   79 ++++
  drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c  |  102 +++++
  drivers/media/IR/keymaps/rc-digittrade.c          |   82 ++++
  drivers/media/IR/keymaps/rc-leadtek-y04g0051.c    |   99 +++++
  drivers/media/IR/keymaps/rc-msi-digivox-ii.c      |   67 ++++
  drivers/media/IR/keymaps/rc-msi-digivox-iii.c     |   85 +++++
  drivers/media/IR/keymaps/rc-terratec-slim.c       |   79 ++++
  drivers/media/IR/keymaps/rc-total-media-in-hand.c |   85 +++++
  drivers/media/IR/keymaps/rc-trekstor.c            |   80 ++++
  drivers/media/dvb/dvb-usb/af9015.c                |  253 +++++++------
  drivers/media/dvb/dvb-usb/af9015.h                |  418 
+--------------------
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h           |    1 +
  drivers/media/dvb/frontends/af9013.c              |   92 ++---
  drivers/media/dvb/frontends/af9013_priv.h         |   69 ++--
  include/media/rc-map.h                            |   10 +
  17 files changed, 1062 insertions(+), 617 deletions(-)
  create mode 100644 drivers/media/IR/keymaps/rc-alink-dtu-m.c
  create mode 100644 drivers/media/IR/keymaps/rc-avermedia-rm-ks.c
  create mode 100644 drivers/media/IR/keymaps/rc-azurewave-ad-tu700.c
  create mode 100644 drivers/media/IR/keymaps/rc-digittrade.c
  create mode 100644 drivers/media/IR/keymaps/rc-leadtek-y04g0051.c
  create mode 100644 drivers/media/IR/keymaps/rc-msi-digivox-ii.c
  create mode 100644 drivers/media/IR/keymaps/rc-msi-digivox-iii.c
  create mode 100644 drivers/media/IR/keymaps/rc-terratec-slim.c
  create mode 100644 drivers/media/IR/keymaps/rc-total-media-in-hand.c
  create mode 100644 drivers/media/IR/keymaps/rc-trekstor.c

-- 
http://palosaari.fi/
