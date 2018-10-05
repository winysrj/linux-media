Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55671 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727581AbeJEVCN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 17:02:13 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various cec fixes
Message-ID: <85477394-3456-d7ee-6641-c653f5f19673@xs4all.nl>
Date: Fri, 5 Oct 2018 16:03:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request fixes various CEC bugs. The following patches are also
CCed to stable for 4.18:

      cec: add new tx/rx status bits to detect aborts/timeouts
      adv7604: when the EDID is cleared, unconfigure CEC as well
      adv7842: when the EDID is cleared, unconfigure CEC as well
      cec: fix the Signal Free Time calculation

The 'add new tx/rx status bits' is strictly speaking not a bug fix, but
the absence of these status bits made finding the real bug
(https://patchwork.linuxtv.org/patch/52329/) much harder than it should
have been.

Regards,

	Hans

The following changes since commit f492fb4f5b41e8e62051e710369320e9ffa7a1ea:

  media: MAINTAINERS: Fix entry for the renamed dw9807 driver (2018-10-05 08:40:00 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-cec-media2

for you to fetch changes up to 75773002b711836690aed39d6702b87165136aa5:

  media: cec: name for RC passthrough device does not need 'RC for' (2018-10-05 15:54:06 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (6):
      cec-core.rst: improve cec_transmit_done documentation
      cec: add new tx/rx status bits to detect aborts/timeouts
      adv7604: when the EDID is cleared, unconfigure CEC as well
      adv7842: when the EDID is cleared, unconfigure CEC as well
      cec: fix the Signal Free Time calculation
      cec-gpio: select correct Signal Free Time

Sean Young (1):
      media: cec: name for RC passthrough device does not need 'RC for'

 Documentation/media/kapi/cec-core.rst            |  4 ++++
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 25 ++++++++++++++++++--
 drivers/media/cec/cec-adap.c                     | 92 ++++++++++++++++++++---------------------------------------------------
 drivers/media/cec/cec-core.c                     |  6 ++---
 drivers/media/cec/cec-pin.c                      | 20 ++++++++++++++++
 drivers/media/i2c/adv7604.c                      |  4 +++-
 drivers/media/i2c/adv7842.c                      |  4 +++-
 include/media/cec.h                              |  4 +---
 include/uapi/linux/cec.h                         |  3 +++
 9 files changed, 84 insertions(+), 78 deletions(-)
