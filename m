Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52511 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753073AbeBKL05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 06:26:57 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/4] Improve DVB memory mapped API
Date: Sun, 11 Feb 2018 09:26:46 -0200
Message-Id: <cover.1518347588.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series improve the DVB memory mapped API to allow it to
report continuity errors.

Doing it for Digital TV standards is not mandatory, as
MPEG-TS has already support for it. Yet, when trying to
discover if the discontinuity happened due to a driver problem
or due to userspace troubles can be tricky.

So, this patch series add two fields at the struct used by
DMX_DQBUF (struct dmx_buffer):

- count: a simple monotonic uint32_t counter;
- flags: a bitmap field that lets the DVB core to report if
  it detects an error.

There are already some logic inside the demux code that checks
for discontinuity errors while receiving data. Make them to
update the flags.

Somehow, some changes I made while testing the DVB API never
made upstream: Arnd had to write some fixes for it to be built
and parts of the conditional support had a reverted logic.

patch 1 actually addresses an old issue at the DVB demux API:
if an ioctl fails due to invalid parameters, or if an ioctl
doesn't exist, it returns the same error code (-EINVAL).
The patch changes the latter to -ENOTTY>

patch 2 fixes the DMA mmap support, that was merged lacking
a fix that got lost. I ended by rewriting the code, making it
simpler.

patch 3 adds count/flags to mmap API;

patch 4 makes the DVB core to update count and flags.

All those patches are at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb-mmap-v3

The v4l-utils code, updated to use the mmap API, is at:
	https://git.linuxtv.org/mchehab/experimental-v4l-utils.git/log/?h=dvb-mmap-v2

Please notice that the API is experimental, and may still change
until we release the final version of Kernel 4.16.

Have fun,
Mauro

Mauro Carvalho Chehab (4):
  media: dmxdev: fix error code for invalid ioctls
  media: dmxdev: Fix the logic that enables DMA mmap support
  media: dvb: add continuity error indicators for memory mapped buffers
  media: dvb: update buffer mmaped flags and frame counter

 Documentation/media/dmx.h.rst.exceptions  |  14 ++--
 Documentation/media/uapi/dvb/dmx-qbuf.rst |   7 +-
 drivers/media/dvb-core/dmxdev.c           |  98 +++++++++++++++-----------
 drivers/media/dvb-core/dvb_demux.c        | 113 +++++++++++++++++++-----------
 drivers/media/dvb-core/dvb_net.c          |   5 +-
 drivers/media/dvb-core/dvb_vb2.c          |  31 +++++---
 include/media/demux.h                     |  21 ++++--
 include/media/dmxdev.h                    |   2 +
 include/media/dvb_demux.h                 |   4 ++
 include/media/dvb_vb2.h                   |  18 ++++-
 include/uapi/linux/dvb/dmx.h              |  35 +++++++++
 11 files changed, 242 insertions(+), 106 deletions(-)

-- 
2.14.3
