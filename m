Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34934 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0DXVOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:14:00 -0400
Subject: [PATCH 0/4] ir-core sysfs protocol selection simplification
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Sat, 24 Apr 2010 23:13:55 +0200
Message-ID: <20100424210843.11570.82007.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series changes the sysfs implementation in ir-core to
make the protocol selection work in the same manner for hardware
decoders and software decoders (the distinction between the two
should be hidden from the user as much as possible IMHO).

This also allows for a nice reduction of duplicated code between
the raw ir protocol decoders.

The first patch is merely preparatory and should hopefully not
be controversial.

The second and third patch should be considered RFC's on the
implementation of the sysfs interface.

The last patch is orthogonal to the rest of the patchset and should
hopefully not be controversial (though it would be nice if someone
with the actual hardware could test it).

---

David Härdeman (4):
      ir-core: remove IR_TYPE_PD
      ir-core: centralize sysfs raw decoder enabling/disabling
      ir-core: move decoding state to ir_raw_event_ctrl
      ir-core: remove ir-functions usage from cx231xx


 drivers/media/IR/ir-core-priv.h             |   40 ++++
 drivers/media/IR/ir-jvc-decoder.c           |  152 +---------------
 drivers/media/IR/ir-nec-decoder.c           |  151 +---------------
 drivers/media/IR/ir-raw-event.c             |  136 ++++++--------
 drivers/media/IR/ir-rc5-decoder.c           |  165 ++---------------
 drivers/media/IR/ir-rc6-decoder.c           |  154 +---------------
 drivers/media/IR/ir-sony-decoder.c          |  155 +---------------
 drivers/media/IR/ir-sysfs.c                 |  262 +++++++++++++++------------
 drivers/media/video/cx231xx/cx231xx-input.c |   47 +----
 drivers/media/video/cx231xx/cx231xx.h       |    2 
 drivers/media/video/cx88/cx88-input.c       |    8 -
 include/media/ir-kbd-i2c.h                  |    2 
 include/media/rc-map.h                      |    9 -
 13 files changed, 322 insertions(+), 961 deletions(-)

-- 
David Härdeman
