Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:38003 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388153AbeGWKcp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 06:32:45 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Tom aan de Wiel <tom.aandewiel@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] vicodec: the Virtual Codec driver
Message-ID: <bcacddc9-2b33-9b16-4db1-c3fdea2c33ea@xs4all.nl>
Date: Mon, 23 Jul 2018 11:32:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the pull request for the new vicodec driver. The cover letter is
here:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg133594.html

One request: the vicodec-codec.h header refers to Tom's report on the Fast Walsh
Hadamard Transform:

https://hverkuil.home.xs4all.nl/fwht.pdf

Can you copy this pdf and put it up somewhere on linuxtv.org and update the
link in the header so it points to linuxtv.org?

With all the activities ongoing it will be very useful to have this driver in
the kernel so we can test and verify APIs.

Regards,

	Hans

The following changes since commit 39fbb88165b2bbbc77ea7acab5f10632a31526e6:

  media: bpf: ensure bpf program is freed on detach (2018-07-13 11:07:29 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vicodec

for you to fetch changes up to 92389fd3ce7cce108b448d76943c71d410ab40c0:

  vicodec: add the virtual codec driver (2018-07-23 11:24:54 +0200)

----------------------------------------------------------------
Hans Verkuil (5):
      media.h: add encoder/decoder functions for codecs
      videodev.h: add PIX_FMT_FWHT for use with vicodec
      v4l2-mem2mem: add v4l2_m2m_last_buf()
      vicodec: add the FWHT software codec
      vicodec: add the virtual codec driver

 Documentation/media/uapi/mediactl/media-types.rst  |   11 +
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    7 +
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |    3 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/vicodec/Kconfig             |   13 +
 drivers/media/platform/vicodec/Makefile            |    4 +
 drivers/media/platform/vicodec/vicodec-codec.c     |  797 +++++++++++++++++++++++++++
 drivers/media/platform/vicodec/vicodec-codec.h     |  129 +++++
 drivers/media/platform/vicodec/vicodec-core.c      | 1506 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   18 +
 include/media/v4l2-mem2mem.h                       |   29 +
 include/uapi/linux/media.h                         |    2 +
 include/uapi/linux/videodev2.h                     |    1 +
 15 files changed, 2530 insertions(+)
 create mode 100644 drivers/media/platform/vicodec/Kconfig
 create mode 100644 drivers/media/platform/vicodec/Makefile
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.c
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.h
 create mode 100644 drivers/media/platform/vicodec/vicodec-core.c
