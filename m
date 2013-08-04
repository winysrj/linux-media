Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42731 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3HDM4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Aug 2013 08:56:49 -0400
Received: by mail-oa0-f52.google.com with SMTP id n12so4277234oag.25
        for <linux-media@vger.kernel.org>; Sun, 04 Aug 2013 05:56:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 4 Aug 2013 13:56:49 +0100
Message-ID: <CAFoaQoAjc-v6UiYxu8ZzaOQi4g8GurYdCB6JM8-GKQbYugJwTw@mail.gmail.com>
Subject: mceusb Fintek ir transmitter only works when X is not running
From: Rajil Saraswat <rajil.s@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a HP MCE ir transreceiver which is recognised as Fintek device.
The receiver works fine, however the transmitter only works when there
is no X session running.


When X is stopped and the following command is issued from the virtual
console (tty1), then the transmitter works:

irsend SEND_ONCE mceusb KEY_1


However, as soon as X is started even though irsend goes through, the
transmitter led's dont go through. Any idea why this may be happening?



These are the system details:
#uname -a
Linux localhost 3.10.4-gentoo #7 SMP Sun Aug 4 12:07:08 BST 2013
x86_64 Intel(R) Core(TM) i5 CPU M 520 @ 2.40GHz GenuineIntel GNU/Linux

# lsusb
Bus 002 Device 008: ID 1934:5168 Feature Integration Technology Inc.
(Fintek) F71610A or F71612A Consumer Infrared Receiver/Transceiver

#cat /etc/conf.d/lircd
LIRCD_OPTS="-d /dev/lirc0"


Thanks
Rajil
