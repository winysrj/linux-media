Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab0DPV00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 17:26:26 -0400
Date: Fri, 16 Apr 2010 17:26:22 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 0/3] ir-core: add imon device driver
Message-ID: <20100416212622.GA6888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series adds a new device driver for the SoundGraph iMON and
Antec Veris IR/display devices commonly found in many home theater pc
cases and as after-market case additions.

This driver was previously submitted as a pure input layer driver, but I
was convinced to port it to the new ir-core infrastructure, so this patch
is against http://git.linuxtv.org/mchehab/ir.git.

With only some minor modifications to ir-core (making an already exported
function public) and reasonably little porting driver-side, I've managed
to finish at least the initial conversion. There's still a local key
release timer in use in the driver that needs to be converted to use
ir-core's keyup timer, and I'm not using ir_keydown due to some serious
quirks in the way the imon hardware decodes IR signals (I need to do my
own key release detection, as there are three different ways a key release
is identified even on the exact same device...), but it does use all the
ir-core keymap loading and parsing code, ir_input_dev, ir_dev_props, etc.

Something I wasn't too sure about... Where exactly should an IR-only device
driver live in the tree? I've put it at drivers/media/IR/imon.c for the
moment, but it might make sense to have a drivers/media/IR/hardware/
directory to drop things like this and the forthcoming lirc_mceusb port
into, rather than intermingling with the core bits.

The most important part: I've tested this out w/actual imon hardware, and
it even works. :)

---

Jarod Wilson (3)
	ir-core: make ir_g_keycode_from_table a public function
	ir-core: add imon pad and mce keymaps
	ir-core: add imon driver

 drivers/media/IR/Kconfig               |   12 +
 drivers/media/IR/Makefile              |    3 +
 drivers/media/IR/imon.c                | 2417 ++++++++++++++++++++++++++++++++
 drivers/media/IR/ir-core-priv.h        |    7 -
 drivers/media/IR/keymaps/Makefile      |    2 +
 drivers/media/IR/keymaps/rc-imon-mce.c |  142 ++
 drivers/media/IR/keymaps/rc-imon-pad.c |  155 ++
 include/media/ir-core.h                |    1 +
 include/media/rc-map.h                 |    2 +
 9 files changed, 2734 insertions(+), 7 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

