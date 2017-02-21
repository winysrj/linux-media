Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:57776 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753111AbdBUStd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 13:49:33 -0500
Date: Tue, 21 Feb 2017 19:49:29 +0100
From: Matthias Reichl <hias@horus.com>
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: Bug: decoders referenced in kernel rc-keymaps not loaded on boot
Message-ID: <20170221184929.GA2590@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There seems to be a bug in on-demand loading of IR protocol decoders.

After bootup the protocol referenced in the in-kernel rc keymap shows
up as enabled (in sysfs and ir-keytable) but the protocol decoder
is not loaded and thus no rc input events will be generated.

For example, RPi3 with kernel 4.10 and gpio-ir-recv configured to use
the rc-hauppauge keymap in devicetree:

# lsmod | grep '^\(ir\|rc_\)'
ir_lirc_codec           5590  0
rc_hauppauge            2422  0
rc_core                24320  5 rc_hauppauge,ir_lirc_codec,lirc_dev,gpio_ir_recv

# cat /sys/class/rc/rc0/protocols
other unknown [rc-5] nec rc-6 jvc sony rc-5-sz sanyo sharp mce_kbd xmp cec [lirc]

# dmesg | grep "IR "
[    4.506728] Registered IR keymap rc-hauppauge
[    4.554651] lirc_dev: IR Remote Control driver registered, major 242
[    4.576490] IR LIRC bridge handler initialized

The same happens with other IR receivers, eg the streamzap receiver,
which uses the rc-5-sz protocol / ir_rc5_decoder, on x86.

Reverting the on-demand-loading patches

[media] media: rc: remove unneeded code
commit c1500ba0b61e9abf95e0e7ecd3c4ad877f019abe

[media] media: rc: move check whether a protocol is enabled to the core
commit d80ca8bd71f0b01b2b12459189927cb3299cfab9

[media] media: rc: load decoder modules on-demand
commit acc1c3c688ed8cc862ddc007eab0dcef839f4ec8

restores the previous behaviour, all decoders are enabled and IR
events can be generated immediately after boot without having to
manually trigger loading of a protocol decoder.

so long,

Hias
