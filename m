Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp210.webpack.hosteurope.de ([80.237.132.217]:44962 "EHLO
	wp210.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932491AbbFFUR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:17:57 -0400
From: =?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com
Subject: [PATCH 0/5] [media] mantis: add remote control support
Date: Sat,  6 Jun 2015 21:58:08 +0200
Message-Id: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I am re-submitting my patch for remote control support of mantis based DVB
cards for the 3rd time. The last submission can be found here [1]. It has been
rebased and tested on v4.0. It has been working fine on my HTPC for almost
three years now. Compared to the previous submission I've split the patch into
the individual rc key tables and the actual mantis rc support.

I am really hoping that the patch will be applied this time. These cards are
still in use and people have to patch their kernel to get them fully working.
I recently got some feedback that it is working for other too.

This patch has been tested on a TechniSat CableStar HD2. Other rc-maps were
taken from Christoph Pinkl's patch [2] and the s2-liplianin repository. The
major difference to Christoph's patch is a reworked interrupt handling of the
UART because the RX interrupt is apparently level triggered and requires
masking until the FIFO is read by the UART worker.

Tested-by: Thomas Müller <mailaccountfueralles@gmx.de>

[1] https://patchwork.linuxtv.org/patch/26321/
[2] http://patchwork.linuxtv.org/patch/7217/

---
 drivers/media/pci/mantis/hopper_cards.c            |  13 ++-
 drivers/media/pci/mantis/mantis_cards.c            |  60 +++++++++---
 drivers/media/pci/mantis/mantis_common.h           |  33 ++++++-
 drivers/media/pci/mantis/mantis_dma.c              |   5 +-
 drivers/media/pci/mantis/mantis_i2c.c              |   8 +-
 drivers/media/pci/mantis/mantis_input.c            | 106 ++++-----------------
 drivers/media/pci/mantis/mantis_input.h            |  28 ++++++
 drivers/media/pci/mantis/mantis_pcmcia.c           |   4 +-
 drivers/media/pci/mantis/mantis_uart.c             |  62 ++++++------
 drivers/media/rc/keymaps/Makefile                  |   4 +
 drivers/media/rc/keymaps/rc-technisat-ts35.c       |  76 +++++++++++++++
 .../media/rc/keymaps/rc-terratec-cinergy-c-pci.c   |  88 +++++++++++++++++
 .../media/rc/keymaps/rc-terratec-cinergy-s2-hd.c   |  86 +++++++++++++++++
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c   |  98 +++++++++++++++++++
 include/media/rc-map.h                             |   4 +
 15 files changed, 526 insertions(+), 149 deletions(-)

