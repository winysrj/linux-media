Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:6841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0AKS7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 13:59:42 -0500
Received: by fg-out-1718.google.com with SMTP id 22so859463fge.1
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 10:59:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
Date: Mon, 11 Jan 2010 11:59:40 -0700
Message-ID: <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
Subject: How to use saa7134 gpio via gpio-sysfs?
From: Gordon Smith <spider.karma+linux-media@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need to bit twiddle saa7134 gpio pins from userspace.
To use gpio-sysfs, I need a "GPIO number" to export each pin, but I
do not know how to find such a number.

Card is RTD Embedded Technologies VFG7350 [card=72,autodetected].
GPIO uses pcf8574 chip.
Kernel is 2.6.30.

gpio-sysfs creates
    /sys/class/gpio/export
    /sys/class/gpio/import
but no gpio<n> entries so far.

>From dmesg ("gpiotracking=1")
    saa7133[0]: board init: gpio is 10000
    saa7133[0]: gpio: mode=0x0000000 in=0x4011000 out=0x0000000 [pre-init]
    saa7133[1]: board init: gpio is 10000
    saa7133[1]: gpio: mode=0x0000000 in=0x4010f00 out=0x0000000 [pre-init]

How may I find each "GPIO number" for this board?

Thanks in advance for any help.
