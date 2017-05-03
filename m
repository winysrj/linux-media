Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48391
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754929AbdECCM2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 22:12:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 0/2] Add support for Terratec H6 version 2
Date: Tue,  2 May 2017 23:12:21 -0300
Message-Id: <cover.1493776983.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's the third version of this patch series. It adds support
for Terratec H6 version 2.

As on the past version, this board is identified as "H5 MKII".
There's a typo on the manufacturer's name, though:

[ 2970.196999] usb 1-1.5: Product: TERRATCE H5 MKII
[ 2970.197011] usb 1-1.5: Manufacturer: TERRATEC

While I wrote the patches, I don't have this verson of
this device. The tests were run by an IRC user. Thanks!

The first patch is actually not needed for this device to work,
but it fixes an issue: if something goes bad while reading
the eeprom, the device probe aborts. As we don't really need
to read the eeprom contents, we safely ignore any errors there.

While not certain why eeprom reading was failing with this
device, I suspect that this particular device require some
GPIO setting before being able to read its eeprom content.

The second patch in this series add support for the board.

-

v3: Improve patch documentation
v2: Ignore eeprom errors
v1: was assuming that eeprom would be at bus 1. such hipotesys
    didn't confirm on the tests done today.

Mauro Carvalho Chehab (2):
  em28xx: Ignore errors while reading from eeprom
  em28xx: add support for new of Terratec H6

 drivers/media/usb/em28xx/em28xx-cards.c | 18 ++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
 drivers/media/usb/em28xx/em28xx-i2c.c   |  2 --
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.9.3
