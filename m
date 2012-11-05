Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:43199 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab2KEX2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 18:28:35 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 0/5] dvb-usb: support VP-7049 Twinhan DVB-T USB Stick and other fixes
Date: Tue,  6 Nov 2012 00:28:11 +0100
Message-Id: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with this series I am adding support for the VP-7049 Twinhan DVB-T USB stick,
the device comes also under other names as specified in the appropriate commit
messages.

Patch 1 extends the initialization sequence to support this particular
hardware, it's a dependency for patch 3. I am open to alternative solutions.

Patches 2 and 3 add support for the hardware, all the pieces were already in
linux, thanks a lot!

Patches 4 and 5 are trivial fixes for stuff I noticed while looking at the
code, feel free to ignore especially patch 4 if you find it too intrusive.

Please note that I arbitrarily ignored checkpatch.pl warnings and errors
because I preferred to stick with the code style in use in the dvb-usb files,
let me know if you want me to do otherwise.

Thanks,
   Antonio

Antonio Ospite (5):
  [media] dvb-usb: add a pre_init hook to struct
    dvb_usb_device_properties
  [media] get_dvb_firmware: add dvb-usb-vp7049-0.95.fw
  [media] m920x: Add support for the VP-7049 Twinhan DVB-T USB Stick
  [media] dvb-usb: fix indentation of a for loop
  [media] m920x: fix a typo in a comment

 drivers/media/dvb-core/dvb-usb-ids.h     |    1 +
 drivers/media/usb/dvb-usb/dvb-usb.h      |    5 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   66 ++++++-----
 drivers/media/usb/dvb-usb/m920x.c        |  191 +++++++++++++++++++++++++++++-
 Documentation/dvb/get_dvb_firmware       |   15 ++-
 5 files changed, 246 insertions(+), 32 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
