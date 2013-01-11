Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62862 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3AKHkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 02:40:36 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so1175790vcd.33
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 23:40:36 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Jan 2013 08:40:36 +0100
Message-ID: <CAMFWA=ZL9ApT2KLJ490iLoZEhWYqHeMs2NAzST6OzCLr0PBx5A@mail.gmail.com>
Subject: Elgato EyeTV DTT
From: Marco <mpiazza@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm asking some help from the gurus....

I bought a brand new Elgato EyeTV DTT (last model), and It seems to be
initialized correctly.

But when I try to scan for channels I can hardly find one or two
channels, whereas my DVB decoder find more than 100 channels.

This is the log from dmesg (kernel 3.7.1):

dvb-usb: found a 'Elgato EyeTV DTT rev. 2' in cold state, will try to
load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Elgato EyeTV DTT rev. 2' in warm state.
power control: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Elgato EyeTV DTT rev. 2)
DiB7000P: checking demod on I2C address: 128 (80)
ep 0 read error (status = -32)
I2C read failed on address 0x40
DiB7000P: i2c read error on 768
DiB7000P: wrong Vendor ID (read=0x0)
DiB7000P: checking demod on I2C address: 18 (12)
DiB7000P: setting output mode for demod f50e0000 to 4
DiB7000P: IC 0 initialized (to i2c_address 0x80)
DiB7000P: setting output mode for demod f50e0000 to 0
DiB7000P: checking demod on I2C address: 128 (80)
DiB7000P: gpio dir: ffff: val: 0, pwm_pos: ffff
DiB7000P: setting output mode for demod f50e0000 to 0
DiB7000P: using default timf
usb 1-1: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
sleep: 0reset: 1reset: 0
DiB0070: Revision: 3
DiB0070: CTRL_LO5: 0x16a5
DiB0070: Gain: 6, WBDOffset (3.3V) = 543
DiB0070: Gain: 7, WBDOffset (3.3V) = 631
DiB0070: successfully identified
DiB0070: successfully identified
power control: 0
dvb-usb: Elgato EyeTV DTT rev. 2 successfully initialized and connected.
Firmware version: 66, 17, 0x10200, 0

Do I have to worry about those I2C errors in DIB7000P?
Is Dib0070 the right tuner for this card?
Is there something I can do to make the card work better?

Marco
