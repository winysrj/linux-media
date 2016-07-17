Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbcGQRHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/15] [media] doc-rst: move DVB avulse docs to Documentation/media
Date: Sun, 17 Jul 2016 14:06:56 -0300
Message-Id: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several documentation stuff under Documentation/dvb.

Move them to Documentation/media/dvb-drivers and rename them to
rst, as they'll soon be converted to rst files.

No changes at the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/{dvb/avermedia.txt => media/dvb-drivers/avermedia.rst}      | 0
 Documentation/{dvb/bt8xx.txt => media/dvb-drivers/bt8xx.rst}              | 0
 Documentation/{dvb/cards.txt => media/dvb-drivers/cards.rst}              | 0
 Documentation/{dvb/ci.txt => media/dvb-drivers/ci.rst}                    | 0
 .../{dvb/contributors.txt => media/dvb-drivers/contributors.rst}          | 0
 Documentation/{dvb/README.dvb-usb => media/dvb-drivers/dvb-usb.rst}       | 0
 Documentation/{dvb/faq.txt => media/dvb-drivers/faq.rst}                  | 0
 Documentation/{dvb/readme.txt => media/dvb-drivers/index.rst}             | 0
 Documentation/{dvb/lmedm04.txt => media/dvb-drivers/lmedm04.rst}          | 0
 .../{dvb/opera-firmware.txt => media/dvb-drivers/opera-firmware.rst}      | 0
 Documentation/{dvb/technisat.txt => media/dvb-drivers/technisat.rst}      | 0
 Documentation/{dvb/ttusb-dec.txt => media/dvb-drivers/ttusb-dec.rst}      | 0
 Documentation/{dvb/udev.txt => media/dvb-drivers/udev.rst}                | 0
 {Documentation/dvb => scripts}/get_dvb_firmware                           | 0
 14 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{dvb/avermedia.txt => media/dvb-drivers/avermedia.rst} (100%)
 rename Documentation/{dvb/bt8xx.txt => media/dvb-drivers/bt8xx.rst} (100%)
 rename Documentation/{dvb/cards.txt => media/dvb-drivers/cards.rst} (100%)
 rename Documentation/{dvb/ci.txt => media/dvb-drivers/ci.rst} (100%)
 rename Documentation/{dvb/contributors.txt => media/dvb-drivers/contributors.rst} (100%)
 rename Documentation/{dvb/README.dvb-usb => media/dvb-drivers/dvb-usb.rst} (100%)
 rename Documentation/{dvb/faq.txt => media/dvb-drivers/faq.rst} (100%)
 rename Documentation/{dvb/readme.txt => media/dvb-drivers/index.rst} (100%)
 rename Documentation/{dvb/lmedm04.txt => media/dvb-drivers/lmedm04.rst} (100%)
 rename Documentation/{dvb/opera-firmware.txt => media/dvb-drivers/opera-firmware.rst} (100%)
 rename Documentation/{dvb/technisat.txt => media/dvb-drivers/technisat.rst} (100%)
 rename Documentation/{dvb/ttusb-dec.txt => media/dvb-drivers/ttusb-dec.rst} (100%)
 rename Documentation/{dvb/udev.txt => media/dvb-drivers/udev.rst} (100%)
 rename {Documentation/dvb => scripts}/get_dvb_firmware (100%)

diff --git a/Documentation/dvb/avermedia.txt b/Documentation/media/dvb-drivers/avermedia.rst
similarity index 100%
rename from Documentation/dvb/avermedia.txt
rename to Documentation/media/dvb-drivers/avermedia.rst
diff --git a/Documentation/dvb/bt8xx.txt b/Documentation/media/dvb-drivers/bt8xx.rst
similarity index 100%
rename from Documentation/dvb/bt8xx.txt
rename to Documentation/media/dvb-drivers/bt8xx.rst
diff --git a/Documentation/dvb/cards.txt b/Documentation/media/dvb-drivers/cards.rst
similarity index 100%
rename from Documentation/dvb/cards.txt
rename to Documentation/media/dvb-drivers/cards.rst
diff --git a/Documentation/dvb/ci.txt b/Documentation/media/dvb-drivers/ci.rst
similarity index 100%
rename from Documentation/dvb/ci.txt
rename to Documentation/media/dvb-drivers/ci.rst
diff --git a/Documentation/dvb/contributors.txt b/Documentation/media/dvb-drivers/contributors.rst
similarity index 100%
rename from Documentation/dvb/contributors.txt
rename to Documentation/media/dvb-drivers/contributors.rst
diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/media/dvb-drivers/dvb-usb.rst
similarity index 100%
rename from Documentation/dvb/README.dvb-usb
rename to Documentation/media/dvb-drivers/dvb-usb.rst
diff --git a/Documentation/dvb/faq.txt b/Documentation/media/dvb-drivers/faq.rst
similarity index 100%
rename from Documentation/dvb/faq.txt
rename to Documentation/media/dvb-drivers/faq.rst
diff --git a/Documentation/dvb/readme.txt b/Documentation/media/dvb-drivers/index.rst
similarity index 100%
rename from Documentation/dvb/readme.txt
rename to Documentation/media/dvb-drivers/index.rst
diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/media/dvb-drivers/lmedm04.rst
similarity index 100%
rename from Documentation/dvb/lmedm04.txt
rename to Documentation/media/dvb-drivers/lmedm04.rst
diff --git a/Documentation/dvb/opera-firmware.txt b/Documentation/media/dvb-drivers/opera-firmware.rst
similarity index 100%
rename from Documentation/dvb/opera-firmware.txt
rename to Documentation/media/dvb-drivers/opera-firmware.rst
diff --git a/Documentation/dvb/technisat.txt b/Documentation/media/dvb-drivers/technisat.rst
similarity index 100%
rename from Documentation/dvb/technisat.txt
rename to Documentation/media/dvb-drivers/technisat.rst
diff --git a/Documentation/dvb/ttusb-dec.txt b/Documentation/media/dvb-drivers/ttusb-dec.rst
similarity index 100%
rename from Documentation/dvb/ttusb-dec.txt
rename to Documentation/media/dvb-drivers/ttusb-dec.rst
diff --git a/Documentation/dvb/udev.txt b/Documentation/media/dvb-drivers/udev.rst
similarity index 100%
rename from Documentation/dvb/udev.txt
rename to Documentation/media/dvb-drivers/udev.rst
diff --git a/Documentation/dvb/get_dvb_firmware b/scripts/get_dvb_firmware
similarity index 100%
rename from Documentation/dvb/get_dvb_firmware
rename to scripts/get_dvb_firmware
-- 
2.7.4

