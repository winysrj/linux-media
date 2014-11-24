Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59826 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaKXNdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 08:33:07 -0500
Message-ID: <54733390.7070901@iki.fi>
Date: Mon, 24 Nov 2014 15:33:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: CrazyCat <crazycat69@narod.ru>, Olli Salonen <olli.salonen@iki.fi>
Subject: [GIT PULL] si2157 si2168 cxusb em28xx
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5937a784c3e5fe8fd1e201f42a2b1ece6c36a6c0:

   [media] staging: media: bcm2048: fix coding style error (2014-11-21 
16:50:37 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs

for you to fetch changes up to d5036ca91a48ca0841d4f9075952f705e4cac58e:

   cxusb: Geniatech T230 support. (2014-11-24 12:44:59 +0200)

----------------------------------------------------------------
CrazyCat (3):
       si2157: Si2148 support.
       si2168: TS clock inversion control.
       cxusb: Geniatech T230 support.

Olli Salonen (3):
       si2157: Add support for Si2146-A10
       em28xx: Add support for Terratec Cinergy T2 Stick HD
       si2157: make checkpatch.pl happy (remove break after goto)

  drivers/media/dvb-core/dvb-usb-ids.h      |   1 +
  drivers/media/dvb-frontends/si2168.c      |   7 +++++--
  drivers/media/dvb-frontends/si2168.h      |   4 ++++
  drivers/media/dvb-frontends/si2168_priv.h |   1 +
  drivers/media/tuners/si2157.c             |  32 
++++++++++++++++++++++++--------
  drivers/media/tuners/si2157.h             |   2 +-
  drivers/media/tuners/si2157_priv.h        |   8 ++++++--
  drivers/media/usb/dvb-usb/cxusb.c         | 127 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/usb/em28xx/em28xx-cards.c   |  27 
+++++++++++++++++++++++++++
  drivers/media/usb/em28xx/em28xx-dvb.c     |  59 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/usb/em28xx/em28xx.h         |   1 +
  11 files changed, 256 insertions(+), 13 deletions(-)

-- 
http://palosaari.fi/
