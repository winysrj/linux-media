Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:62246 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdBLP0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 10:26:33 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 0/3] Add support for MyGica T230C DVB-T2 stick
Date: Sun, 12 Feb 2017 16:26:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <2d61325e1fdc496ea5f2c4ab37a30aae@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The required command sequence for the new tuner (Si2141) was traced from the
current Windows driver and verified with a small python script/libusb.
The changes to the Si2168 and cxusb driver are mostly addition of the
required IDs and some glue code.

Stefan Brüns (3):
  [media] si2157: Add support for Si2141-A10
  [media] si2168: add support for Si2168-D60
  [media] cxusb: MyGica T230C support

 drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
 drivers/media/dvb-frontends/si2168.c      |  4 ++
 drivers/media/dvb-frontends/si2168_priv.h |  2 +
 drivers/media/tuners/si2157.c             | 23 ++++++++-
 drivers/media/tuners/si2157_priv.h        |  2 +
 drivers/media/usb/dvb-usb/cxusb.c         | 80 +++++++++++++++++++++++++++++--
 6 files changed, 106 insertions(+), 6 deletions(-)

-- 
2.11.0
