Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:53666 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726585AbeHUKuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:50:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] vicodec improvements
Date: Tue, 21 Aug 2018 09:31:13 +0200
Message-Id: <20180821073119.3662-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- add support for quantization parameters
- support many more pixel formats
- code simplifications
- rename source and use proper prefixes for the codec: this makes it
  independent from the vicodec driver and easier to reuse in userspace
  (similar to what we do for the v4l2-tpg code).

Hans Verkuil (6):
  vicodec: add QP controls
  vicodec: add support for more pixel formats
  vicodec: simplify flags handling
  vicodec: simplify blocktype checking
  vicodec: improve handling of uncompressable planes
  vicodec: rename and use proper fwht prefix for codec

 drivers/media/platform/vicodec/Makefile       |   2 +-
 .../vicodec/{vicodec-codec.c => codec-fwht.c} | 148 ++++--
 .../vicodec/{vicodec-codec.h => codec-fwht.h} |  76 ++-
 drivers/media/platform/vicodec/vicodec-core.c | 482 +++++++++++++-----
 4 files changed, 488 insertions(+), 220 deletions(-)
 rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (85%)
 rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (67%)

-- 
2.18.0
