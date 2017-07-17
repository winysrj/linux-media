Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34726 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdGQF0Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 01:26:16 -0400
Received: by mail-qk0-f170.google.com with SMTP id d78so112088343qkb.1
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 22:26:15 -0700 (PDT)
MIME-Version: 1.0
From: Szabolcs Andrasi <andrasi.szabolcs@gmail.com>
Date: Sun, 16 Jul 2017 22:26:14 -0700
Message-ID: <CAM1CkLU6gTj2zDS-9cu_POOVpByitEyi26XhKZ1W3j9AbTTK-Q@mail.gmail.com>
Subject: ir-keytable question [Ubuntu 17.04]
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using Ubuntu 17.04 and I installed the ir-keytable tool. The
output of the ir-keytable command is as follows:



Found /sys/class/rc/rc0/ (/dev/input/event5) with:
Driver ite-cir, table rc-rc6-mce
Supported protocols: unknown other lirc rc-5 rc-5-sz jvc sony nec
sanyo mce_kbd rc-6 sharp xmp
Enabled protocols: lirc rc-6
Name: ITE8708 CIR transceiver
bus: 25, vendor/product: 1283:0000, version: 0x0000
Repeat delay = 500 ms, repeat period = 125 ms



I'm trying to enable the supported mce_kbd protocol in addition to the
lirc and rc-6 protocols with the

$ sudo ir-keytable -p lirc -p rc-6 -p mce_kbd

command which works as expected. If, however, I reboot my computer,
ir-keytable forgets this change and only the lirc and rc-6 protocols
are enabled. Is there a configuration file I can edit so that after
the boot my IR remote still works? Or is that so that the only way to
make it work is to write a start-up script that runs the above command
to enable the needed protocol?

Thank you in advance!

-- Szabolcs
