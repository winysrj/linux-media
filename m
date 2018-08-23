Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53356 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbeHWLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:01:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/7] vicodec improvements
Date: Thu, 23 Aug 2018 09:32:58 +0200
Message-Id: <20180823073305.6518-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- add support for quantization parameters
- support many more pixel formats
- code simplifications
- rename source and use proper prefixes for the codec: this makes it
  independent from the vicodec driver and easier to reuse in userspace
  (similar to what we do for the v4l2-tpg code).
- split off the v4l2 'frontend' code for the FWHT codec into its own
  source for easier re-use elsewhere (i.e. v4l2-ctl/qvidcap).

I made a v4l-utils branch that uses the FWHT codec to compress video
when streaming over the network:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=qvidcap

You need to add the --stream-to-host-lossy flag to enable FWHT streaming.

Note: the FWHT codec clips R/G/B values for RGB formats. This will be
addressed later. I might have to convert the R/G/B values from full to
limited range before encoding them, but I want to discuss this with the
author of the codec (Tom aan de Wiel) first.

Regards,

	Hans

Changes since v1:

- added the last patch (split off v4l2 FWHT code)
- the GOP_SIZE and QP controls can now be set during streaming as
  well.

Hans Verkuil (7):
  vicodec: add QP controls
  vicodec: add support for more pixel formats
  vicodec: simplify flags handling
  vicodec: simplify blocktype checking
  vicodec: improve handling of uncompressable planes
  vicodec: rename and use proper fwht prefix for codec
  vicodec: split off v4l2 specific parts for the codec

 .../media/uapi/v4l/pixfmt-compressed.rst      |   2 +-
 drivers/media/platform/vicodec/Makefile       |   2 +-
 .../vicodec/{vicodec-codec.c => codec-fwht.c} | 148 ++++--
 .../vicodec/{vicodec-codec.h => codec-fwht.h} |  80 ++-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 325 ++++++++++++
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  50 ++
 drivers/media/platform/vicodec/vicodec-core.c | 483 ++++++++----------
 7 files changed, 723 insertions(+), 367 deletions(-)
 rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (85%)
 rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (64%)
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.c
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.h

-- 
2.18.0
