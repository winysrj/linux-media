Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57803 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754636AbdD1PCt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 11:02:49 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 0/3] Add a libv4l plugin for video bitstream parsing
Date: Fri, 28 Apr 2017 17:02:29 +0200
Message-ID: <1493391752-22429-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stateless video decoders require explicit codec specific metadata
derived from video bitstream parsing.
This plugin aims to silently convert the user provided video bitstream
to a parsed video bitstream, ie the video bitstream itself + additional
parsing metadata which are given to the driver through the V4L2 extended
control framework.
This plugin can support several codec dependent parser backends, enabling
of the right parser is done by intercepting the pixel format information
negotiated between user and driver (enum_fmt/try_fmt/get_fmt/s_fmt).
This patchset provides a MPEG-2 parser backend using GStreamer
codecparsers library.
It has been tested with STMicroelectronics st-delta kernel driver.

===========
= history =
===========
version 2:
  - rebase linux headers based on st-delta mpeg2 v6 patchset:
    http://www.mail-archive.com/linux-media@vger.kernel.org/msg112067.html

version 1:
  - initial submission


Hugues Fruchet (3):
  v4l-utils: sync with kernel (parsed MPEG-2 support)
  add libv4l-codecparsers plugin for video bitstream parsing
  libv4l-codecparsers: add GStreamer mpeg2 parser

 configure.ac                                      |  23 ++
 include/linux/v4l2-controls.h                     |  93 +++++
 include/linux/videodev2.h                         |   8 +
 lib/Makefile.am                                   |   3 +-
 lib/libv4l-codecparsers/Makefile.am               |  21 +
 lib/libv4l-codecparsers/libv4l-codecparsers.pc.in |  12 +
 lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c   | 375 +++++++++++++++++
 lib/libv4l-codecparsers/libv4l-cparsers.c         | 465 ++++++++++++++++++++++
 lib/libv4l-codecparsers/libv4l-cparsers.h         | 101 +++++
 9 files changed, 1100 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-codecparsers/Makefile.am
 create mode 100644 lib/libv4l-codecparsers/libv4l-codecparsers.pc.in
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers.c
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers.h

-- 
1.9.1
