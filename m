Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:60820 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751178AbdGQJ0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 05:26:48 -0400
Date: Mon, 17 Jul 2017 11:20:38 +0200
From: Matthias Reichl <hias@horus.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils] 70-infrared.rules starts ir-keytable too early
Message-ID: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While testing serial_ir on kernel 4.11.8 with ir-keytable 1.12.3
I noticed that my /etc/rc_maps.cfg configuration wasn't applied.
Manually running "ir-keytable -a /etc/rc_maps.cfg -s rc0" always
worked fine, though.

Digging further into this I tracked it down to the udev rule
being racy. The udev rule triggers on the rc subsystem, but this
is before the input and event devices are created.

The kernel creates 3 events relevant to this context, on rcX
device creation, on inputY creation and on inputY/eventZ creation
- the latter 2 usually in quick succession, but some time can
elapse between the first 2.

In my case ir-keytable -a was executing during this small time
window and failed with an error because it couldn't find the
input/event devices.

Excerpt from log with udev debugging enabled:

Jul 16 11:02:11 LibreELEC systemd-udevd[272]: seq 2099 queued, 'add' 'rc'
...
Jul 16 11:02:11 LibreELEC systemd-udevd[614]: '/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0'(err) 'Couldn't find any node at /sys/class/rc/rc0/input*.'
Jul 16 11:02:11 LibreELEC systemd-udevd[614]: Process '/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0' failed with exit code 255.
...
Jul 16 11:02:11 LibreELEC systemd-udevd[272]: seq 2106 queued, 'add' 'input'
Jul 16 11:02:11 LibreELEC systemd-udevd[272]: seq 2106 forked new worker [622]
Jul 16 11:02:11 LibreELEC systemd-udevd[272]: seq 2107 queued, 'add' 'input'

The full log is available here:
http://www.horus.com/~hias/tmp/journalctl-ir-keytable-failed

One solution is to trigger ir-keytable -a execution from the event device
creation instead. I'm currently testing with the following udev rule:

ACTION=="add", SUBSYSTEMS=="rc", GOTO="begin"
GOTO="end"

LABEL="begin"

SUBSYSTEM=="rc", ENV{rc_sysdev}="$name"

SUBSYSTEM=="input", IMPORT{parent}="rc_sysdev"

KERNEL=="event[0-9]*", ENV{rc_sysdev}=="?*", \
   RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{rc_sysdev}"

LABEL="end"

That udev rule is a bit messy, ir-keytable -a needs the rcX sysdev,
which doesn't seem to be easily available from the event node in
the input subsystem, so I'm propagating that info through an
environment variable.

So far testing is working fine, but hints for better/nicer solutions
are welcome!

so long,

Hias
