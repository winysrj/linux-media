Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2HTSWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:19 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMJx9024876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/6] media reorganization - part 3
Date: Mon, 20 Aug 2012 15:22:09 -0300
Message-Id: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I was hoping to do it into 2 parts only... but there are
still a few missing bits that justify a third set of patches...

The first patch of this series just do:
	rename drivers/media/platform/{ => soc_camera}

There are too many soc_camera drivers to justify its own dir.
In a matter of fact, except for drivers that has just one file,
it seems better that drivers would have their on directory. That
helps organizing things and properly indicate who owns each
driver at MAINTAINERS file.

The remaining drivers are just Kconfig improvements.

After those changes, the main multimedia menu config will look like:


1) Subsystem "core" support, e. g. API's enabled:

      --- Multimedia support
            *** Multimedia core support ***
      [*]   Cameras/video grabbers support
      [*]   Analog TV support
      [*]   Digital TV support
      [*]   AM/FM radio receivers/transmitters support
      [*]   Remote Controller support
      [*]   Media Controller API (EXPERIMENTAL)
      [*]   V4L2 sub-device userspace API (EXPERIMENTAL)
      [*]   Enable advanced debug functionality on V4L2 drivers
      [*]   Enable old-style fixed minor ranges on drivers/video devices
      [*]   DVB Network Support
      (8)   maximum number of DVB/ATSC adapters
      [*]   Dynamic DVB minor allocation


2) Media drivers support, organized by bus:
            *** Media drivers ***
      <*>   Compile Remote Controller keymap modules
      [*]   Remote controller decoders  --->
      [*]   Remote Controller devices  --->
      [*]   Media USB Adapters  --->
      [*]   Media PCI Adapters  --->
      [*]   V4L platform devices
      [*]   Memory-to-memory multimedia devices
      [*]   Media test drivers  --->
            *** Supported MMC/SDIO adapters ***
      <*>   Siano SMS1xxx based MDTV via SDIO interface
      [*]   V4L ISA and parallel port devices
      [*]   Radio Adapters  --->
            *** Supported FireWire (IEEE 1394) Adapters ***
      <*>   FireDTV and FloppyDTV
      [*]   Enable debug for the B2C2 FlexCop drivers

Note: Radio and remote controller only drivers weren't organized by bus at
      the main menu. I don't think it is currently worthy do do it there.

3) Sub-devices (i2c, tuners, frontends, sensors):

      [*]   Autoselect analog and hybrid tuner modules to build
            *** Media ancillary drivers (tuners, sensors, i2c, frontends) ***
            Sensors used on soc_camera driver  --->
      [*]   Load and attach frontend and tuner driver modules as needed

By unselecting the first item, it will open menus to customise tuners, frontends,
sensors and other i2c drivers.

In the case of soc_camera, as soc_camera drivers won't auto-select sensors,
the menu will be there, if soc_camera driver is selected, even if auto-select
is enabled.

Comments?


Mauro Carvalho Chehab (6):
  [media] move soc_camera to its own directory
  [media] Kconfig reorganization
  [media] Put the test devices together
  [media] Cleanup media Kconfig files
  [media] Kconfig: use menuconfig instead of menu
  [media] Kconfig: merge all customise options into just one

 drivers/media/Kconfig                              |  53 +++---
 drivers/media/common/b2c2/Kconfig                  |  28 +--
 drivers/media/dvb-frontends/Kconfig                | 195 ++++++++++-----------
 drivers/media/i2c/Kconfig                          |  23 +--
 drivers/media/parport/Kconfig                      |   8 +-
 drivers/media/pci/Kconfig                          |  11 +-
 drivers/media/pci/bt8xx/Kconfig                    |  24 +--
 drivers/media/pci/cx18/Kconfig                     |  10 +-
 drivers/media/pci/cx23885/Kconfig                  |  34 ++--
 drivers/media/pci/cx88/Kconfig                     |  36 ++--
 drivers/media/pci/ddbridge/Kconfig                 |  10 +-
 drivers/media/pci/dm1105/Kconfig                   |  14 +-
 drivers/media/pci/mantis/Kconfig                   |  20 +--
 drivers/media/pci/ngene/Kconfig                    |  14 +-
 drivers/media/pci/saa7134/Kconfig                  |  40 ++---
 drivers/media/pci/saa7146/Kconfig                  |   8 +-
 drivers/media/pci/saa7164/Kconfig                  |   6 +-
 drivers/media/pci/sta2x11/Kconfig                  |   2 +-
 drivers/media/pci/ttpci/Kconfig                    |  84 ++++-----
 drivers/media/pci/zoran/Kconfig                    |  26 +--
 drivers/media/platform/Kconfig                     | 156 ++++-------------
 drivers/media/platform/Makefile                    |  30 +---
 drivers/media/platform/davinci/Kconfig             |   4 +-
 .../media/platform/{ => soc_camera}/atmel-isi.c    |   0
 .../media/platform/{ => soc_camera}/mx1_camera.c   |   0
 .../media/platform/{ => soc_camera}/mx2_camera.c   |   0
 .../media/platform/{ => soc_camera}/mx3_camera.c   |   0
 .../media/platform/{ => soc_camera}/omap1_camera.c |   0
 .../platform/{ => soc_camera}/omap24xxcam-dma.c    |   0
 .../media/platform/{ => soc_camera}/omap24xxcam.c  |   0
 .../media/platform/{ => soc_camera}/omap24xxcam.h  |   0
 .../media/platform/{ => soc_camera}/pxa_camera.c   |   0
 .../{ => soc_camera}/sh_mobile_ceu_camera.c        |   0
 .../platform/{ => soc_camera}/sh_mobile_csi2.c     |   0
 .../media/platform/{ => soc_camera}/soc_camera.c   |   0
 .../{ => soc_camera}/soc_camera_platform.c         |   0
 .../media/platform/{ => soc_camera}/soc_mediabus.c |   0
 drivers/media/tuners/Kconfig                       |  88 ++++------
 drivers/media/usb/Kconfig                          |  12 +-
 drivers/media/usb/au0828/Kconfig                   |  10 +-
 drivers/media/usb/cx231xx/Kconfig                  |   6 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |  88 +++++-----
 drivers/media/usb/dvb-usb/Kconfig                  | 148 ++++++++--------
 drivers/media/usb/em28xx/Kconfig                   |  28 +--
 drivers/media/usb/pvrusb2/Kconfig                  |  14 +-
 drivers/media/usb/ttusb-budget/Kconfig             |  14 +-
 drivers/media/usb/usbvision/Kconfig                |   2 +-
 drivers/media/v4l2-core/Kconfig                    |  27 +--
 drivers/media/v4l2-core/Makefile                   |   2 +-
 49 files changed, 570 insertions(+), 705 deletions(-)
 rename drivers/media/platform/{ => soc_camera}/atmel-isi.c (100%)
 rename drivers/media/platform/{ => soc_camera}/mx1_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/mx2_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/mx3_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/omap1_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/omap24xxcam-dma.c (100%)
 rename drivers/media/platform/{ => soc_camera}/omap24xxcam.c (100%)
 rename drivers/media/platform/{ => soc_camera}/omap24xxcam.h (100%)
 rename drivers/media/platform/{ => soc_camera}/pxa_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/sh_mobile_ceu_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/sh_mobile_csi2.c (100%)
 rename drivers/media/platform/{ => soc_camera}/soc_camera.c (100%)
 rename drivers/media/platform/{ => soc_camera}/soc_camera_platform.c (100%)
 rename drivers/media/platform/{ => soc_camera}/soc_mediabus.c (100%)

-- 
1.7.11.4

