Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36238 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbbDBMDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 08:03:30 -0400
Subject: [PATCH 0/2] NEC scancodes and protocols in keymaps
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: sean@mess.org, mchehab@osg.samsung.com
Date: Thu, 02 Apr 2015 14:02:57 +0200
Message-ID: <20150402120047.20068.31662.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following two patches should show more clearly what I mean by
adding protocols to the keytables (and letting userspace add
keytable entries with explicit protocol information). Consider
it a basis for discussion.

Each patch has a separate description, please refer to those for
more information.

---

David Härdeman (2):
      rc-core: use the full 32 bits for NEC scancodes
      rc-core: don't throw away protocol information


 drivers/media/rc/ati_remote.c            |    1 
 drivers/media/rc/imon.c                  |    7 +
 drivers/media/rc/ir-nec-decoder.c        |   26 ---
 drivers/media/rc/rc-main.c               |  233 ++++++++++++++++++++++++------
 drivers/media/usb/dvb-usb-v2/af9015.c    |   22 +--
 drivers/media/usb/dvb-usb-v2/af9035.c    |   23 +--
 drivers/media/usb/dvb-usb-v2/az6007.c    |   16 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c  |   20 +--
 drivers/media/usb/dvb-usb/dib0700_core.c |   24 +--
 drivers/media/usb/em28xx/em28xx-input.c  |   37 +----
 include/media/rc-core.h                  |   26 +++
 include/media/rc-map.h                   |   23 ++-
 12 files changed, 264 insertions(+), 194 deletions(-)

--
David Härdeman
