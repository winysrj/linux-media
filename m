Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaF3N6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jun 2014 09:58:06 -0400
Message-ID: <53B16CDF.6040702@redhat.com>
Date: Mon, 30 Jun 2014 15:57:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Antonio Ospite <ao2@ao2.it>, Alexander Bersenev <bay@hackerdom.ru>,
	Alexsey Shestacov <wingrime@linux-sunxi.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: [PULL patches for 3.17]: 2 gspca patches + sunxi cir support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 gspca patches + sunxi cir support
(I'm a sunxi Linux support contributor and have reviewed and tested
the cir driver on various a10 and a20 SoC boards).

The following changes since commit b5b620584b9c4644b85e932895a742e0c192d66c:

  [media] technisat-sub2: Fix stream curruption on high bitrate (2014-06-26 09:20:18 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.17

for you to fetch changes up to c6c223d3bb3f0a8a0e7d07b71961737954d2e325:

  rc: add sunxi-ir driver (2014-06-30 15:48:40 +0200)

----------------------------------------------------------------
Alexander Bersenev (2):
      dt: bindings: Add binding documentation for sunxi IR controller.
      rc: add sunxi-ir driver

Antonio Ospite (2):
      gspca: provide a mechanism to select a specific transfer endpoint
      gspca_kinect: add support for the depth stream

 .../devicetree/bindings/media/sunxi-ir.txt         |  23 ++
 drivers/media/rc/Kconfig                           |  10 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/sunxi-cir.c                       | 318 +++++++++++++++++++++
 drivers/media/usb/gspca/gspca.c                    |  20 +-
 drivers/media/usb/gspca/gspca.h                    |   1 +
 drivers/media/usb/gspca/kinect.c                   |  98 ++++++-
 7 files changed, 454 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
 create mode 100644 drivers/media/rc/sunxi-cir.c

Thanks & Regards,

Hans
