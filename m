Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42449 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751292AbdHDKl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/5] cec: add CEC_CAP_DEFAULTS define
Date: Fri,  4 Aug 2017 12:41:50 +0200
Message-Id: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Four CEC capabilities are normally always used. So combine them
in a single CEC_CAP_DEFAULTS define. This also avoids missing one
of these caps as happened in the stih-cec driver.

Regards,

	Hans

Hans Verkuil (5):
  media/cec.h: add CEC_CAP_DEFAULTS
  adv*/vivid/pulse8/rainshadow: cec: use CEC_CAP_DEFAULTS
  s5p-cec: use CEC_CAP_DEFAULTS
  stih-cec: use CEC_CAP_DEFAULTS
  stm32-cec: use CEC_CAP_DEFAULTS

 drivers/media/i2c/adv7511.c                       | 3 +--
 drivers/media/i2c/adv7604.c                       | 3 +--
 drivers/media/i2c/adv7842.c                       | 3 +--
 drivers/media/platform/s5p-cec/s5p_cec.c          | 7 ++-----
 drivers/media/platform/sti/cec/stih-cec.c         | 4 +---
 drivers/media/platform/stm32/stm32-cec.c          | 4 +---
 drivers/media/platform/vivid/vivid-cec.c          | 3 +--
 drivers/media/usb/pulse8-cec/pulse8-cec.c         | 3 +--
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 3 +--
 include/media/cec.h                               | 3 +++
 10 files changed, 13 insertions(+), 23 deletions(-)

-- 
2.13.2
