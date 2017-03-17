Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56507 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbdCQSuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 14:50:25 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-mtd@lists.infradead.org,
        linux-media@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>
Date: Fri, 17 Mar 2017 12:48:07 -0600
Message-Id: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 00/16] Cleanup chardev instances with helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

This version of the series fixes the issue found by the kbuild test
robot with the rtc driver. I managed to reproduce the issue and this
series fixes the problem.

Logan


Changes since v4:

* Fix a kbuild robot issue with the rtc driver: the rtc driver sometimes
  does not want to add the cdev. In order to accommodate this, the new
  cdev_device helper functions check dev->devt and if it's zero they
  don't add or delete the cdev.

* Remove prototypes for functions that were removed in the rtc driver

Changes since v3:

* Added a missing "device.h" include which caused warnings with some
  build configurations

Changes since v2:

* Expanded comments as per Jason's suggestions
* Collected tags
* Updated the switchtec patch seeing it's underlying patch set changed

Changes since v1:

* Expanded the idea to take care of adding the cdev and the device

Logan


Dan Williams (1):
  device-dax: fix cdev leak

Jason Gunthorpe (1):
  IB/ucm: utilize new cdev_device_add helper function

Logan Gunthorpe (14):
  chardev: add helper function to register char devs with a struct
    device
  device-dax: utilize new cdev_device_add helper function
  input: utilize new cdev_device_add helper function
  gpiolib: utilize new cdev_device_add helper function
  tpm-chip: utilize new cdev_device_add helper function
  platform/chrome: cros_ec_dev - utilize new cdev_device_add helper
    function
  infiniband: utilize the new cdev_set_parent function
  iio:core: utilize new cdev_device_add helper function
  media: utilize new cdev_device_add helper function
  mtd: utilize new cdev_device_add helper function
  rapidio: utilize new cdev_device_add helper function
  rtc: utilize new cdev_device_add helper function
  scsi: utilize new cdev_device_add helper function
  switchtec: utilize new device_add_cdev helper function

 drivers/char/tpm/tpm-chip.c              | 19 ++-----
 drivers/dax/dax.c                        | 33 ++++++------
 drivers/gpio/gpiolib.c                   | 23 +++-----
 drivers/iio/industrialio-core.c          | 15 ++----
 drivers/infiniband/core/ucm.c            | 35 ++++++------
 drivers/infiniband/core/user_mad.c       |  4 +-
 drivers/infiniband/core/uverbs_main.c    |  2 +-
 drivers/infiniband/hw/hfi1/device.c      |  2 +-
 drivers/input/evdev.c                    | 11 +---
 drivers/input/joydev.c                   | 11 +---
 drivers/input/mousedev.c                 | 11 +---
 drivers/media/cec/cec-core.c             | 16 ++----
 drivers/media/media-devnode.c            | 20 ++-----
 drivers/mtd/ubi/build.c                  | 91 ++++++--------------------------
 drivers/mtd/ubi/vmt.c                    | 49 ++++++-----------
 drivers/pci/switch/switchtec.c           | 11 +---
 drivers/platform/chrome/cros_ec_dev.c    | 31 +++--------
 drivers/rapidio/devices/rio_mport_cdev.c | 24 +++------
 drivers/rtc/class.c                      | 14 +++--
 drivers/rtc/rtc-core.h                   | 10 ----
 drivers/rtc/rtc-dev.c                    | 17 ------
 drivers/scsi/osd/osd_uld.c               | 56 +++++++-------------
 fs/char_dev.c                            | 86 ++++++++++++++++++++++++++++++
 include/linux/cdev.h                     |  5 ++
 24 files changed, 239 insertions(+), 357 deletions(-)

--
2.1.4
