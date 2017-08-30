Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35420 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdH3AnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 20:43:22 -0400
Received: by mail-yw0-f179.google.com with SMTP id s187so24694795ywf.2
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 17:43:22 -0700 (PDT)
MIME-Version: 1.0
From: Mike Atkinson <kdx7214@gmail.com>
Date: Tue, 29 Aug 2017 19:43:21 -0500
Message-ID: <CAAxvtFYjbGzEHi0PTVG+c=HYMZ+7bORcpYXZSVfG1yZ7qndzQg@mail.gmail.com>
Subject: GP fault in cx18 module from v4l-dvb drivers on linuxtv.org (Ubuntu 17.04)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Having a problem with a #GP fault when loading the cx18 driver from
v4l-dvb from the linuxtv.org site.


Device:  Hauppauge HVR-1600 (lspci output at pastebin.com/e7G52kqQ)
(ATSC signals)

Environment:  Ubuntu 17.04, kernel 4.10.0-33-generic, 64-bit

Hardware:  Motherboard:  Gigabyte GA-B150M-D3H  (16GB RAM)


I've downloaded the v4l-dvb kernel drivers, built them, and installed
them.  I was unable to use the built-in drivers as I needed the
cx18-i2c driver.


>From the stack trace included with the pastebin link above it appears
the problem is in find_ref_lock() when called from c18_probe() if that
helps immediately.


Things I've tried:

    -- Remove kernel drivers/Reboot/Install v4l-dvb
drivers/build/install/modprobe

    -- Do a 'make rminstall' to remove drivers and attempt
install/modprobe again


I found it interesting that even though the #GP happens and the /dev
entries are not created, the cx18 module still loads (as found with
lsmod) but no cx18-i2c was loaded.
