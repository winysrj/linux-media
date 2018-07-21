Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:56493 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbeGUT6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Jul 2018 15:58:09 -0400
Date: Sat, 21 Jul 2018 21:04:21 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Logspam with "two consecutive events of type space" on gpio-ir-recv
 and meson-ir
Message-ID: <20180721190421.5m4jfgvknglv5ii4@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

I noticed that on 4.18-rc5 I get dmesg logspam with
"rc rc0: two consecutive events of type space" on gpio-ir-recv
and meson-ir - mceusb seems to be fine (haven't tested with
other IR receivers yet).

With the default, short IR timeout I get these messages on each
IR message, which is rather spammy on longer button presses:

[ 1988.053215] rc rc0: two consecutive events of type space
[ 1988.173189] rc rc0: two consecutive events of type space
[ 1988.283188] rc rc0: two consecutive events of type space
[ 1988.403185] rc rc0: two consecutive events of type space
[ 1988.513193] rc rc0: two consecutive events of type space
[ 1988.623190] rc rc0: two consecutive events of type space
[ 1988.743190] rc rc0: two consecutive events of type space
[ 1988.853193] rc rc0: two consecutive events of type space
[ 1988.973193] rc rc0: two consecutive events of type space
[ 1989.083193] rc rc0: two consecutive events of type space
[ 1989.193196] rc rc0: two consecutive events of type space
[ 1989.313216] rc rc0: two consecutive events of type space
[ 1989.423197] rc rc0: two consecutive events of type space
...

With a longer timeout (eg 125ms and testing with a RC-5 remote) I get
these messages once per button press.

Eg on 2 shorter button presses:
# ir-keytable -t
Testing events. Please, press CTRL-C to abort.
2045.990064: lirc protocol(rc5): scancode = 0x101b
2045.990123: event type EV_MSC(0x04): scancode = 0x101b
2045.990123: event type EV_SYN(0x00).
2046.100077: lirc protocol(rc5): scancode = 0x101b
2046.100126: event type EV_MSC(0x04): scancode = 0x101b
2046.100126: event type EV_SYN(0x00).
2046.230075: lirc protocol(rc5): scancode = 0x101b
2046.230118: event type EV_MSC(0x04): scancode = 0x101b
2046.230118: event type EV_SYN(0x00).
2050.970078: lirc protocol(rc5): scancode = 0x101b toggle=1
2050.970137: event type EV_MSC(0x04): scancode = 0x101b
2050.970137: event type EV_SYN(0x00).
2051.080071: lirc protocol(rc5): scancode = 0x101b toggle=1
2051.080119: event type EV_MSC(0x04): scancode = 0x101b
2051.080119: event type EV_SYN(0x00).
2051.210056: lirc protocol(rc5): scancode = 0x101b toggle=1
2051.210099: event type EV_MSC(0x04): scancode = 0x101b
2051.210099: event type EV_SYN(0x00).

I get this in dmesg:
[ 2045.933635] rc rc0: two consecutive events of type space
[ 2050.923689] rc rc0: two consecutive events of type space

So it looks like that might be a timeout-related issue with
these 2 drivers.

so long,

Hias
