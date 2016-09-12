Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:4847 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751962AbcILQB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 12:01:29 -0400
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 0/2] add debug capabilities to v4l2 encoder for STMicroelectronics SOC
Date: Mon, 12 Sep 2016 18:01:13 +0200
Message-ID: <1473696075-9190-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 1:
- Initial submission

With the first patch, a short summary about the encoding operation is
unconditionnaly printed at each instance closing:
- information about the stream (format, profile, level, resolution)
- performance information (number of encoded frames, maximum framerate)
- potential (system, encoding...) errors

With the second patch, 4 static debugfs entries are created to dump:
- the device-related information ("st-hva/device")
- the list of registered encoders ("st-hva/encoders")
- the current values of the hva registers ("st-hva/regs")
- the information about the last closed instance ("st-hva/last")

Moreover, a debugfs entry is dynamically created for each opened instance,
("st-hva/<instance identifier>") to dump:
- the information about the stream (profile, level, resolution,
  alignment...)
- the control parameters (bitrate mode, framerate, GOP size...)
- the potential (system, encoding...) errors
- the performance information about the encoding (HW processing
  duration, average bitrate, average framerate...)
Each time a running instance is closed, its context (including the debug
information) is saved to feed, on demand, the last closed instance debugfs
entry.

These debug capabilities are mainly implemented in the hva-debug.c file.

Jean-Christophe Trotin (2):
  st-hva: encoding summary at instance release
  st-hva: add debug file system

 drivers/media/platform/sti/hva/Makefile    |   2 +-
 drivers/media/platform/sti/hva/hva-debug.c | 487 +++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva-h264.c  |   6 +
 drivers/media/platform/sti/hva/hva-hw.c    |  44 +++
 drivers/media/platform/sti/hva/hva-hw.h    |   1 +
 drivers/media/platform/sti/hva/hva-mem.c   |   5 +-
 drivers/media/platform/sti/hva/hva-v4l2.c  |  41 ++-
 drivers/media/platform/sti/hva/hva.h       |  85 ++++-
 8 files changed, 656 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/platform/sti/hva/hva-debug.c

-- 
1.9.1

