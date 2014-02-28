Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54651 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaB1XRh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:37 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so1119577wgh.27
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:17:36 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 0/5] rc: scancode filtering improvements
Date: Fri, 28 Feb 2014 23:17:01 +0000
Message-Id: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches make some improvements relating to the recently added RC
scancode filtering interface:
- Patch 1 adds generic scancode filtering. This allows filtering to also
  work for raw rc drivers and scancode drivers without filtering
  capabilities.
- Patches 2-4 future proof the sysfs API to allow a different wakeup
  filter protocol to be set than the current protocol. A new
  wakeup_protocols sysfs file is added which behaves similarly to the
  protocols sysfs file but applies only to wakeup filters.
- Finally patch 5 improves the driver interface so that changing either
  the normal or wakeup protocol automatically causes the corresponding
  filter to be refreshed to the driver, or failing that cleared. It also
  ensures that the filter is turned off (and for wakeup that means
  wakeup is disabled) if the protocol is set to none. This avoids the
  driver having to maintain the filters, or even need a
  change_wakeup_protocol() callback if there is only one wakeup protocol
  allowed at a time.

The patch "rc-main: store_filter: pass errors to userland" should
probably be applied first.

An updated img-ir v4 patchset which depends on this one will follow
soon.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Bruno Prémont" <bonbons@linux-vserver.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sean Young <sean@mess.org>
Cc: "David Härdeman" <david@hardeman.nu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Antti Seppälä" <a.seppala@gmail.com>

James Hogan (5):
  rc-main: add generic scancode filtering
  rc: abstract access to allowed/enabled protocols
  rc: add allowed/enabled wakeup protocol masks
  rc: add wakeup_protocols sysfs file
  rc-main: automatically refresh filter on protocol change

 Documentation/ABI/testing/sysfs-class-rc           |  23 +++-
 .../DocBook/media/v4l/remote_controllers.xml       |  20 ++-
 drivers/hid/hid-picolcd_cir.c                      |   2 +-
 drivers/media/common/siano/smsir.c                 |   2 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   4 +-
 drivers/media/pci/cx23885/cx23885-input.c          |   2 +-
 drivers/media/pci/cx88/cx88-input.c                |   2 +-
 drivers/media/rc/ati_remote.c                      |   2 +-
 drivers/media/rc/ene_ir.c                          |   2 +-
 drivers/media/rc/fintek-cir.c                      |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |   4 +-
 drivers/media/rc/iguanair.c                        |   2 +-
 drivers/media/rc/imon.c                            |   7 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   2 +-
 drivers/media/rc/ir-lirc-codec.c                   |   2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   2 +-
 drivers/media/rc/ir-nec-decoder.c                  |   2 +-
 drivers/media/rc/ir-raw.c                          |   2 +-
 drivers/media/rc/ir-rc5-decoder.c                  |   6 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |   2 +-
 drivers/media/rc/ir-rc6-decoder.c                  |   6 +-
 drivers/media/rc/ir-sanyo-decoder.c                |   2 +-
 drivers/media/rc/ir-sharp-decoder.c                |   2 +-
 drivers/media/rc/ir-sony-decoder.c                 |  10 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/rc/nuvoton-cir.c                     |   2 +-
 drivers/media/rc/rc-loopback.c                     |   2 +-
 drivers/media/rc/rc-main.c                         | 141 +++++++++++++++------
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/streamzap.c                       |   2 +-
 drivers/media/rc/ttusbir.c                         |   2 +-
 drivers/media/rc/winbond-cir.c                     |   2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   2 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   2 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   8 +-
 drivers/media/usb/tm6000/tm6000-input.c            |   2 +-
 include/media/rc-core.h                            |  49 ++++++-
 39 files changed, 234 insertions(+), 100 deletions(-)

-- 
1.8.3.2

