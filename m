Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5416EC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CCA22087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfARNhV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:37:21 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47867 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfARNhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 08:37:21 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1gkUKl-0006QA-Ls; Fri, 18 Jan 2019 14:37:19 +0100
Received: from mtr by dude.hi.pengutronix.de with local (Exim 4.92-RC4)
        (envelope-from <mtr@pengutronix.de>)
        id 1gkUKl-0000n5-1U; Fri, 18 Jan 2019 14:37:19 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
Date:   Fri, 18 Jan 2019 14:37:13 +0100
Message-Id: <20190118133716.29288-1-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is v2 of the series to add support for the Allegro DVT H.264 encoder
found in the EV family of the Xilinx ZynqMP platform.

See v1 [0] of the patch series for a description of the hardware.

I fixed the handling of frames with various sizes and driver is now able to
encode H.264 video in the baseline profile up to 1920x1080 pixels. I also
addressed the issues reported by the kbuild robot for the previous series,
implemented a few extended controls and changed the interface to the mcu to
follow the register documentation rather than the downstream driver
implementation.

I would especially appreciate feedback to the device tree bindings and the
overall architecture of the driver.

The driver still only works with the vcu-firmware release 2018.2. I am not yet
sure how to address the different firmware versions, because in addition to
the mailbox sizes, there are also changes within the messages themselves.

I also did not address the integration with the xlnx-vcu driver, yet.

Michael

[0] https://lore.kernel.org/linux-media/20190109113037.28430-1-m.tretter@pengutronix.de/

Changes since v1:
- clean up debug log levels
- fix unused variable in allegro_mbox_init
- fix uninitialized variable in allegro_mbox_write
- fix global module parameters
- fix Kconfig dependencies
- return h264 as default codec for mcu
- implement device reset as documented
- document why irq does not wait for clear
- rename ENCODE_ONE_FRM to ENCODE_FRAME
- allow error codes for mcu_channel_id
- move control handler to channel
- add fw version check
- add support for colorspaces
- enable configuration of H.264 levels
- enable configuration of frame size
- enable configuration of bit rate and CPB size
- enable configuration of GOP size
- rework response handling
- fix missing error handling in allegro_h264_write_sps

Michael Tretter (3):
  media: dt-bindings: media: document allegro-dvt bindings
  [media] allegro: add Allegro DVT video IP core driver
  [media] allegro: add SPS/PPS nal unit writer

 .../devicetree/bindings/media/allegro.txt     |   35 +
 MAINTAINERS                                   |    6 +
 drivers/staging/media/Kconfig                 |    2 +
 drivers/staging/media/Makefile                |    1 +
 drivers/staging/media/allegro-dvt/Kconfig     |   16 +
 drivers/staging/media/allegro-dvt/Makefile    |    6 +
 .../staging/media/allegro-dvt/allegro-core.c  | 2828 +++++++++++++++++
 drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 ++++++++
 drivers/staging/media/allegro-dvt/nal-h264.h  |  188 ++
 9 files changed, 4360 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
 create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
 create mode 100644 drivers/staging/media/allegro-dvt/Makefile
 create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
 create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
 create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h

-- 
2.20.1

