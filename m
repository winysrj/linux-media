Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbbAENSr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 08:18:47 -0500
Message-ID: <54AA8F2F.7050503@redhat.com>
Date: Mon, 05 Jan 2015 14:18:39 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: John McMaster <johndmcmaster@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PULL patches for 3.20]: New gspca touptek driver and sunxi-cir driver
 improvments
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for a new gspca touptek driver and some
sunxi-cir driver improvments.

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

   [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.20

for you to fetch changes up to bb729335790614dab96fab6dbed979a711955bdd:

   rc: sunxi-cir: Add support for the larger fifo found on sun5i and sun6i (2015-01-05 13:43:33 +0100)

----------------------------------------------------------------
Hans de Goede (2):
       rc: sunxi-cir: Add support for an optional reset controller
       rc: sunxi-cir: Add support for the larger fifo found on sun5i and sun6i

John McMaster (1):
       gspca_touptek: Add support for ToupTek UCMOS series USB cameras

  .../devicetree/bindings/media/sunxi-ir.txt         |   4 +-
  drivers/media/rc/sunxi-cir.c                       |  46 +-
  drivers/media/usb/gspca/Kconfig                    |  10 +
  drivers/media/usb/gspca/Makefile                   |   2 +
  drivers/media/usb/gspca/touptek.c                  | 732 +++++++++++++++++++++
  5 files changed, 782 insertions(+), 12 deletions(-)
  create mode 100644 drivers/media/usb/gspca/touptek.c

Thanks & Regards,

Hans
