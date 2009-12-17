Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:63775 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965422AbZLQTb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 14:31:26 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1079961fgg.1
        for <linux-media@vger.kernel.org>; Thu, 17 Dec 2009 11:31:25 -0800 (PST)
Message-ID: <4B2A8709.8040401@gmail.com>
Date: Thu, 17 Dec 2009 20:31:21 +0100
From: Oliver Fasching <o.fasching.logic.at@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cinergy_T_Stick_RC_MKII
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

anyone ever seen a usb Cinergy T Stick RC MKII, TerraTec Electronic GmbH
(0ccd:0097) before? Hints? Is sold as a Cinergy T RC (dvb-t with remote control).

I am willing to program if someone gives me a hint how to start,
unfortunately, I am not into kernel programming.

Official home: http://ftp.terratec.de/Receiver/Cinergy_T_Stick_RC_MKII
lsusb says "0ccd:0097 TerraTec Electronic GmbH".
The labels I found inside are:
        AF9015A-N1, 0940 hm0hh; (Afatech)
        tda1821hn, cr2809, 10, tsd09352;
		Could be http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf
        lizel24c02+si, 0739;
        JWT12000;
        16a000l1ap;
        dm232t ver2.0, rohs 0945;

I did
        add-apt-repository ppa:libv4l
	aptitude update
	aptitude full-upgrade
        hg clone http://linuxtv.org/hg/~jfrancois/gspca/
on a Ubuntu 9.10, and just to try out, I patched some terratec user id in
        gspca/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
to 0097. Of course, I only got
        input: NEWMI USB2.0 DVB-T TV Stick as /devices/pci0000:00/0000:00:0b.1/usb1/1-8/1-8:1.1/input/input11
        generic-usb 0003:0CCD:0097.0005: input,hidraw0: USB HID v1.01 Keyboard [NEWMI USB2.0 DVB-T TV Stick] on usb-0000:00:0b.1-8/input1
        af9015: tuner id:179 not supported, please report!
        usbcore: registered new interface driver dvb_usb_af9015

What to do next if there is no driver for this?

By the way, stick works perfectly in XP (without virtualbox).
Under XP in virtualbox, I get audio, at least.

Oliver
