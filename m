Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35547 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937179AbeE3HQe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:16:34 -0400
Received: by mail-pf0-f196.google.com with SMTP id x9-v6so8557042pfm.2
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 00:16:34 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 0/2] Add control for VP9 profile
Date: Wed, 30 May 2018 16:16:11 +0900
Message-Id: <20180530071613.125768-1-keiichiw@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a new control V4L2_CID_MPEG_VIDEO_VP9_PROFILE
for VP9 profile.
This control can be used to select a desired profile for VP9 encoder.
In addition, it is also used to query for supported profiles by an
encoder or a decoder.

Patch 1 adds this control.
By patch 2, this control is added to MediaTek decoder's driver, which
supports VP9 profile 0.


Version 2 changes:
- Support this control in MediaTek decoder's driver

Keiichi Watanabe (2):
  media: v4l2-ctrl: Add control for VP9 profile
  media: mtk-vcodec: Support VP9 profile in decoder

 .../media/uapi/v4l/extended-controls.rst      | 26 +++++++++++++++++++
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      |  6 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c          | 12 +++++++++
 include/uapi/linux/v4l2-controls.h            |  8 ++++++
 4 files changed, 52 insertions(+)

--
2.17.0.921.gf22659ad46-goog
