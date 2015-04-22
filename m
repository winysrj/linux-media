Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:52102 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbbDVXDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 19:03:23 -0400
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	"Srinivas Kandagatla" <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	"Jean Delvare" <jdelvare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>,
	Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Subject: [PATCHv3 0/4] add devm_of_phy_get_by_index and update platform drivers
Date: Wed, 22 Apr 2015 16:04:09 -0700
Message-ID: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set adds a new API to get phy by index when multiple 
phys are present. This patch is based on discussion with Arnd Bergmann
about dt bindings for multiple phys.

History:
v1:
    - Removed null pointers on Dmitry's suggestion
    - Improved documentation in commit messages
    - Exported new phy api
v2:
    - EHCI and OHCI platform Kconfigs select Generic Phy
      to fix build errors in certain configs.
v3:
    - Made GENERIC_PHY an invisible option so 
    that other configs can select it
    - Added stubs for devm_of_phy_get_by_index
    - Reformated code

Arun Ramamurthy (4):
  phy: phy-core: Make GENERIC_PHY an invisible option
  phy: core: Add devm_of_phy_get_by_index to phy-core
  usb: ehci-platform: Use devm_of_phy_get_by_index
  usb: ohci-platform: Use devm_of_phy_get_by_index

 Documentation/phy.txt                     |  7 +++-
 drivers/ata/Kconfig                       |  1 -
 drivers/media/platform/exynos4-is/Kconfig |  2 +-
 drivers/phy/Kconfig                       |  4 +-
 drivers/phy/phy-core.c                    | 32 ++++++++++++++
 drivers/usb/host/Kconfig                  |  4 +-
 drivers/usb/host/ehci-platform.c          | 69 +++++++++++--------------------
 drivers/usb/host/ohci-platform.c          | 69 +++++++++++--------------------
 drivers/video/fbdev/exynos/Kconfig        |  2 +-
 include/linux/phy/phy.h                   |  8 ++++
 10 files changed, 100 insertions(+), 98 deletions(-)

-- 
2.3.4

