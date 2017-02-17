Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:26000 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbdBQAzm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 19:55:42 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH v3 0/3] Add support for MyGica T230C DVB-T2 stick
Date: Fri, 17 Feb 2017 01:55:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <ee7cd3b07e7447c683df5daa4cea3a3f@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The required command sequence for the new tuner (Si2141) was traced from the
current Windows driver and verified with a small python script/libusb.
The changes to the Si2168 and dvbsky driver are mostly additions of the
required IDs and some glue code.

Stefan Brüns (3):
  [media] si2157: Add support for Si2141-A10
  [media] si2168: add support for Si2168-D60
  [media] dvbsky: MyGica T230C support

 drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
 drivers/media/dvb-frontends/si2168.c      |  4 ++
 drivers/media/dvb-frontends/si2168_priv.h |  2 +
 drivers/media/tuners/si2157.c             | 23 +++++++-
 drivers/media/tuners/si2157_priv.h        |  2 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c     | 88 +++++++++++++++++++++++++++++++
 6 files changed, 118 insertions(+), 2 deletions(-)

-- 
2.11.0
