Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:49747 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730448AbeKGAdc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 19:33:32 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: ektor5 <ek5.chimenti@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] cec: add new SECO driver
Message-ID: <597985ff-d1fe-0dd4-75d0-671992f839e3@xs4all.nl>
Date: Tue, 6 Nov 2018 16:07:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request adds CEC support to SECO devices, in particular UDOO X86.

The pull request is identical to the v4 of this series:
https://lkml.org/lkml/2018/10/21/143

Just rebased.

Regards,

	Hans

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-seco

for you to fetch changes up to 6877d7bd0438784fef213beb545f9a09eea80c4a:

  seco-cec: add Consumer-IR support (2018-11-06 15:49:33 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ettore Chimenti (2):
      media: add SECO cec driver
      seco-cec: add Consumer-IR support

 MAINTAINERS                                |   6 +
 drivers/media/platform/Kconfig             |  22 ++
 drivers/media/platform/Makefile            |   2 +
 drivers/media/platform/seco-cec/Makefile   |   1 +
 drivers/media/platform/seco-cec/seco-cec.c | 795 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/seco-cec/seco-cec.h | 141 ++++++++++++
 6 files changed, 967 insertions(+)
 create mode 100644 drivers/media/platform/seco-cec/Makefile
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
