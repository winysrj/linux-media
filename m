Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64744 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0F3VVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 17:21:13 -0400
Received: by iwn7 with SMTP id 7so1272754iwn.19
        for <linux-media@vger.kernel.org>; Wed, 30 Jun 2010 14:21:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim2Z5kp4oi35UvUx5qmElrNkmjw0ptPd0ucvZKx@mail.gmail.com>
References: <AANLkTim2Z5kp4oi35UvUx5qmElrNkmjw0ptPd0ucvZKx@mail.gmail.com>
Date: Wed, 30 Jun 2010 22:21:11 +0100
Message-ID: <AANLkTinvkv-7-hunxWH8cPfWDgMFj46ii9O_ZDYfWW5J@mail.gmail.com>
Subject: Error loading dvb-usb-dw2102 - "disagrees about version of symbol
	dvb_usb_device_init
From: Austin Spreadbury <austinspreadbury@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have been using the package of drivers for the TeVii S660
(100222_linux_tevii_ds3000.rar) very happily for several months on
Mythbuntu (x86_64).  It did an auto-update over the weekend, which
seems to have upgraded the kernel version 2.6.31-22-generic (from -15-
I think).  I don't know whether that's relevant, but even having
rebuilt and installed the whole package of drivers I find whenever I
try to load the module dvb-usb-dw2102 I get this in /var/log/messages:

   Jun 30 22:03:47 mythmk2 kernel: [264566.557116] dvb_usb_dw2102:
disagrees about version of symbol dvb_usb_device_init
   Jun 30 22:03:47 mythmk2 kernel: [264566.557127] dvb_usb_dw2102:
Unknown symbol dvb_usb_device_init

Can anyone help me work out what I am doing wrong?

Thanks and regards,
Austin Spreadbury.
