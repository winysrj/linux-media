Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:50332 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZKLVeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 16:34:36 -0500
Received: by fxm21 with SMTP id 21so2751017fxm.21
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 13:34:41 -0800 (PST)
Subject: DIB3000 DVB-USB device with Linux kernel 2.6.31
From: Matthias Niklas <matthias.niklas@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 22:34:38 +0100
Message-ID: <1258061678.4372.11.camel@matthias-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

my DVB-T device (a Twinhan / DIB3000 compatible device) was working fine till kernel 2.6.28.
After upgrading to the new kernel this device is not working properly anymore.

The device has been recognized by the kernel. The dmesg excerpt please
find below: 

"[   13.159468] dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box
"I / HAMA USB1.1 DVB-T device' in warm state.
"[   13.182663] dvb-usb: will use the device's hardware PID filter
"(table count: 16).
"[   13.564013] dvb-usb: schedule remote query interval to 150 msecs.
"[   13.597164] dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA
"USB1.1 DVB-T device successfully initialized and connected.
"[   13.597292] usbcore: registered new interface driver
"dvb_usb_dibusb_mb

But however - even with compiling and using the newest driver version
from linuxtv.org - I have still problems with it. Whenever I try to use
scan or tzap to tune to a channel with that device I only get tuning
errors.
Also the box's status LED's don't change as well (still switched) of. So
it seems that the box doesn't get the right commands for tuning.

Can somebody please have a look into that matter? I can give more
information if necessary.

Thank you very much.

kind regards.


Matthias Niklas

PS: I describe myself as an advanced linux user with basic compiling and
driver installation skills but if you need any specific information
please described detailed what and how to get those information.


