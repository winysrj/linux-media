Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44596 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaFMQJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/30] Initial CODA960 (i.MX6 VPU) support
Date: Fri, 13 Jun 2014 18:08:26 +0200
Message-Id: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the following series adds initial support for the CODA960 Video
Processing Unit on i.MX6Q/D/DL/S SoCs to the coda driver.

This series contains a few fixes and preparations, the CODA960
support patch, a rework of the hardware access serialization
into a single threaded workqueue, some cleanups to use more
infrastructure that is available in the meantime, runtime PM
support, a few h.264 related v4l2 controls and fixes, support
for hard resets via the i.MX system reset controller, and a
patch that exports internal buffers to debugfs.

regards
Philipp

Michael Olbrich (2):
  [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
  [media] coda: try to schedule a decode run after a stop command

Philipp Zabel (28):
  [media] coda: fix decoder I/P/B frame detection
  [media] coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
  [media] coda: fix h.264 quantization parameter range
  [media] coda: fix internal framebuffer allocation size
  [media] coda: simplify IRAM setup
  [media] coda: Add encoder/decoder support for CODA960
  [media] coda: add selection API support for h.264 decoder
  [media] coda: add support for frame size enumeration
  [media] coda: add workqueue to serialize hardware commands
  [media] coda: Use mem-to-mem ioctl helpers
  [media] coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
  [media] coda: Add runtime pm support
  [media] coda: split firmware version check out of coda_hw_init
  [media] coda: select GENERIC_ALLOCATOR
  [media] coda: add h.264 min/max qp controls
  [media] coda: add h.264 deblocking filter controls
  [media] coda: add cyclic intra refresh control
  [media] coda: let userspace force IDR frames by enabling the keyframe
    flag in the source buffer
  [media] coda: add decoder timestamp queue
  [media] coda: alert userspace about macroblock errors
  [media] coda: add sequence counter offset
  [media] coda: use prescan_failed variable to stop stream after a
    timeout
  [media] coda: add reset control support
  [media] coda: add bytesperline to queue data
  [media] coda: allow odd width, but still round up bytesperline
  [media] coda: round up internal frames to multiples of macroblock size
    for h.264
  [media] coda: increase frame stride to 16 for h.264
  [media] coda: export auxiliary buffers via debugfs

 drivers/media/platform/Kconfig         |    1 +
 drivers/media/platform/coda.c          | 1505 +++++++++++++++++++++++---------
 drivers/media/platform/coda.h          |  115 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c |    3 +-
 include/media/v4l2-mem2mem.h           |    2 +
 5 files changed, 1197 insertions(+), 429 deletions(-)

-- 
2.0.0.rc2

