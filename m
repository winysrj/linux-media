Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50247 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbeH3NqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 09:46:14 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] vicodec improvements
Message-ID: <a8ab3920-0549-d1e9-6fc5-afd158ef69ba@xs4all.nl>
Date: Thu, 30 Aug 2018 11:44:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various vicodec improvements that make it more useful and easier to
re-use in userspace applications like v4l2-ctl and qvidcap.

- add support for quantization parameters
- support many more pixel formats
- code simplifications
- rename source and use proper prefixes for the codec: this makes it
  independent from the vicodec driver and easier to reuse in userspace
  (similar to what we do for the v4l2-tpg code).
- split off the v4l2 'frontend' code for the FWHT codec into its own
  source for easier re-use elsewhere (i.e. v4l2-ctl/qvidcap).
- fix out-of-range values when decoding.

I made a v4l-utils branch that uses the FWHT codec to compress video
when streaming over the network:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=qvidcap

Regards,

	Hans

The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:

  media: camss: add missing includes (2018-08-29 14:02:06 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vicodec

for you to fetch changes up to a12ff4f22c26492ee38dc27fe04a2f90aeb98d8b:

  vicodec: fix out-of-range values when decoding (2018-08-30 10:35:18 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      vicodec: add QP controls
      vicodec: add support for more pixel formats
      vicodec: simplify flags handling
      vicodec: simplify blocktype checking
      vicodec: improve handling of uncompressable planes
      vicodec: rename and use proper fwht prefix for codec
      vicodec: split off v4l2 specific parts for the codec
      vicodec: fix out-of-range values when decoding

 Documentation/media/uapi/v4l/pixfmt-compressed.rst               |   2 +-
 drivers/media/platform/vicodec/Makefile                          |   2 +-
 drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} | 158 +++++++++----
 drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} |  80 +++----
 drivers/media/platform/vicodec/codec-v4l2-fwht.c                 | 325 +++++++++++++++++++++++++
 drivers/media/platform/vicodec/codec-v4l2-fwht.h                 |  50 ++++
 drivers/media/platform/vicodec/vicodec-core.c                    | 483 ++++++++++++++++----------------------
 7 files changed, 731 insertions(+), 369 deletions(-)
 rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (84%)
 rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (64%)
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.c
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.h
