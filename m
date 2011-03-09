Return-path: <mchehab@pedra>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:52110 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224Ab1CIMTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 07:19:20 -0500
From: <johan.xx.mossberg@stericsson.com>
To: <johan.xx.mossberg@stericsson.com>, <linux-mm@kvack.org>,
	<linaro-dev@lists.linaro.org>, <linux-media@vger.kernel.org>
Cc: <gstreamer-devel@lists.freedesktop.org>, <m.nazarewicz@samsung.com>
Subject: [PATCHv2 0/3] hwmem: Hardware memory driver
Date: Wed, 9 Mar 2011 13:18:50 +0100
Message-ID: <1299673133-26464-1-git-send-email-johan.xx.mossberg@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everyone, 

The following patchset implements a "hardware memory driver". The
main purpose of hwmem is:

* To allocate buffers suitable for use with hardware. Currently
this means contiguous buffers.
* To synchronize the caches for the allocated buffers. This is
achieved by keeping track of when the CPU uses a buffer and when
other hardware uses the buffer, when we switch from CPU to other
hardware or vice versa the caches are synchronized.
* To handle sharing of allocated buffers between processes i.e.
import, export.

Hwmem is available both through a user space API and through a
kernel API.

Here at ST-Ericsson we use hwmem for graphics buffers. Graphics
buffers need to be contiguous due to our hardware, are passed
between processes (usually application and window manager)and are
part of usecases where performance is top priority so we can't
afford to synchronize the caches unecessarily.

Additions in v2:
* Bugfixes
* Added the possibility to map hwmem buffers in the kernel through
hwmem_kmap/kunmap
* Moved mach specific stuff to mach.

Best regards
Johan Mossberg
Consultant at ST-Ericsson

Johan Mossberg (3):
  hwmem: Add hwmem (part 1)
  hwmem: Add hwmem (part 2)
  hwmem: Add hwmem to ux500

 arch/arm/mach-ux500/Makefile               |    2 +-
 arch/arm/mach-ux500/board-mop500.c         |    1 +
 arch/arm/mach-ux500/dcache.c               |  266 +++++++++
 arch/arm/mach-ux500/devices.c              |   31 ++
 arch/arm/mach-ux500/include/mach/dcache.h  |   26 +
 arch/arm/mach-ux500/include/mach/devices.h |    1 +
 drivers/misc/Kconfig                       |    1 +
 drivers/misc/Makefile                      |    1 +
 drivers/misc/hwmem/Kconfig                 |    7 +
 drivers/misc/hwmem/Makefile                |    3 +
 drivers/misc/hwmem/cache_handler.c         |  510 ++++++++++++++++++
 drivers/misc/hwmem/cache_handler.h         |   61 +++
 drivers/misc/hwmem/hwmem-ioctl.c           |  455 ++++++++++++++++
 drivers/misc/hwmem/hwmem-main.c            |  799 ++++++++++++++++++++++++++++
 include/linux/hwmem.h                      |  536 +++++++++++++++++++
 15 files changed, 2699 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-ux500/dcache.c
 create mode 100644 arch/arm/mach-ux500/include/mach/dcache.h
 create mode 100644 drivers/misc/hwmem/Kconfig
 create mode 100644 drivers/misc/hwmem/Makefile
 create mode 100644 drivers/misc/hwmem/cache_handler.c
 create mode 100644 drivers/misc/hwmem/cache_handler.h
 create mode 100644 drivers/misc/hwmem/hwmem-ioctl.c
 create mode 100644 drivers/misc/hwmem/hwmem-main.c
 create mode 100644 include/linux/hwmem.h

-- 
1.7.4.1

