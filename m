Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:45534 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753395AbdK2OoD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 09:44:03 -0500
Date: Wed, 29 Nov 2017 15:44:00 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: [BUG] ir-ctl: error sending file with multiple scancodes
Message-ID: <20171129144400.ojhd32gz33wabp33@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

According to the ir-ctl manpage it should be possible to send a file
containing multiple scancodes, but when trying to do this I get
a warning and an error message.

I initially noticed that on version 1.12.3 but 1.12.5 and master
(rev 85f8e5a99) give the same error.

Sending a file with a single scancode or using the -S option
to specify the scancode on the command line both work fine.

I've tested with the following file:

scancode sony12:0x100015
space 25000
scancode sony12:0x100015

Trying to send it gives this:
$ ./utils/ir-ctl/ir-ctl -s ../sony-test.irctl
warning: ../sony-test.irctl:2: trailing space ignored
/dev/lirc0: failed to send: Invalid argument

Checking with the -v option gives some interesting output - it
looks like the the second half of the buffer hadn't been filled in:

$ ./utils/ir-ctl/ir-ctl -v -s ../sony-test.irctl
warning: ../sony-test.irctl:2: trailing space ignored
Sending:
pulse 2400
space 600
pulse 1200
space 600
pulse 600
space 600
pulse 1200
space 600
pulse 600
space 600
pulse 1200
space 600
pulse 600
space 600
pulse 600
space 600
pulse 600
space 600
pulse 600
space 600
pulse 600
space 600
pulse 600
space 600
pulse 1200
space 600
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
space 0
pulse 0
/dev/lirc0: failed to send: Invalid argument

The goal I'm trying to achieve is to send a repeated signal with ir-ctl
(a user reported his sony receiver needs this to actually power up).

Using the -S option multiple times comes rather close, but the 125ms
delay between signals is a bit long for the sony protocol - would be
nice if that would be adjustable :)

so long,

Hias
