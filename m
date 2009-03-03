Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58532 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZCCUo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 15:44:26 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Tue, 3 Mar 2009 14:44:12 -0600
Subject: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Message-ID: <A24693684029E5489D1D202277BE89442E1D921F@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series depends on the following patches:

 - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
 - "OMAP3 ISP and camera drivers" patch series, posted by Sakari Ailus on
   March 3rd. (Please follow his instructions to pull from gitorious.org server)

This has been tested with:
 - SDP3430-VG5.0.1 with OMAP3430-ES3.1 daughter board upgrade.
 - Camkit V3.0.1 with MT9P012 and OV3640 sensors
 - LDP with OV3640 sensor

Sergio Aguirre (5):
  MT9P012: Add driver
  DW9710: Add driver
  OV3640: Add driver
  OMAP3430SDP: Add support for Camera Kit v3
  LDP: Add support for built-in camera

 arch/arm/mach-omap2/Makefile                    |    6 +-
 arch/arm/mach-omap2/board-3430sdp-camera.c      |  490 +++++
 arch/arm/mach-omap2/board-3430sdp.c             |   42 +-
 arch/arm/mach-omap2/board-ldp-camera.c          |  203 +++
 arch/arm/mach-omap2/board-ldp.c                 |   17 +
 arch/arm/plat-omap/include/mach/board-3430sdp.h |    1 +
 arch/arm/plat-omap/include/mach/board-ldp.h     |    1 +
 drivers/media/video/Kconfig                     |   31 +
 drivers/media/video/Makefile                    |    3 +
 drivers/media/video/dw9710.c                    |  548 ++++++
 drivers/media/video/dw9710_priv.h               |   57 +
 drivers/media/video/mt9p012.c                   | 1890 +++++++++++++++++++
 drivers/media/video/mt9p012_regs.h              |   74 +
 drivers/media/video/ov3640.c                    | 2202 +++++++++++++++++++++++
 drivers/media/video/ov3640_regs.h               |  600 ++++++
 include/media/dw9710.h                          |   35 +
 include/media/mt9p012.h                         |   37 +
 include/media/ov3640.h                          |   31 +
 18 files changed, 6265 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-3430sdp-camera.c
 create mode 100644 arch/arm/mach-omap2/board-ldp-camera.c
 create mode 100644 drivers/media/video/dw9710.c
 create mode 100644 drivers/media/video/dw9710_priv.h
 create mode 100644 drivers/media/video/mt9p012.c
 create mode 100644 drivers/media/video/mt9p012_regs.h
 create mode 100644 drivers/media/video/ov3640.c
 create mode 100644 drivers/media/video/ov3640_regs.h
 create mode 100644 include/media/dw9710.h
 create mode 100644 include/media/mt9p012.h
 create mode 100644 include/media/ov3640.h

