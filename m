Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41318 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2ALSCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 13:02:48 -0500
Received: by eaal12 with SMTP id l12so753011eaa.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 10:02:47 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Jan 2012 19:02:47 +0100
Message-ID: <CANbcZdNK5v5i=a13sEE216-HjEnXXciWCe_jc139N3MVnKP5oA@mail.gmail.com>
Subject: Problem with WinTV HVR-930C
From: Daniel Rindt <daniel.rindt@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

i am running Fedora 16 64bit and have no luck to get working the WinTV
HVR-930C. Invoked command lsusb told me: Bus 001 Device 002: ID
2040:1605 Hauppauge. Installed from update-testing-repository is the
most recent kernel version kernel-3.1.8-2.fc16.x86_64.

Loaded the em28xx by hand and shows up this in dmesg:
[  482.220534] IR NEC protocol handler initialized
[  482.228352] IR RC5(x) protocol handler initialized
[  482.229710] Linux media interface: v0.10
[  482.235907] Linux video capture interface: v2.00
[  482.240601] IR RC6 protocol handler initialized
[  482.257921] IR JVC protocol handler initialized
[  482.263175] IR Sony protocol handler initialized
[  482.268460] IR MCE Keyboard/mouse protocol handler initialized
[  482.273807] usbcore: registered new interface driver em28xx
[  482.273816] em28xx driver loaded
[  482.275215] lirc_dev: IR Remote Control driver registered, major 249
[  482.285327] IR LIRC bridge handler initialized

I am in doubt that the newest development is included in this kernel
release. Or maybe i have do something wrong. Your help is much
appreciated.

Thanks
Daniel
