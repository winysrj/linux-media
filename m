Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s19.blu0.hotmail.com ([65.55.111.94]:15377 "EHLO
	blu0-omc2-s19.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbZHKREv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 13:04:51 -0400
Message-ID: <BLU0-SMTP36E4E04B3A0F5308D899C298070@phx.gbl>
Subject: gspca: Trust webcam WB 300P ID 093a:2608 doesn't work
From: Claudio Chimera <ckhmer1l@live.it>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 19:04:33 +0200
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm trying to use the Trust webcam WB 300P (ID 093a:2608 ) unsuccessful.

The complete lsusb command is following:

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 093a:2608 Pixart Imaging, Inc. 
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

When I use amsn, I can select the webcam but I get an error (unable to
capture ...)

The /var/log/message is following:


Aug 11 18:35:06 cchi-desktop kernel: [ 3447.714061] usb 1-2.4: new full
speed USB device using ehci_hcd and address 3
Aug 11 18:35:06 cchi-desktop kernel: [ 3447.836067] usb 1-2.4:
configuration #1 chosen from 1 choice
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.112057] gspca: main v2.3.0
registered
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.170206] gspca: probing
093a:2608
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.180041] gspca: probe ok
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.180041] gspca: probing
093a:2608
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.180041] gspca: probing
093a:2608
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.180041] usbcore: registered
new interface driver pac7311
Aug 11 18:35:06 cchi-desktop kernel: [ 3448.180041] pac7311: registered
Aug 11 18:35:07 cchi-desktop kernel: [ 3448.724060] usbcore: registered
new interface driver snd-usb-audio
Aug 11 18:35:08 cchi-desktop pulseaudio[3943]: alsa-util.c: Device hw:2
doesn't support 44100 Hz, changed to 16000 Hz.
Aug 11 18:35:08 cchi-desktop pulseaudio[3943]: alsa-util.c: Device hw:2
doesn't support 2 channels, changed to 1.


Aug 11 18:44:25 cchi-desktop kernel: [ 4007.040063] gspca:
usb_submit_urb [0] err -28
Aug 11 18:44:40 cchi-desktop kernel: [ 4022.040062] gspca:
usb_submit_urb [0] err -28

Thanks
Claudio


