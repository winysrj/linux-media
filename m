Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36384 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756094AbdIHOx5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 10:53:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.14] Fixes for 4.14
Message-ID: <7e042197-442f-ee5a-7c72-19aeb4bfb174@xs4all.nl>
Date: Fri, 8 Sep 2017 16:53:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14l

for you to fetch changes up to d87a23d49ba85a482d968ceba30a1de22dd7fb0d:

  cec-pin.c: use proper ktime accessor functions (2017-09-08 16:53:30 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      media: qcom: camss: Make function vfe_set_selection static

Hans Verkuil (1):
      cec-pin.c: use proper ktime accessor functions

Laurent Pinchart (1):
      media: staging/imx: Fix uninitialized variable warning

Stanimir Varbanov (1):
      media: venus: init registered list on streamoff

 drivers/media/cec/cec-pin.c                        | 37 ++++++++++++++++++++++---------------
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c |  2 +-
 drivers/media/platform/qcom/venus/helpers.c        |  1 +
 drivers/staging/media/imx/imx-media-dev.c          |  4 ++--
 4 files changed, 26 insertions(+), 18 deletions(-)
