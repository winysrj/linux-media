Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38494 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdHROQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:20 -0400
Received: by mail-wm0-f47.google.com with SMTP id l19so983239wmi.1
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:19 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 0/7] Venus updates
Date: Fri, 18 Aug 2017 17:15:59 +0300
Message-Id: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Patch 1/7 has been sent already as an RFC but in this patchset
it can be found as a regular patch. The RFC version can be found
at [1] and also to prove its need look at [2]. Patch 2/7 fixes
Venus encoder issue with help of 1/7.

The other patches 3/7 to 7/7 can be treated as updates for
v4.14. For more info look in the patch descriptions.

Comments are welcome!

regards,
Stan

[1] https://lkml.org/lkml/2017/8/14/104
[2] https://patchwork.kernel.org/patch/9394145/

Stanimir Varbanov (7):
  media: vb2: add bidirectional flag in vb2_queue
  media: venus: venc: set correct resolution on compressed stream
  media: venus: mark venc and vdec PM functions as __maybe_unused
  media: venus: fill missing video_device name
  media: venus: add helper to check supported codecs
  media: venus: use helper function to check supported codecs
  media: venus: venc: drop VP9 codec support

 drivers/media/platform/qcom/venus/helpers.c | 49 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 drivers/media/platform/qcom/venus/vdec.c    | 31 +++++++++++-------
 drivers/media/platform/qcom/venus/venc.c    | 47 +++++++++++++++------------
 drivers/media/v4l2-core/videobuf2-core.c    | 17 +++++-----
 include/media/videobuf2-core.h              | 13 ++++++++
 6 files changed, 118 insertions(+), 40 deletions(-)

-- 
2.11.0
