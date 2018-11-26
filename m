Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42101 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbeK0AqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 19:46:24 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] venus fixes
Message-ID: <a3dc6a6e-1ad7-e8a3-18ac-869338bc85c6@xs4all.nl>
Date: Mon, 26 Nov 2018 14:52:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21f

for you to fetch changes up to 6d26aaad0d1e1d0588c07f6cffdfce0839fdb21c:

  media: venus: fix reported size of 0-length buffers (2018-11-26 14:31:00 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Alexandre Courbot (1):
      media: venus: fix reported size of 0-length buffers

Malathi Gottam (3):
      media: venus: add support for USERPTR to queue
      media: venus: handle peak bitrate set property
      media: venus: dynamic handling of bitrate

 drivers/media/platform/qcom/venus/hfi_cmds.c   |  2 +-
 drivers/media/platform/qcom/venus/hfi_venus.c  |  2 ++
 drivers/media/platform/qcom/venus/vdec.c       |  4 +---
 drivers/media/platform/qcom/venus/venc.c       |  4 ++--
 drivers/media/platform/qcom/venus/venc_ctrls.c | 15 +++++++++++++++
 5 files changed, 21 insertions(+), 6 deletions(-)
