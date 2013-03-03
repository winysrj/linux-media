Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63416 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCThD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:37:03 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so3394437eei.17
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:37:02 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 00/11] em28xx: i2c debugging cleanups and support for newer eeproms
Date: Sun,  3 Mar 2013 20:37:33 +0100
Message-Id: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first 3 patches clean up / simplify the debugging and info messages a bit.

Patches 4, 5 and 6 fix two bugs I've noticed while working on the eeprom stuff.

Patches 7-10 add support for the newer eeproms with 16 bit address width.
This allows us to display the eeprom content, to calculate the eeprom hash for 
board hints for devices with generic USB IDs, to read the device configuration 
and to use tveeprom for Hauppauge devices just as with the old eeprom type.

The used eeprom type depends on the chip type/id (confirmed by the Empia datasheets).
For unknown chips, the old 8 bit eeprom type is assumed, which makes sure that the
eeprom content can't be damaged accidentally.
In video capturing/TV/DVB devices, the new eeprom still has the old eeprom content 
(device configuration + tveeprom structure for Hauppauge devices) embedded.
Camera devices (em25xx, em276x+) however are using a different data structure,
which isn't supported yet.

Patch 11 is a follow-up which enables tveeprom for the Hauppauge HVR-930C

All patches have been tested with the following devices:
- Hauppauge HVR-900 (normal 8 bit eeprom)
- Hauppauge HVR-930C (16 bit eeprom, tveeprom)
- SpeedLink VAD Laplace webcam (16 bit eeprom, no device config dataset)

I also checked the USB log of the MSI Digivox ATSC which confirms that 
non-Hauppauge devices are using the same eeprom format.

Changes since v1:
- fixed the sanity check in patch 8
- fixed a minor output format issue in patch 10

Frank Schäfer (11):
  em28xx-i2c: replace printk() with the corresponding em28xx macros
  em28xx-i2c: get rid of the dprintk2 macro
  em28xx-i2c: also print debug messages at debug level 1
  em28xx: do not interpret eeprom content if eeprom key is invalid
  em28xx: fix eeprom data endianess
  em28xx: make sure we are at i2c bus A when calling
    em28xx_i2c_register()
  em28xx: add basic support for eeproms with 16 bit address width
  em28xx: add helper function for reading data blocks from i2c clients
  em28xx: do not store eeprom content permanently
  em28xx: extract the device configuration dataset from eeproms with 16
    bit address width
  em28xx: enable tveeprom for device Hauppauge HVR-930C

 drivers/media/usb/em28xx/em28xx-cards.c |   45 +++--
 drivers/media/usb/em28xx/em28xx-i2c.c   |  284 ++++++++++++++++++++-----------
 drivers/media/usb/em28xx/em28xx.h       |   17 +-
 3 Dateien geändert, 225 Zeilen hinzugefügt(+), 121 Zeilen entfernt(-)

-- 
1.7.10.4

