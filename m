Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45481 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1764758AbcIOIwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 04:52:31 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id C077218021F
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 10:52:25 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add stih CEC driver
Message-ID: <9533b6ca-396f-74b4-dcaf-6c20d5abc36e@xs4all.nl>
Date: Thu, 15 Sep 2016 10:52:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git stcec

for you to fetch changes up to 25e8af2ec02b5ba76e34b687d80f8c58bb8db809:

  add maintainer for stih-cec driver (2016-09-15 10:38:23 +0200)

----------------------------------------------------------------
Benjamin Gaignard (4):
      bindings for stih-cec driver
      add stih-cec driver
      add stih-cec driver into DT
      add maintainer for stih-cec driver

 Documentation/devicetree/bindings/media/stih-cec.txt |  25 +++++
 MAINTAINERS                                          |   7 ++
 arch/arm/boot/dts/stih407-family.dtsi                |  12 +++
 drivers/staging/media/Kconfig                        |   2 +
 drivers/staging/media/Makefile                       |   1 +
 drivers/staging/media/st-cec/Kconfig                 |   8 ++
 drivers/staging/media/st-cec/Makefile                |   1 +
 drivers/staging/media/st-cec/stih-cec.c              | 380 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 436 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/stih-cec.txt
 create mode 100644 drivers/staging/media/st-cec/Kconfig
 create mode 100644 drivers/staging/media/st-cec/Makefile
 create mode 100644 drivers/staging/media/st-cec/stih-cec.c
