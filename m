Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:41866 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751305AbdLSSPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 13:15:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org
Cc: linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: [-next PATCH 0/4] sysfs and DEVICE_ATTR_<foo>
Date: Tue, 19 Dec 2017 10:15:05 -0800
Message-Id: <cover.1513706701.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Joe Perches (4):
  sysfs.h: Use octal permissions
  treewide: Use DEVICE_ATTR_RW
  treewide: Use DEVICE_ATTR_RO
  treewide: Use DEVICE_ATTR_WO

 arch/arm/mach-pxa/sharpsl_pm.c                     |  4 +-
 arch/s390/kernel/smp.c                             |  2 +-
 arch/s390/kernel/topology.c                        |  3 +-
 arch/sh/drivers/push-switch.c                      |  2 +-
 arch/tile/kernel/sysfs.c                           | 12 ++--
 arch/x86/kernel/cpu/microcode/core.c               |  2 +-
 drivers/acpi/device_sysfs.c                        |  6 +-
 drivers/char/ipmi/ipmi_msghandler.c                | 17 +++---
 drivers/gpu/drm/i915/i915_sysfs.c                  | 12 ++--
 drivers/input/touchscreen/elants_i2c.c             |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  2 +-
 drivers/net/wimax/i2400m/sysfs.c                   |  3 +-
 drivers/nvme/host/core.c                           | 10 ++--
 drivers/platform/x86/compal-laptop.c               | 18 ++----
 drivers/s390/cio/css.c                             |  8 +--
 drivers/s390/cio/device.c                          | 10 ++--
 drivers/s390/crypto/ap_card.c                      |  2 +-
 drivers/scsi/hpsa.c                                | 10 ++--
 drivers/scsi/lpfc/lpfc_attr.c                      | 64 ++++++++--------------
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |  8 +--
 drivers/thermal/thermal_sysfs.c                    | 17 +++---
 drivers/tty/serial/sh-sci.c                        |  2 +-
 drivers/usb/host/xhci-dbgcap.c                     |  2 +-
 drivers/usb/phy/phy-tahvo.c                        |  2 +-
 drivers/video/fbdev/auo_k190x.c                    |  4 +-
 drivers/video/fbdev/w100fb.c                       |  4 +-
 include/linux/sysfs.h                              | 14 ++---
 lib/test_firmware.c                                | 14 ++---
 lib/test_kmod.c                                    | 14 ++---
 sound/soc/omap/mcbsp.c                             |  4 +-
 sound/soc/soc-core.c                               |  2 +-
 sound/soc/soc-dapm.c                               |  2 +-
 32 files changed, 120 insertions(+), 158 deletions(-)

-- 
2.15.0
