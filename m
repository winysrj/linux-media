Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36794 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbeFRIAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 04:00:37 -0400
Received: by mail-pg0-f67.google.com with SMTP id m5-v6so7152717pgd.3
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 01:00:37 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 0/3] Add controls for VP8/VP9 profile
Date: Mon, 18 Jun 2018 16:58:51 +0900
Message-Id: <20180618075854.12881-1-keiichiw@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the 4th revision of the patch set that adds controls for VP8/VP9
profiles. Please see v3 cover letter for more details.
<https://lkml.org/lkml/2018/6/14/132>

In this version, I changed the contents that pointed out by Stanimir and Hans.

Changelog
----------

Version 4 changes:
- Remove unnecessary changes in venus drivers.
- Remove unnecessary blank lines in documentations.
- Fix typo and grammar mistakes.

Version 3 changes:
- Add V4L2_CID_MPEG_VIDEO_VP8_PROFILE in v4l2-controls.
- Make V4L2_CID_MPEG_VIDEO_VPX_PROFILE to be an alias of
  V4L2_CID_MPEG_VIDEO_VP8_PROFILE.
- Fix the use of V4L2_CID_MPEG_VIDEO_VPX_PROFILE in venus/s5p_mfc drivers.
- Small fix in mtk_vcodec_dec.

Version 2 changes:
- Support V4L2_CID_MPEG_VIDEO_VP9_PROFILE in MediaTek decoder's driver.

Version 1 changes:
- Add V4L2_CID_MPEG_VIDEO_VP9_PROFILE in v4l2-controls.

Keiichi Watanabe (3):
  media: v4l2-ctrl: Change control for VP8 profile to menu control
  media: v4l2-ctrl: Add control for VP9 profile
  media: mtk-vcodec: Support VP9 profile in decoder

 .../media/uapi/v4l/extended-controls.rst      | 48 +++++++++++++++++--
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      |  5 ++
 .../media/platform/qcom/venus/vdec_ctrls.c    | 10 ++--
 drivers/media/platform/qcom/venus/venc.c      |  4 +-
 .../media/platform/qcom/venus/venc_ctrls.c    | 10 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  | 15 +++---
 drivers/media/v4l2-core/v4l2-ctrls.c          | 23 ++++++++-
 include/uapi/linux/v4l2-controls.h            | 18 ++++++-
 8 files changed, 110 insertions(+), 23 deletions(-)

--
2.18.0.rc1.244.gcf134e6275-goog
