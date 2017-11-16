Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:53375 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933982AbdKPPfw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 10:35:52 -0500
Date: Thu, 16 Nov 2017 16:27:01 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 4.14 regression from commit d57ea877af38 media: rc: per-protocol
 repeat period
Message-ID: <20171116152700.filid3ask3gowegl@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following commit introduced a regression

commit d57ea877af38057b0ef31758cf3b99765dc33695
Author: Sean Young <sean@mess.org>
Date:   Wed Aug 9 13:19:16 2017 -0400

    media: rc: per-protocol repeat period

    CEC needs a keypress timeout of 550ms, which is too high for the IR
    protocols. Also fill in known repeat times, with 50ms error margin.

    Also, combine all protocol data into one structure.

We received a report that an RC6 MCE remote used with the ite-cir
produces "double events" on short button presses:

https://forum.kodi.tv/showthread.php?tid=298462&pid=2667855#pid2667855

Looking at the ir-keytable -t output an additional key event is also
generated after longer button presses:

# ir-keytable -t
Testing events. Please, press CTRL-C to abort.
1510680591.697657: event type EV_MSC(0x04): scancode = 0x800f041f
1510680591.697657: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
1510680591.697657: event type EV_SYN(0x00).
1510680591.867355: event type EV_KEY(0x01) key_up: KEY_DOWN(0x006c)
1510680591.867355: event type EV_SYN(0x00).
1510680591.935026: event type EV_MSC(0x04): scancode = 0x800f041f
1510680591.935026: event type EV_KEY(0x01) key_down: KEY_DOWN(0x006c)
1510680591.935026: event type EV_SYN(0x00).
1510680592.104100: event type EV_KEY(0x01) key_up: KEY_DOWN(0x006c)
1510680592.104100: event type EV_SYN(0x00).

1510680597.714055: event type EV_MSC(0x04): scancode = 0x800f0405
1510680597.714055: event type EV_KEY(0x01) key_down: KEY_NUMERIC_5(0x0205)
1510680597.714055: event type EV_SYN(0x00).
1510680597.819939: event type EV_MSC(0x04): scancode = 0x800f0405
1510680597.819939: event type EV_SYN(0x00).
1510680597.925614: event type EV_MSC(0x04): scancode = 0x800f0405
1510680597.925614: event type EV_SYN(0x00).
1510680598.032422: event type EV_MSC(0x04): scancode = 0x800f0405
1510680598.032422: event type EV_SYN(0x00).
...
1510680598.562114: event type EV_MSC(0x04): scancode = 0x800f0405
1510680598.562114: event type EV_SYN(0x00).
1510680598.630641: event type EV_KEY(0x01) key_down: KEY_NUMERIC_5(0x0205)
1510680598.630641: event type EV_SYN(0x00).
1510680598.667906: event type EV_MSC(0x04): scancode = 0x800f0405
1510680598.667906: event type EV_SYN(0x00).
1510680598.760760: event type EV_KEY(0x01) key_down: KEY_NUMERIC_5(0x0205)
1510680598.760760: event type EV_SYN(0x00).
1510680598.837412: event type EV_KEY(0x01) key_up: KEY_NUMERIC_5(0x0205)
1510680598.837412: event type EV_SYN(0x00).
1510680598.905003: event type EV_MSC(0x04): scancode = 0x800f0405
1510680598.905003: event type EV_KEY(0x01) key_down: KEY_NUMERIC_5(0x0205)
1510680598.905003: event type EV_SYN(0x00).
1510680599.074092: event type EV_KEY(0x01) key_up: KEY_NUMERIC_5(0x0205)
1510680599.074092: event type EV_SYN(0x00).

Looking at the timestamps of the scancode events it seems that
signals are received every ~106ms but the last signal seems to be
received 237ms after the last-but-one - which is then interpreted
as a new key press cycle as the delay is longer than the 164ms
"repeat_period" setting of the RC6 protocol (before that commit
250ms was used).

This 237ms delay seems to be coming from the 200ms timeout value
of the ite-cir driver (237ms is in the ballpark of ~30ms rc6 signal
time plus 200ms timeout).

The original author hasn't reported back yet but others confirmed
that changing the timeout to 100ms (minimum idle timeout value
of ite-cir) using "ir-ctl -t 100000" fixes the issue.

I could locally reproduce this with gpio-ir-recv (which uses the
default 125ms timeout) and the sony protocol (repeat_period = 100ms):

1510838115.272021: event type EV_MSC(0x04): scancode = 0x110001
1510838115.272021: event type EV_KEY(0x01) key_down: KEY_2(0x0003)
1510838115.272021: event type EV_SYN(0x00).
1510838115.322014: event type EV_MSC(0x04): scancode = 0x110001
1510838115.322014: event type EV_SYN(0x00).
1510838115.362003: event type EV_MSC(0x04): scancode = 0x110001
1510838115.362003: event type EV_SYN(0x00).
1510838115.412002: event type EV_MSC(0x04): scancode = 0x110001
1510838115.412002: event type EV_SYN(0x00).
1510838115.521973: event type EV_KEY(0x01) key_up: KEY_2(0x0003)
1510838115.521973: event type EV_SYN(0x00).
1510838115.532007: event type EV_MSC(0x04): scancode = 0x110001
1510838115.532007: event type EV_KEY(0x01) key_down: KEY_2(0x0003)
1510838115.532007: event type EV_SYN(0x00).
1510838115.641972: event type EV_KEY(0x01) key_up: KEY_2(0x0003)
1510838115.641972: event type EV_SYN(0x00).

Reducing the timeout to 20ms removes the addional key_down/up event.

Another test with a rc-5 remote on gpio-ir-recv worked fine at the
default 125ms timeout but with 200ms as on the ite-cir I again
got the additional key event.

so long,

Hias
