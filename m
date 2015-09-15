Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36214 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbbIOJdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 05:33:22 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH v3 0/2] [media] Fix race between graph enumeration and entities registration
Date: Tue, 15 Sep 2015 11:33:00 +0200
Message-Id: <1442309582-18168-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The Media Controller framework has an issue in which the media device node
is registered before all the media entities and pads links are created so
if user-space tries to enumerate the graph too early, it may get a partial
graph since not everything has been registered yet.

This series fixes the issue by separate the media device registration from
the initialization so drives can first initialize the media device, create
the graph and then finally register the media device node once is finished.
The solution was suggested by Sakari Ailus.

This is the third version of the series that fixes issues pointed out by
Sakari Ailus. The first version was [0] and the second version was [1].

Patch #1 adds a check to the media_device_unregister() function to know if
the media device has been registed yet so calling it will be safe and the
cleanup functions of the drivers won't need to be changed in case register
failed.

Patch #2 does the init and registration split, changing all the drivers to
make the change atomic and also adds a cleanup function for media devices.

The patches are on top of Mauro's "[PATCH v8 00/55] MC next generation" [2]
but is not a dependency for that series, it was only be based on that patch
series to avoid conflicts with in-flight patches.

The patches have been tested on an OMAP3 IGEPv2 board that has a OMAP3 ISP
device and an Exynos5800 Chromebook with a built-in UVC camera.

[0]: https://lkml.org/lkml/2015/9/10/311
[1]: https://lkml.org/lkml/2015/9/14/276
[2]: http://permalink.gmane.org/gmane.linux.drivers.driver-project.devel/74515

Best regards,
Javier

Changes in v3:
- Replace the WARN_ON() in media_device_init() for a BUG_ON().
  Suggested by Sakari Ailus.

Changes in v2:
- Reword the documentation for media_device_unregister(). Suggested by Sakari.
- Added Sakari's Acked-by tag for patch #1.
- Change media_device_init() to return void instead of an error.
  Suggested by Sakari Ailus.
- Remove the error messages when media_device_register() fails.
  Suggested by Sakari Ailus.
- Fix typos in commit message of patch #2. Suggested by Sakari Ailus.

Javier Martinez Canillas (2):
  [media] media-device: check before unregister if mdev was registered
  [media] media-device: split media initialization and registration

 drivers/media/common/siano/smsdvb-main.c      |  1 +
 drivers/media/media-device.c                  | 42 +++++++++++++++++++++++----
 drivers/media/platform/exynos4-is/media-dev.c | 15 +++++-----
 drivers/media/platform/omap3isp/isp.c         | 14 ++++-----
 drivers/media/platform/s3c-camif/camif-core.c | 15 ++++++----
 drivers/media/platform/vsp1/vsp1_drv.c        | 12 ++++----
 drivers/media/platform/xilinx/xilinx-vipp.c   | 12 +++-----
 drivers/media/usb/au0828/au0828-core.c        | 27 +++++++++--------
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 30 +++++++++----------
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 23 ++++++++-------
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 24 ++++++++-------
 drivers/media/usb/siano/smsusb.c              |  5 ++--
 drivers/media/usb/uvc/uvc_driver.c            | 10 +++++--
 include/media/media-device.h                  |  2 ++
 14 files changed, 137 insertions(+), 95 deletions(-)

-- 
2.4.3

