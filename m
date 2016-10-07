Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62572 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932268AbcJGRAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:05 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 0/2] Add MPEG2 support to STMicroelectronics DELTA video decoder
Date: Fri, 7 Oct 2016 18:59:53 +0200
Message-ID: <1475859595-732-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds MPEG2 support to STMicroelectronics DELTA driver [1].
MPEG2 support requires V4L2 "frame API" in order that MPEG2 parsed metadata
are received in addition to MPEG2 video bitstream buffers.
To do so those patchset are based on work from Florent Revest on MPEG2 low
level decoder [2], which have been enhanced to support more MPEG2 features
(see additional patchset on subject). This work also needs the V4L2 "request
API" [3].
A reference libv4l-delta plugin implementation is sent separately which embeds
a MPEG2 parser generating the headers metadata needed by DELTA video decoder.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg102894.html
[2] http://www.spinics.net/lists/linux-media/msg104824.html
[3] https://lwn.net/Articles/641204/

Hugues Fruchet (2):
  [media] st-delta: add parser meta controls
  [media] st-delta: add mpeg2 support

 drivers/media/platform/Kconfig                     |    6 +
 drivers/media/platform/sti/delta/Makefile          |    3 +
 drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
 drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1412 ++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  415 ++++++
 drivers/media/platform/sti/delta/delta-v4l2.c      |   96 +-
 drivers/media/platform/sti/delta/delta.h           |    8 +-
 7 files changed, 1943 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h

-- 
1.9.1

