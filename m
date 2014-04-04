Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:12024 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaDDTp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 15:45:29 -0400
Date: Fri, 04 Apr 2014 16:45:22 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.15-rc1] exynos patches
Message-id: <20140404164522.21c2f58a@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

That's the remaining patches I have for the merge windows. It basically
adds a new sensor and adds the needed DT bits for it to work.

-

PS.: This patch also have some conflicts with the code that got moved
to drivers/of, but this conflict is just function rename:

- 	node = v4l2_of_get_next_endpoint(node, NULL);
+	node = of_graph_get_next_endpoint(node, NULL);

- 	node = v4l2_of_get_remote_port(node);
+	node = of_graph_get_remote_port(node);

-

The following changes since commit ba35ca07080268af1badeb47de0f9eff28126339:

  [media] em28xx-audio: make sure audio is unmuted on open() (2014-03-14 10:17:18 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/exynos

for you to fetch changes up to 97e9858ed5525af5355769cd98b25b5ec94c0c85:

  [media] s5p-fimc: Remove reference to outdated macro (2014-03-14 10:37:43 -0300)

----------------------------------------------------------------
Jacek Anaszewski (1):
      [media] s5p-jpeg: Fix broken indentation in jpeg-regs.h

Paul Bolle (1):
      [media] s5p-fimc: Remove reference to outdated macro

Sylwester Nawrocki (9):
      [media] Documentation: dt: Add binding documentation for S5K6A3 image sensor
      [media] Documentation: dt: Add binding documentation for S5C73M3 camera
      [media] Documentation: devicetree: Update Samsung FIMC DT binding
      [media] V4L: Add driver for s5k6a3 image sensor
      [media] V4L: s5c73m3: Add device tree support
      [media] exynos4-is: Use external s5k6a3 sensor driver
      [media] exynos4-is: Add clock provider for the SCLK_CAM clock outputs
      [media] exynos4-is: Add support for asynchronous subdevices registration
      [media] exynos4-is: Add the FIMC-IS ISP capture DMA driver

 .../devicetree/bindings/media/samsung-fimc.txt     |  44 +-
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |  97 +++
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |  33 ++
 Documentation/video4linux/fimc.txt                 |   5 +-
 drivers/media/i2c/Kconfig                          |   8 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 207 +++++--
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |   6 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |   4 +
 drivers/media/i2c/s5k6a3.c                         | 389 ++++++++++++
 drivers/media/platform/exynos4-is/Kconfig          |   9 +
 drivers/media/platform/exynos4-is/Makefile         |   4 +
 drivers/media/platform/exynos4-is/fimc-is-param.c  |   2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.h  |   5 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  16 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |   1 +
 drivers/media/platform/exynos4-is/fimc-is-sensor.c | 285 +--------
 drivers/media/platform/exynos4-is/fimc-is-sensor.h |  49 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |  98 ++-
 drivers/media/platform/exynos4-is/fimc-is.h        |   9 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 660 +++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp-video.h |  44 ++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  29 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |  27 +-
 drivers/media/platform/exynos4-is/media-dev.c      | 363 +++++++++---
 drivers/media/platform/exynos4-is/media-dev.h      |  32 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  24 +-
 27 files changed, 1886 insertions(+), 565 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
 create mode 100644 drivers/media/i2c/s5k6a3.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h


This is the diff for the trivial merge conflict solve.

diff --cc drivers/media/platform/exynos4-is/fimc-is.c
index 9bdfa4599bc3,c289d5a69d09..000000000000
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@@ -167,11 -168,19 +168,18 @@@ static int fimc_is_parse_sensor_config(
  	u32 tmp = 0;
  	int ret;
  
+ 	sensor->drvdata = fimc_is_sensor_get_drvdata(node);
+ 	if (!sensor->drvdata) {
+ 		dev_err(&is->pdev->dev, "no driver data found for: %s\n",
+ 							 node->full_name);
+ 		return -EINVAL;
+ 	}
+ 
 -	node = v4l2_of_get_next_endpoint(node, NULL);
 -	if (!node)
 +	np = of_graph_get_next_endpoint(np, NULL);
 +	if (!np)
  		return -ENXIO;
 -
 -	node = v4l2_of_get_remote_port(node);
 -	if (!node)
 +	np = of_graph_get_remote_port(np);
 +	if (!np)
  		return -ENXIO;
  
  	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */


-- 

Regards,
Mauro
