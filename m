Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAOKwU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 05:52:20 -0500
Message-ID: <54B79BDE.8090702@redhat.com>
Date: Thu, 15 Jan 2015 11:52:14 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: John McMaster <johndmcmaster@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PULL patches for 3.20]: New gspca touptek driver, gspca fixes and
 sunxi-cir driver improvments
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Note this pull-req superseeds my previous pull-req for 3.20 .

Please pull from my tree for a new gspca touptek driver, various
gspca fixes and some sunxi-cir driver improvments.

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

   [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.20

for you to fetch changes up to e6a734195e2fbd9386aa58fe8931dd30c013f23e:

   gspca: Fix underflow in vidioc_s_parm() (2015-01-15 11:46:17 +0100)

----------------------------------------------------------------
Antonio Ospite (1):
       gspca_stv06xx: enable button found on some Quickcam Express variant

Hans Verkuil (1):
       pwc: fix WARN_ON

Hans de Goede (3):
       rc: sunxi-cir: Add support for an optional reset controller
       rc: sunxi-cir: Add support for the larger fifo found on sun5i and sun6i
       gspca: Fix underflow in vidioc_s_parm()

Joe Howse (1):
       gspca: Add high-speed modes for PS3 Eye camera

John McMaster (1):
       gspca_touptek: Add support for ToupTek UCMOS series USB cameras

  .../devicetree/bindings/media/sunxi-ir.txt         |   4 +-
  drivers/media/rc/sunxi-cir.c                       |  46 +-
  drivers/media/usb/gspca/Kconfig                    |  10 +
  drivers/media/usb/gspca/Makefile                   |   2 +
  drivers/media/usb/gspca/gspca.c                    |   2 +-
  drivers/media/usb/gspca/ov534.c                    |  10 +-
  drivers/media/usb/gspca/stv06xx/stv06xx.c          |   4 +-
  drivers/media/usb/gspca/touptek.c                  | 732 +++++++++++++++++++++
  drivers/media/usb/pwc/pwc-if.c                     |  12 +-
  9 files changed, 800 insertions(+), 22 deletions(-)
  create mode 100644 drivers/media/usb/gspca/touptek.c

Thanks & Regards,

Hans
