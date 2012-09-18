Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59853 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2IRIqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 04:46:22 -0400
Subject: [GIT PULL v2] Initial i.MX5/CODA7 support for the CODA driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>,
	Ezequiel =?ISO-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>,
	Richard Zhao <richard.zhao@freescale.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 10:46:18 +0200
Message-ID: <1347957978.2529.4.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

please pull the following patches that fix a few issues in the coda
driver and add initial firmware loading and encoding support for the
CODA7 series VPU contained in i.MX51 and i.MX53 SoCs.
I have dropped Ezequiel's vb2_queue_init commit and rebased onto current
linux-media staging/for_v3.7.


The following changes since commit 36aee5ff9098a871bda38dbbdad40ad59f6535cf:

  [media] ir-rx51: Adjust dependencies (2012-09-15 19:44:30 -0300)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git coda/for_v3.7

for you to fetch changes up to 64a01774162824f4a39d67ee2a4913d5ea2c651e:

  media: coda: set up buffers to be sized as negotiated with s_fmt (2012-09-18 10:34:45 +0200)

----------------------------------------------------------------
Philipp Zabel (13):
      media: coda: firmware loading for 64-bit AXI bus width
      media: coda: add i.MX53 / CODA7541 platform support
      media: coda: fix IRAM/AXI handling for i.MX53
      media: coda: allocate internal framebuffers separately from v4l2 buffers
      media: coda: ignore coda busy status in coda_job_ready
      media: coda: keep track of active instances
      media: coda: stop all queues in case of lockup
      media: coda: enable user pointer support
      media: coda: wait for picture run completion in start/stop_streaming
      media: coda: fix sizeimage setting in try_fmt
      media: coda: add horizontal / vertical flipping support
      media: coda: add byte size slice limit control
      media: coda: set up buffers to be sized as negotiated with s_fmt

Sylwester Nawrocki (1):
      coda: Add V4L2_CAP_VIDEO_M2M capability flag

 drivers/media/platform/Kconfig |    3 +-
 drivers/media/platform/coda.c  |  431 +++++++++++++++++++++++++++++-----------
 drivers/media/platform/coda.h  |   30 ++-
 3 files changed, 344 insertions(+), 120 deletions(-)


