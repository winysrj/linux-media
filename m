Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58920 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751656AbdFII4a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 04:56:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Add stm32-cec driver
Message-ID: <e6f0bb35-4eb7-1a94-3941-378bb92c5583@xs4all.nl>
Date: Fri, 9 Jun 2017 10:56:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 47f910f0e0deb880c2114811f7ea1ec115a19ee4:

  [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev (2017-06-08 16:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git stm32-cec

for you to fetch changes up to bb4b9368c6836c21d76fa53aa425cd48ba0e94fb:

  cec: add STM32 cec driver (2017-06-09 10:35:50 +0200)

----------------------------------------------------------------
Benjamin Gaignard (2):
      dt-bindings: media: stm32 cec driver
      cec: add STM32 cec driver

 Documentation/devicetree/bindings/media/st,stm32-cec.txt |  19 +++
 drivers/media/platform/Kconfig                           |  12 ++
 drivers/media/platform/Makefile                          |   2 +
 drivers/media/platform/stm32/Makefile                    |   1 +
 drivers/media/platform/stm32/stm32-cec.c                 | 362 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 396 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt
 create mode 100644 drivers/media/platform/stm32/stm32-cec.c
