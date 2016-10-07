Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44478 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932719AbcJGRAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:25 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 0/3] Add a libv4l mpeg2 parser plugin for st-delta video decoder
Date: Fri, 7 Oct 2016 19:00:15 +0200
Message-ID: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ST DELTA video decoder is a frame API based decoder which requires
headers metadata in addition to compressed video bitstream data.
This libv4l plugin aims to abstract DELTA frame API under
usual stream API, so compatibility with existing V4L2-based
frameworks such as GStreamer V4L2 video decoder plugin is ensured.
As a proof of concept, MPEG2 video decoding is covered relying
on GStreamer codecparser codebase.
This proof of concept aims to help to standardize the MPEG2 frame
API controls in V4L2 headers by showing a functional reference implementation.
Second aim of this prototype is to show the premice of a libv4l2 plugin
infrastructure allowing to use any appropriate proprietary or open-source
bitstream parser needed by frame API based video hardware accelerators.

Hugues Fruchet (1):
  add a libv4l plugin for st-delta video decoder

Tiphaine Inguere (2):
  libv4l-delta: add GStreamer mpeg codecparser
  libv4l-delta: add mpeg header parser

 configure.ac                                       |    3 +
 lib/Makefile.am                                    |    3 +-
 lib/libv4l-delta/Makefile.am                       |   23 +
 lib/libv4l-delta/codecparsers/Makefile.am          |   40 +
 lib/libv4l-delta/codecparsers/gstmpegvideoparser.c | 1304 ++++++++++++++++++++
 lib/libv4l-delta/codecparsers/gstmpegvideoparser.h |  560 +++++++++
 lib/libv4l-delta/codecparsers/parserutils.c        |   57 +
 lib/libv4l-delta/codecparsers/parserutils.h        |  108 ++
 lib/libv4l-delta/libv4l-delta-mpeg2.c              |  211 ++++
 lib/libv4l-delta/libv4l-delta.c                    |  348 ++++++
 lib/libv4l-delta/libv4l-delta.h                    |   97 ++
 lib/libv4l-delta/libv4l-delta.pc.in                |   12 +
 12 files changed, 2765 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-delta/Makefile.am
 create mode 100644 lib/libv4l-delta/codecparsers/Makefile.am
 create mode 100644 lib/libv4l-delta/codecparsers/gstmpegvideoparser.c
 create mode 100644 lib/libv4l-delta/codecparsers/gstmpegvideoparser.h
 create mode 100644 lib/libv4l-delta/codecparsers/parserutils.c
 create mode 100644 lib/libv4l-delta/codecparsers/parserutils.h
 create mode 100644 lib/libv4l-delta/libv4l-delta-mpeg2.c
 create mode 100644 lib/libv4l-delta/libv4l-delta.c
 create mode 100644 lib/libv4l-delta/libv4l-delta.h
 create mode 100644 lib/libv4l-delta/libv4l-delta.pc.in

-- 
1.9.1

