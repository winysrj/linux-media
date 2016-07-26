Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:60783 "EHLO mail.horus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbcGZMBX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 08:01:23 -0400
Date: Tue, 26 Jul 2016 13:52:25 +0200
From: Matthias Reichl <hias@horus.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: IR button repeat not working in kernel 4.6 and 4.7
Message-ID: <20160726115225.GA15199@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In kernel 4.6 and 4.7 holding down a button on an IR remote no longer
results in repeated key down events.

I've reproduced that issue on a Raspberry Pi B using a GPIO IR
receiver. Other systems seem to be affected as well, for
example Intel NUC with an ITE CIR receiver.

Bisecting points to this commit as a possible cause for that issue:

commit 078600f514a12fd763ac84c86af68ef5b5267563
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Wed Mar 2 08:00:15 2016 -0300

    [media] rc-core: allow calling rc_open with device not initialized

With upstream kernel 4.6.0 and 4.7.0 the ir-keytable output looks OK:

Found /sys/class/rc/rc0/ (/dev/input/event0) with:
        Driver gpio-rc-recv, table rc-hauppauge
        Supported protocols: NEC RC-5 RC-6 JVC SONY SANYO RC-5-SZ SHARP XMP other
        Enabled protocols: RC-5
        Name: gpio_ir_recv
        bus: 25, vendor/product: 0001:0001, version: 0x0100
        Repeat delay = 500 ms, repeat period = 125 ms
 
But running evtest (or ir-keytable -t) only shows EV_KEY events on
initial button down and on release:

Event: time 1469531035.490700, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531035.490700, type 1 (EV_KEY), code 2 (KEY_1), value 1
Event: time 1469531035.490700, -------------- EV_SYN ------------
Event: time 1469531035.603725, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531035.603725, -------------- EV_SYN ------------
Event: time 1469531035.716778, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531035.716778, -------------- EV_SYN ------------
Event: time 1469531035.829849, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531035.829849, -------------- EV_SYN ------------
Event: time 1469531035.942893, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531035.942893, -------------- EV_SYN ------------
Event: time 1469531036.055932, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.055932, -------------- EV_SYN ------------
Event: time 1469531036.169004, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.169004, -------------- EV_SYN ------------
Event: time 1469531036.282043, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.282043, -------------- EV_SYN ------------
Event: time 1469531036.395103, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.395103, -------------- EV_SYN ------------
Event: time 1469531036.508157, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.508157, -------------- EV_SYN ------------
Event: time 1469531036.621216, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.621216, -------------- EV_SYN ------------
Event: time 1469531036.734255, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.734255, -------------- EV_SYN ------------
Event: time 1469531036.875917, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531036.875917, -------------- EV_SYN ------------
Event: time 1469531037.125875, type 1 (EV_KEY), code 2 (KEY_1), value 0
Event: time 1469531037.125875, -------------- EV_SYN ------------

When reverting commit 078600f514a12fd763ac84c86af68ef5b5267563 in
kernel 4.6.0 evtest output is back to normal: EV_KEY events with
value 2 show up between button down and button up:

Event: time 1469531201.086823, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.086823, type 1 (EV_KEY), code 2 (KEY_1), value 1
Event: time 1469531201.086823, -------------- EV_SYN ------------
Event: time 1469531201.199789, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.199789, -------------- EV_SYN ------------
Event: time 1469531201.312818, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.312818, -------------- EV_SYN ------------
Event: time 1469531201.425846, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.425846, -------------- EV_SYN ------------
Event: time 1469531201.538852, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.538852, -------------- EV_SYN ------------
Event: time 1469531201.578497, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531201.578497, -------------- EV_SYN ------------
Event: time 1469531201.651897, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.651897, -------------- EV_SYN ------------
Event: time 1469531201.708488, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531201.708488, -------------- EV_SYN ------------
Event: time 1469531201.764901, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.764901, -------------- EV_SYN ------------
Event: time 1469531201.838497, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531201.838497, -------------- EV_SYN ------------
Event: time 1469531201.877950, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.877950, -------------- EV_SYN ------------
Event: time 1469531201.968484, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531201.968484, -------------- EV_SYN ------------
Event: time 1469531201.990939, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531201.990939, -------------- EV_SYN ------------
Event: time 1469531202.098497, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531202.098497, -------------- EV_SYN ------------
Event: time 1469531202.128516, type 4 (EV_MSC), code 4 (MSC_SCAN), value 1e01
Event: time 1469531202.128516, -------------- EV_SYN ------------
Event: time 1469531202.228506, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531202.228506, -------------- EV_SYN ------------
Event: time 1469531202.358563, type 1 (EV_KEY), code 2 (KEY_1), value 2
Event: time 1469531202.358563, -------------- EV_SYN ------------
Event: time 1469531202.378560, type 1 (EV_KEY), code 2 (KEY_1), value 0
Event: time 1469531202.378560, -------------- EV_SYN ------------

so long,

Hias
