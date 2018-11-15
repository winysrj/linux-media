Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39277 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbeKOVbV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:31:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id u13-v6so17653293wmc.4
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 03:23:53 -0800 (PST)
From: Dafna Hirschfeld <dafna3@gmail.com>
To: helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        outreachy-kernel@googlegroups.com
Subject: [PATCH vicodec v4 0/3] Add support to more pixel formats in vicodec
Date: Thu, 15 Nov 2018 13:23:29 +0200
Message-Id: <cover.1541451484.git.dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new supported formats are
V4L2_PIX_FMT_GREY, V4L2_PIX_FMT_ARGB32, V4L2_PIX_FMT_ABGR32.

The returned encoded format is chaned to support various numbers
of planes instead of assuming 3 planes.

The first patch adds new fields to structs.
The second patch adds support for V4L2_PIX_FMT_GREY.
The third patch adds support for V4L2_PIX_FMT_ARGB32, V4L2_PIX_FMT_ABGR32.

The code used to test this patch is https://github.com/kamomil/outreachy
The script I used to test greyscale support:
https://github.com/kamomil/outreachy/blob/master/greyscale-full-example.sh 
The script I used to test argb/abgr:
https://github.com/kamomil/outreachy/blob/master/argb-and-abgr-full-example.sh

Changes from v3:

patch 1,3: - no change

patch 2:
- replace the 2-bit flag FWHT_FL_COMPONENTS_NUM_BIT[01] with GENMASK
- add TODO comment - handle the case where the encoded stream is different format
than the decoded
- allocate maximal space for the V4L2_PIX_FMT_FWHT format

with the test 'flags & FWHT_FL_COMPONENTS_NUM_BIT[01]'

Dafna Hirschfeld (3):
  media: vicodec: prepare support for various number of planes
  media: vicodec: Add support of greyscale format
  media: vicodec: Add support for 4 planes formats

 drivers/media/platform/vicodec/codec-fwht.c   |  73 +++++++----
 drivers/media/platform/vicodec/codec-fwht.h   |  15 ++-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 123 +++++++++++++-----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   3 +-
 drivers/media/platform/vicodec/vicodec-core.c |  35 ++++-
 5 files changed, 182 insertions(+), 67 deletions(-)

-- 
2.17.1
