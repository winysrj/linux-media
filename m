Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep24.mx.upcmail.net ([62.179.121.44]:48687 "EHLO
	fep24.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2LUFiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 00:38:01 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep12-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20121221053528.YLIZ2716.viefep12-int.chello.at@edge04.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Fri, 21 Dec 2012 06:35:28 +0100
Message-ID: <50D3F5A8.5010903@hispeed.ch>
Date: Fri, 21 Dec 2012 06:37:44 +0100
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: terratec h5 rev. 3?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've recently got a terratec h5 for dvb-c and thought it would be
supported but it looks like it's a newer revision not recognized by em28xx.
After using the new_id hack it gets recognized and using various htc
cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
seems to _nearly_ work but not quite (I was using h5 firmware for the
older version). Tuning, channel scan works however tv (or dvb radio)
does not, since it appears the error rate is going through the roof
(with some imagination it is possible to see some parts of the picture
sometimes and hear some audio pieces). femon tells something like this:

status SCVYL | signal 0000 | snr 013c | ber 00000000 | unc 0000c6f0 |
FE_HAS_LOCK
status SCVYL | signal 0000 | snr 013a | ber 00000000 | unc 0000036e |
FE_HAS_LOCK
status SCVYL | signal 0000 | snr 013c | ber 00000000 | unc 00003f06 |
FE_HAS_LOCK
status SCVYL | signal 0000 | snr 013d | ber 00000000 | unc 00007b2e |
FE_HAS_LOCK

Anyway, when not forcing card em28xx says this:
[ 1642.961213] usbcore: registered new interface driver em28xx
[ 1652.563675] em28xx: New device TERRATEC TERRATCE H5 Rev.3 @ 480 Mbps
(0ccd:10b6, interface 0, class 0)
[ 1652.563680] em28xx: Audio Vendor Class interface 0 found
[ 1652.563682] em28xx: Video interface 0 found
[ 1652.563684] em28xx: DVB interface 0 found
[ 1652.563735] em28xx #0: chip ID is em2884
[ 1655.686013] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[ 1655.686019] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 1655.686021] em28xx #0: Please send an email with this log to:
[ 1655.686023] em28xx #0:       V4L Mailing List
<linux-media@vger.kernel.org>
[ 1655.686025] em28xx #0: Board eeprom hash is 0x00000000
[ 1655.686027] em28xx #0: Board i2c devicelist hash is 0x1b800080

And forcing card=82 says this:
[ 2075.414249] em28xx: New device TERRATEC TERRATCE H5 Rev.3 @ 480 Mbps
(0ccd:10b6, interface 0, class 0)
[ 2075.414253] em28xx: Audio Vendor Class interface 0 found
[ 2075.414255] em28xx: Video interface 0 found
[ 2075.414257] em28xx: DVB interface 0 found
[ 2075.414343] em28xx #0: chip ID is em2884
[ 2075.465160] em28xx #0: Identified as Terratec Cinergy HTC Stick (card=82)
[ 2075.465215] em28xx #0: Config register raw data: 0x8a
[ 2075.465218] em28xx #0: v4l2 driver version 0.1.3
[ 2075.470162] em28xx #0: V4L2 video device registered as video1
[ 2075.965840] drxk: status = 0x639260d9
[ 2075.965846] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
[ 2080.467220] DRXK driver version 0.9.4300
[ 2080.500966] drxk: frontend initialized.
[ 2080.524306] tda18271 11-0060: creating new instance
[ 2080.526344] TDA18271HD/C2 detected @ 11-0060
[ 2080.685469] DVB: registering new adapter (em28xx #0)
[ 2080.685480] usb 2-3: DVB: registering adapter 0 frontend 0 (DRXK
DVB-C DVB-T)...
[ 2080.685913] em28xx #0: Successfully loaded em28xx-dvb
[ 2080.685920] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 2080.721017] Registered IR keymap rc-nec-terratec-cinergy-xs
[ 2080.721113] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc2/input17
[ 2080.721161] rc2: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc2
[ 2080.722466] Em28xx: Initialized (Em28xx Input Extension) extension
[ 2083.393968] tda18271: performing RF tracking filter calibration
[ 2084.847093] tda18271: RF tracking filter calibration complete

So I guess some of the board definition bits aren't quite right.
Any ideas how to get this to work?

Roland
