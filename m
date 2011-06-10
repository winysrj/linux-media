Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58899 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab1FJShG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 10 Jun 2011 20:36:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/19] S5P FIMC driver conversion to control framework and Media
 Controller API
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

The following change set is a S5P/EXYNOS4 FIMC (camera host interface
and video post-processor) driver conversion to the control framework
and Media Controller API. The first and last patch add Runtime PM support
in the mem-to-mem and capture driver respectively.

The s5p-fimc driver supports S5PC110, S5PV210 and EXYNOS4210 (S5PV310) SoCs. 
As far as camera support is concerned the most recent Exynos4210 SoC has
2 parallel and 2 MIPI-CSI2 inputs, 2 MIPI-CSI2 receivers and 4 FIMC subsystems.
FIMC instances can be attached to any parallel input or the MIPI-CSI receiver
output. The MIPI-CSI receivers have fixed connections to the MIPI CSI physical
interfaces (MIPI-CSIS PHY). Using media controller API allows to easily
discover the H/W structure and choose optimal configuration in particular
use case.

The media device introduced with patch: "s5p-fimc: Add the media device
driver" acts as a top level entity to which sensor, the mipi-csi receiver
and FIMC subdevs are registered. It also assures proper use of 2 SoC output
clocks for external sensors, which are shared among all FIMC entities.

Patch "s5p-fimc: Add a subdev for the FIMC processing block" adds a v4l2
sub-device for each FIMC camera capture processing unit. 

Video pipeline configuration procedure for subdevs has not yet been fully
discussed and settled. Nevertheless I have adopted following configuration
flow for the FIMC.{n} (capture) subdevs:

1) set format at sink pad (this will reset sink crop rectangle)
2) set crop rectangle at sink pad (optional)
3) set rotate control
4) set crop (composition) at source pad (optional). Here scaling constraints
   are checked according to whether sink pad crop has been set or not and
   whether 90/270 deg rotation is set.

Rotation can also be changed while streaming, in this case when 90/270 deg
rotation is attempted to be set and scaling bounds are exceeded 
(max. 64x downscaling) s_ctrl returns EINVAL.

The following pipeline configurations are possible:

1) sensor subdev -> FIMC.? subdev -> video node (/dev/video*)
2) sensor subdev -> s5p-mipi-csis.? subdev -> FIMC.? subdev -> 
    video node (/dev/video*)
3) sensor1 subdev -> s5p-mipi-csis.? -+-> FIMC.{n} subdev ...
                                      |
                                      +-> FIMC.{n+1} subdev ..
4) LCD capture subdev -> FIMC.? -> video node (dev/video)
			
4) is not yet implemented.
								
I have tested this driver with media-ctl tool (thanks go to Laurent Pinchart
for sharing it) which can be found at: http://git.ideasonboard.org/?p=media-ctl.git

This patch set depends on my previous s5p-fimc bugfixes, available at: 
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/s5p-fimc

as well as the control framework updates from Hans Verkuil:
http://www.spinics.net/lists/linux-media/msg33552.html
(patch 1...6, 8, 11).

The corresponding platform support patches illustrating the media device
and mipi-csis platform data setup are being prepared and will follow shortly.

There are a few open issues that are not really fully resolved yet:

- V4L2 device node only and media controller API coexistence;
 For now the driver is checking if image sensor subdev exposes a device
 node to user space, if it doesn't then formats are configured by the 
 V4L2 node driver in VIDIOC_S_FMT ioctl. If sensor exposes a video node
 then only the output DMA is configured in S_FMT.
 It seems more reasonable to permanently enable sensor and mipi-csi subdevs
 and choose proper actions in the host driver at runtime on some different
 precondition basis.
- Accessing controls' value in interrupt context; it would be useful to use 
 struct v4l2_ctrl::val directly in the driver rather than caching it
 additonally.

Any comments and suggestions on this initial version are appreciated.


 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c | 1280 +++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.c    |  917 ++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.h    |  192 +++--
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  738 +++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  126 +++
 drivers/media/video/s5p-fimc/fimc-reg.c     |   76 +-
 drivers/media/video/s5p-fimc/regs-fimc.h    |    8 +-
 include/media/s5p_fimc.h                    |   11 +
 10 files changed, 2416 insertions(+), 936 deletions(-)

--
Thanks,

Sylwester Nawrocki
Samsung Poland R&D Center

