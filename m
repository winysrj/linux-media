Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53957 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab3LMPPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:15:00 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	<devicetree@vger.kernel.org>
Subject: [PATCH 00/11] media: rc: ImgTec IR decoder driver
Date: Fri, 13 Dec 2013 15:12:48 +0000
Message-ID: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver for the ImgTec Infrared decoder block. Two separate rc input
devices are exposed depending on kernel configuration. One uses the
hardware decoder which is set up with timings for a specific protocol
and supports mask/value filtering and wake events. The other uses raw
edge interrupts and the generic software protocol decoders to allow
multiple protocols to be supported, including those not supported by the
hardware decoder.

The hardware decoder timing values, raw data to scan code conversion
function and scan code filter to raw data filter conversion function are
provided as separate modules for each protocol which the main driver can
use. The scan code filter value and mask (and the same again for wake
from sleep) are specified via sysfs files in /sys/class/rc/rcX/.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org

James Hogan (11):
  dt: binding: add binding for ImgTec IR block
  media: rc: img-ir: add base driver
  media: rc: img-ir: add raw driver
  media: rc: img-ir: add hardware decoder driver
  media: rc: img-ir: add to build
  media: rc: img-ir: add NEC decoder module
  media: rc: img-ir: add JVC decoder module
  media: rc: img-ir: add Sony decoder module
  media: rc: add Sharp infrared protocol
  media: rc: img-ir: add Sharp decoder module
  media: rc: img-ir: add Sanyo decoder module

 Documentation/devicetree/bindings/media/img-ir.txt |   20 +
 drivers/media/rc/Kconfig                           |    2 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/img-ir/Kconfig                    |   61 +
 drivers/media/rc/img-ir/Makefile                   |   11 +
 drivers/media/rc/img-ir/img-ir-core.c              |  172 +++
 drivers/media/rc/img-ir/img-ir-hw.c                | 1277 ++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-hw.h                |  284 +++++
 drivers/media/rc/img-ir/img-ir-jvc.c               |  109 ++
 drivers/media/rc/img-ir/img-ir-nec.c               |  149 +++
 drivers/media/rc/img-ir/img-ir-raw.c               |  107 ++
 drivers/media/rc/img-ir/img-ir-raw.h               |   58 +
 drivers/media/rc/img-ir/img-ir-sanyo.c             |  139 +++
 drivers/media/rc/img-ir/img-ir-sharp.c             |  115 ++
 drivers/media/rc/img-ir/img-ir-sony.c              |  163 +++
 drivers/media/rc/img-ir/img-ir.h                   |  170 +++
 drivers/media/rc/rc-main.c                         |    1 +
 include/media/rc-map.h                             |    4 +-
 18 files changed, 2842 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/img-ir.txt
 create mode 100644 drivers/media/rc/img-ir/Kconfig
 create mode 100644 drivers/media/rc/img-ir/Makefile
 create mode 100644 drivers/media/rc/img-ir/img-ir-core.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-jvc.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-nec.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-sanyo.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sony.c
 create mode 100644 drivers/media/rc/img-ir/img-ir.h

-- 
1.8.1.2


