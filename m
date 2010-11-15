Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:54876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab0KOOaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:02 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 0/9] YUV support for CCDC + cleanups
Date: Mon, 15 Nov 2010 08:29:52 -0600
Message-Id: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

First of all, these patches are based on Laurent's tree:

URL: git://linuxtv.org/pinchartl/media.git
Branch: media-0004-omap3isp (Commit d0c5b0e4: OMAP3 ISP driver)

I had these patches in my queue for some time, which:

- Add YUV support to CCDC
- Cleans up platform device MEM resources
- Removes some unused/legacy defines
- IMPORTANT: Moves/Renames isp_user.h to include/linux/omap3isp.h

I'm working on some more changes to keep register access per component
a bit cleaner. But that will be sent separately in another RFC patchlist.

Please share your review comments.

Changelog:
v2 - Squashed patches 1 & 2 of previous set
     ("omap3isp: ccdc: Add support for YUV format" and
      "omap3isp: ccdc: Write SYN_MODE.INPMOD based on fmt" respectively)

v1 - Initial version
     (found here: http://www.spinics.net/lists/linux-media/msg25016.html)

Regards,
Sergio

Sergio Aguirre (9):
  omap3isp: ccdc: Add support for YUV format
  omap3: Fix camera resources for multiomap
  omap3isp: Export isp_user.h to userspace as omap3isp.h
  omap3: Remove unusued CBUFF resource
  omap3isp: Remove unused CBUFF register access
  omap3isp: Remove CSIA/B register abstraction
  omap3isp: Cleanup isp_power_settings
  omap3isp: ccp2: Make SYSCONFIG fields consistent
  omap3isp: Remove legacy MMU access regs/fields

 arch/arm/mach-omap2/devices.c              |   32 +-
 arch/arm/plat-omap/include/mach/isp_user.h |  636 ----------------------------
 drivers/media/video/isp/isp.c              |   51 +--
 drivers/media/video/isp/isp.h              |    1 -
 drivers/media/video/isp/ispccdc.c          |   14 +-
 drivers/media/video/isp/ispccdc.h          |    2 +-
 drivers/media/video/isp/ispccp2.c          |    5 +-
 drivers/media/video/isp/isph3a.h           |    2 +-
 drivers/media/video/isp/isphist.h          |    2 +-
 drivers/media/video/isp/isppreview.h       |    2 +-
 drivers/media/video/isp/ispreg.h           |   85 +----
 drivers/media/video/isp/ispstat.h          |    2 +-
 include/linux/Kbuild                       |    1 +
 include/linux/omap3isp.h                   |  636 ++++++++++++++++++++++++++++
 14 files changed, 682 insertions(+), 789 deletions(-)
 delete mode 100644 arch/arm/plat-omap/include/mach/isp_user.h
 create mode 100644 include/linux/omap3isp.h

