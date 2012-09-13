Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab2IMQkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 12:40:39 -0400
Subject: [GIT PULL] Initial i.MX5/CODA7 support for the CODA driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>,
	Ezequiel =?ISO-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>,
	Richard Zhao <richard.zhao@freescale.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 18:40:36 +0200
Message-ID: <1347554436.2429.609.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

please pull the following patches that fix a few issues in the coda driver and
add initial firmware loading and encoding support for the CODA7 series VPU
contained in i.MX51 and i.MX53 SoCs.


The following changes since commit 79e8c7bebb467bbc3f2514d75bba669a3f354324:

  Merge tag 'v3.6-rc3' into staging/for_v3.7 (2012-08-24 11:25:10 -0300)

are available in the git repository at:


  http://git.pengutronix.de/git/pza/linux.git coda/for_v3.7

for you to fetch changes up to b50252c494ad56b88904811b1ac2d4fee1972446:

  media: coda: set up buffers to be sized as negotiated with s_fmt (2012-09-13 17:14:36 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      coda: Remove unneeded struct vb2_queue clear on queue_init()

Ezequiel García (1):
      coda: Don't check vb2_queue_init() return value

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

Richard Zhao (1):
      media: coda: remove duplicated call of fh_to_ctx in vidioc_s_fmt_vid_out

Sylwester Nawrocki (1):
      coda: Add V4L2_CAP_VIDEO_M2M capability flag

 drivers/media/platform/Kconfig |    3 +-
 drivers/media/platform/coda.c  |  442 +++++++++++++++++++++++++++++-----------
 drivers/media/platform/coda.h  |   30 ++-
 3 files changed, 348 insertions(+), 127 deletions(-)


