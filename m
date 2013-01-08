Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49530 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3AHVyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 16:54:21 -0500
Received: by mail-ee0-f48.google.com with SMTP id b57so495598eek.35
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 13:54:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: erangaj@gmail.com
Date: Wed, 9 Jan 2013 07:54:20 +1000
Message-ID: <CAEmrET+1-G4vtyjD=0cFei8orfujir1EBhRsb+A9CsssrOidJg@mail.gmail.com>
Subject: 15a4:1001 fails. (Afatech AF9035)
From: Eranga Jayasundera <erangaj@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

I wasn't able to install the driver for Afatech AF9035 (15a4:1001) on
my mythbuntu (kernel v3.2.0) box.

I used the bellow commands to install the driver. It was compiled and
installed without errors.

git clone git://linuxtv.org/media_build.git
cd media_build
./build
sudo make install


dmesg output:

[  138.998628] input: Afa Technologies Inc. AF9035A USB Device as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6.2/2-1.6.2:1.1/input/input13
[  138.998826] generic-usb 0003:15A4:1001.0004: input,hidraw3: USB HID
v1.01 Keyboard [Afa Technologies Inc. AF9035A USB Device] on
usb-0000:00:1d.0-1.6.2/input1
[  139.015499] usb 2-1.6.2: dvb_usb_v2: found a 'Afatech AF9035
reference design' in cold state
[  139.016174] usbcore: registered new interface driver dvb_usb_af9035
[  139.018104] usb 2-1.6.2: dvb_usb_v2: Did not find the firmware file
'dvb-usb-af9035-02.fw'. Please see linux/Documentation/dvb/ for more
details on firmware-problems. Status -2
[  139.018109] usb 2-1.6.2: dvb_usb_v2: 'Afatech AF9035 reference
design' error while loading driver (-2)
[  139.018116] usb 2-1.6.2: dvb_usb_v2: 'Afatech AF9035 reference
design' successfully deinitialized and disconnected
[  180.666110] usb 2-1.6.2: USB disconnect, device number 8


Any thoughts?

Best regards,
Eranga
