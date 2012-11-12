Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37504 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2KLJ3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 04:29:34 -0500
Received: by mail-ob0-f174.google.com with SMTP id uo13so5991970obb.19
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2012 01:29:33 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Nov 2012 10:29:33 +0100
Message-ID: <CAL9G6WWCRp+XZ+rLq_M=R3f23t6e2YOtE7HEz+0Y=pUbpp8AuA@mail.gmail.com>
Subject: Build v4l-dvb on Debian
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I want to configure my Debian system (2.6.32 kernel) to work with a
dual DVB-T USB device. I need recent drivers to get working both
device (af9013).

There are lots of change made by Antti Palosaari that I want to
include on the build:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git&a=search&h=HEAD&st=commit&s=af9013

I install the sources this way:

mkdir /usr/local/src/dvb
cd /usr/local/src/dvb
git clone git://linuxtv.org/media_build.git
cd media_build
./build
make install

Now, both tuners works great but I have lots of dmesg: (10 lines per second)

# tail /var/log/syslog
Nov 12 10:27:07 htpc kernel: [56643.368049] usb 1-5: dvb_usb_v2:
usb_bulk_msg() failed=-19
Nov 12 10:27:07 htpc kernel: [56643.368060] i2c i2c-1: af9013: i2c rd
failed=-19 reg=d07c len=2
Nov 12 10:27:07 htpc kernel: [56643.668039] usb 1-5: dvb_usb_v2:
usb_bulk_msg() failed=-19
Nov 12 10:27:07 htpc kernel: [56643.668051] i2c i2c-1: af9013: i2c rd
failed=-19 reg=d2e1 len=1
Nov 12 10:27:07 htpc kernel: [56643.668058] usb 1-5: dvb_usb_v2:
usb_bulk_msg() failed=-19
Nov 12 10:27:07 htpc kernel: [56643.668065] i2c i2c-1: af9013: i2c wr
failed=-19 reg=d2e1 len=1
Nov 12 10:27:08 htpc kernel: [56643.868037] usb 1-5: dvb_usb_v2:
usb_bulk_msg() failed=-19
Nov 12 10:27:08 htpc kernel: [56643.868048] i2c i2c-1: af9013: i2c rd
failed=-19 reg=d391 len=1
Nov 12 10:27:08 htpc kernel: [56643.868056] usb 1-5: dvb_usb_v2:
usb_bulk_msg() failed=-19
Nov 12 10:27:08 htpc kernel: [56643.868062] i2c i2c-1: af9013: i2c wr
failed=-19 reg=d391 len=1

My questions are:

1. I am missing something? Did I build it correctly?

2. Could I delete all failed message from the dmesg?

Regards.

--
Josu Lazkano
