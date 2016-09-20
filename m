Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:22463 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753626AbcITJqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 05:46:47 -0400
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 0/2] add debug capabilities to v4l2 encoder for STMicroelectronics SOC
Date: Tue, 20 Sep 2016 11:46:34 +0200
Message-ID: <1474364796-23747-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 2:
- the encoding summary (first patch) doesn't include any longer information
  about the encoding performance. Thus, after each frame encoding, only one or
  two variables are increased (number of encoded frames, number of encoding
  errors), but no computation is executed (as it was in version 1). When the
  encoding instance is closed, the short summary that is printed (dev_info),
  also doesn't require any computation, and gives a useful brief status about
  the last operation: that are the reasons why there's no Kconfig option to
  explicitly enable this summary.

- the second patch enables the computation of the performances (hva_dbg_perf_begin
  and hva_dbg_perf_end) only if DEBUG_FS is enabled. The functions that
  create or remove the debugfs entries (hva_debugfs_create,
  hva_debugfs_remove, hva_dbg_ctx_create, hva_dbg_ctx_remove) are not under
  CONFIG_DEBUG_FS switch: if DEBUG_FS is disabled, the debugfs functions
  (debugfs_create_dir and debugfs_create_file) are available, but no entry is
  created. The "show" operations (hva_dbg_device, hva_dbg_encoders,
  hva_dbg_last, hva_dbg_regs, hva_dbg_ctx) are also not under
  CONFIG_DEBUG_FS switch: if DEBUG_FS is disabled, they will never be called.
  So, with this version 2, no new Kconfig option is introduced, but the
  performance computations and the debugfs entries depend on whether DEBUG_FS
  is enabled or not.

version 1:
- Initial submission

With the first patch, a short summary about the encoding operation is
unconditionnaly printed at each instance closing:
- information about the frame (format, resolution)
- information about the stream (format, profile, level, resolution)
- number of encoded frames
- potential (system, encoding...) errors

With the second patch, 4 static debugfs entries are created to dump:
- the device-related information ("st-hva/device")
- the list of registered encoders ("st-hva/encoders")
- the current values of the hva registers ("st-hva/regs")
- the information about the last closed instance ("st-hva/last")

Moreover, a debugfs entry is dynamically created for each opened instance,
("st-hva/<instance identifier>") to dump:
 - the information about the frame (format, resolution)
- the information about the stream (format, profile, level,
  resolution)
- the control parameters (bitrate mode, framerate, GOP size...)
- the potential (system, encoding...) errors
- the performance information about the encoding (HW processing
  duration, average bitrate, average framerate...)
Each time a running instance is closed, its context (including the debug
information) is saved to feed, on demand, the last closed instance debugfs
entry.

These debug capabilities are mainly implemented in the hva-debug.c file.

Jean-Christophe Trotin (2):
  [media] st-hva: encoding summary at instance release
  [media] st-hva: add debug file system

 drivers/media/platform/sti/hva/Makefile    |   2 +-
 drivers/media/platform/sti/hva/hva-debug.c | 488 +++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva-h264.c  |   6 +
 drivers/media/platform/sti/hva/hva-hw.c    |  44 +++
 drivers/media/platform/sti/hva/hva-hw.h    |   1 +
 drivers/media/platform/sti/hva/hva-mem.c   |   5 +-
 drivers/media/platform/sti/hva/hva-v4l2.c  |  47 ++-
 drivers/media/platform/sti/hva/hva.h       |  89 +++++-
 8 files changed, 667 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/platform/sti/hva/hva-debug.c

-- 
1.9.1

