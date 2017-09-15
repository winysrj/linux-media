Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56509 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750865AbdIOIJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:09:42 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.14] Two CEC fixes
Message-ID: <0bcb5447-de61-e420-2c6d-0ab625fe9f05@xs4all.nl>
Date: Fri, 15 Sep 2017 10:09:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two CEC fixes for 4.14. Both are also CC-ed to stable. These fixes fall in the
category 'important but not urgent'.

Regards,

	Hans

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14n

for you to fetch changes up to 2f4c7705f22e53a13de2e4932f62f1393816fa73:

  cec: Respond to unregistered initiators, when applicable (2017-09-15 10:04:28 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      s5p-cec: add NACK detection support

Jose Abreu (1):
      cec: Respond to unregistered initiators, when applicable

 drivers/media/cec/cec-adap.c                         | 13 ++++++++++---
 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c |  3 ++-
 drivers/media/platform/s5p-cec/s5p_cec.c             | 11 ++++++++++-
 drivers/media/platform/s5p-cec/s5p_cec.h             |  2 ++
 4 files changed, 24 insertions(+), 5 deletions(-)
