Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56761 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751121AbdHUHjQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:39:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] cec/vivid fixes and enhancements
Message-ID: <b451c5ac-35ae-231f-1b3a-4c4dc417a48c@xs4all.nl>
Date: Mon, 21 Aug 2017 09:39:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch is a bug fix: the CEC adapter was not explicitly
disabled when cec_delete_adapter was called. Normally this does not
cause any problems, but for the upcoming omap4 cec driver it does.

The next two patches add support for CEC pin emulation in the
vivid driver. The third fixes a kernel logging bug in vivid.

The last two patches simplify cec_allocate_adapter in two drivers
by using CEC_CAP_DEFAULTS.

Regards,

	Hans


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivid-cec-pin

for you to fetch changes up to f2fa856a538a6d9ddd58eab558b286e0f65c8e27:

  stm32-cec: use CEC_CAP_DEFAULTS (2017-08-21 09:35:38 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      cec: ensure that adap_enable(false) is called from cec_delete_adapter()
      cec: replace pin->cur_value by adap->cec_pin_is_high
      vivid: add CEC pin monitoring emulation
      vivid: fix incorrect HDMI input/output CEC logging
      stih-cec: use CEC_CAP_DEFAULTS
      stm32-cec: use CEC_CAP_DEFAULTS

 drivers/media/cec/cec-adap.c              |  4 +++-
 drivers/media/cec/cec-api.c               |  6 ++----
 drivers/media/cec/cec-core.c              |  1 +
 drivers/media/cec/cec-pin.c               |  5 ++---
 drivers/media/platform/sti/cec/stih-cec.c |  4 +---
 drivers/media/platform/stm32/stm32-cec.c  |  4 +---
 drivers/media/platform/vivid/vivid-cec.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-core.c |  8 ++++----
 include/media/cec-pin.h                   |  1 -
 include/media/cec.h                       |  1 +
 10 files changed, 79 insertions(+), 20 deletions(-)
