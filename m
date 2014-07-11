Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51570 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaGKJhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:37:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 00/32]  Initial CODA960 (i.MX6 VPU) support
Date: Fri, 11 Jul 2014 11:36:11 +0200
Message-Id: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is series adds support for the CODA960 Video Processing
Unit on i.MX6Q/D/DL/S SoCs to the coda driver.

Changes since v2:
 - Fixed patch 22 "[media] coda: add sequence counter offset"
   for 16-bit hardware frame counter
 - Changed variable name in patch 23 "[media] coda: rename
    prescan_failed to hold and stop stream after timeout"
 - Added patches 30-32 to store work buffer size, temp buffer
   size, and IRAM size in the coda_devtype struct.

This series contains a few fixes and preparations, the CODA960
support patch, a rework of the hardware access serialization
into a single threaded workqueue, some cleanups to use more
infrastructure that is available in the meantime, runtime PM
support, a few h.264 related v4l2 controls and fixes, support
for hard resets via the i.MX system reset controller, a patch
that exports internal buffers to debugfs, and a few code cleanups.

regards
Philipp

Michael Olbrich (2):
  [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
  [media] coda: try to schedule a decode run after a stop command

Philipp Zabel (30):
  [media] coda: fix decoder I/P/B frame detection
  [media] coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
  [media] coda: fix h.264 quantization parameter range
  [media] coda: fix internal framebuffer allocation size
  [media] coda: simplify IRAM setup
  [media] coda: Add encoder/decoder support for CODA960
  [media] coda: remove BUG() in get_q_data
  [media] coda: add selection API support for h.264 decoder
  [media] coda: add workqueue to serialize hardware commands
  [media] coda: Use mem-to-mem ioctl helpers
  [media] coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
  [media] coda: Add runtime pm support
  [media] coda: split firmware version check out of coda_hw_init
  [media] coda: select GENERIC_ALLOCATOR
  [media] coda: add h.264 min/max qp controls
  [media] coda: add h.264 deblocking filter controls
  [media] coda: add cyclic intra refresh control
  [media] coda: add decoder timestamp queue
  [media] coda: alert userspace about macroblock errors
  [media] coda: add sequence counter offset
  [media] coda: rename prescan_failed to hold and stop stream after
    timeout
  [media] coda: add reset control support
  [media] coda: add bytesperline to queue data
  [media] coda: allow odd width, but still round up bytesperline
  [media] coda: round up internal frames to multiples of macroblock size
    for h.264
  [media] coda: increase frame stride to 16 for h.264
  [media] coda: export auxiliary buffers via debugfs
  [media] coda: store per-context work buffer size in struct
    coda_devtype
  [media] coda: store global temporary buffer size in struct
    coda_devtype
  [media] coda: store IRAM size in struct coda_devtype

 drivers/media/platform/Kconfig         |    1 +
 drivers/media/platform/coda.c          | 1505 ++++++++++++++++++++++----------
 drivers/media/platform/coda.h          |  115 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c |    3 +-
 include/media/v4l2-mem2mem.h           |    2 +
 5 files changed, 1163 insertions(+), 463 deletions(-)

-- 
2.0.0

