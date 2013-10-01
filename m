Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:47549 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3JAJNg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 05:13:36 -0400
Received: by mail-qe0-f50.google.com with SMTP id a11so4703539qen.37
        for <linux-media@vger.kernel.org>; Tue, 01 Oct 2013 02:13:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Oct 2013 11:13:35 +0200
Message-ID: <CAL9G6WWT-a-kGM3MruRyTUa9rrsq86c3tiq9LMKGuwTb8oifJw@mail.gmail.com>
Subject: af9013 i2c errors
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I don't know if this is a bug, but I have problems with my
device: http://www.linuxtv.org/wiki/index.php/KWorld_USB_Dual_DVB-T_TV_Stick_(DVB-T_399U)

I am using it in a Debian Wheezy machine: Linux server 3.2.0-4-amd64
#1 SMP Debian 3.2.46-1+deb7u1 x86_64 GNU/Linux

With this firmware:
http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw

The problem is that I have glitches when watching channels.

This is the kernel logs:

# tail /var/log/messages
Oct  1 11:01:35 server kernel: [149863.986812] af9013: I2C read failed reg:d07d
Oct  1 11:01:41 server kernel: [149870.513600] af9013: I2C read failed reg:d2e6
Oct  1 11:02:03 server kernel: [149891.697286] af9013: I2C read failed reg:d2e6
Oct  1 11:02:17 server kernel: [149906.348441] af9013: I2C read failed reg:d333
Oct  1 11:02:24 server kernel: [149912.894103] af9013: I2C read failed reg:d507
Oct  1 11:02:36 server kernel: [149925.169533] af9013: I2C read failed reg:d2e6
Oct  1 11:03:15 server kernel: [149964.404593] af9013: I2C read failed reg:d2e5
Oct  1 11:03:22 server kernel: [149970.917832] af9013: I2C read failed reg:d507
Oct  1 11:04:13 server kernel: [150022.431228] af9013: I2C read failed reg:d07c
Oct  1 11:04:20 server kernel: [150028.955682] af9013: I2C read failed reg:d2e5

Is this really a bug?

Thanks.

-- 
Josu Lazkano
