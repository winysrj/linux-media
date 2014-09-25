Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:56193 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaIYPNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 11:13:00 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so221373wes.24
        for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 08:12:59 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Sep 2014 17:12:59 +0200
Message-ID: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
Subject: TeVii S480 in Debian Wheezy
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I want to use a new dual DVB-S2 device, TeVii S480.

I am using Debian Wheezy with 3.2 kernel, I copy the firmware files:

# md5sum /lib/firmware/dvb-*
a32d17910c4f370073f9346e71d34b80  /lib/firmware/dvb-fe-ds3000.fw
2946e99fe3a4973ba905fcf59111cf40  /lib/firmware/dvb-usb-s660.fw

The device is listed as 2 USB devices:

# lsusb | grep TeVii
Bus 006 Device 002: ID 9022:d483 TeVii Technology Ltd.
Bus 007 Device 002: ID 9022:d484 TeVii Technology Ltd.

But there is no any device in /dev/dvb/:

# ls -l /dev/dvb/
ls: cannot access /dev/dvb/: No such file or directory

Need I install any other driver or piece of software?

I will appreciate any help.

Best regards.

-- 
Josu Lazkano
