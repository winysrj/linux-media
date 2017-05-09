Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60007 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750969AbdEIHmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 03:42:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Add new STM32 DCMI camera driver
Message-ID: <87a13ce2-8352-8fc2-1f0d-c1c2e385f2bb@xs4all.nl>
Date: Tue, 9 May 2017 09:42:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git stm32

for you to fetch changes up to e48842d83dc4ccd0519f8721f42a3a89b2f2329c:

  stm32-dcmi: STM32 DCMI camera interface driver (2017-05-06 10:55:27 +0200)

----------------------------------------------------------------
Hugues Fruchet (2):
      dt-bindings: Document STM32 DCMI bindings
      stm32-dcmi: STM32 DCMI camera interface driver

 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt |   45 ++
 drivers/media/platform/Kconfig                            |   12 +
 drivers/media/platform/Makefile                           |    2 +
 drivers/media/platform/stm32/Makefile                     |    1 +
 drivers/media/platform/stm32/stm32-dcmi.c                 | 1403 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1463 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
 create mode 100644 drivers/media/platform/stm32/Makefile
 create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
