Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB695C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5905217F9
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfAILaq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:30:46 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50827 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730732AbfAILap (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 06:30:45 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1ghC4J-00050U-Bk; Wed, 09 Jan 2019 12:30:43 +0100
Received: from mtr by dude.hi.pengutronix.de with local (Exim 4.91)
        (envelope-from <mtr@pengutronix.de>)
        id 1ghC4I-00018T-P8; Wed, 09 Jan 2019 12:30:42 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 0/3] Add ZynqMP VCU/Allegro DVT H.264 encoder driver
Date:   Wed,  9 Jan 2019 12:30:34 +0100
Message-Id: <20190109113037.28430-1-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.19.1
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

This series adds support for the Allegro DVT H.264 encoder found in the EV
family of the Xilinx ZynqMP platform.

The encoder is part of the ZynqMP VCU (video codec unit), which supports
encoding and decoding of H.264 and H.265. I am planning to support decoding
and H.265 as well in this driver.

The codec engines are separate hard IP cores in the FPGA of the ZynqMP and
each engine is controlled by a microcontroller (MCU). Each MCU executes code
in its own memory mapped SRAM. This SRAM also contains mailboxes that the
driver uses to exchange command and status messages with the MCU.

Encoder and decoder share an interrupt that is triggered whenever a message is
available in one of the mailboxes. Each MCU provides an interrupt status
register in its own register space.

I would appreciate feedback to the device tree bindings, the overall
architecture of the driver and if there are any major issues that I need to
address.

There are several things already on my own TODO list:

- The driver still contains various hard coded values and only works with a
  resolution of 144x144. I am working on enabling more resolutions and
  actually calculating the hard-coded values.

- The driver also only works with the vcu-firmware release 2018.2 [0]. The
  2018.3 release uses a different mailbox size, which needs to be reflected in
  the driver.

- There is the xlnx-vcu driver for managing the clocks via the FPGA glue code.
  Right now, the allegro driver does not interact with the driver to configure
  the clocks.

I ran v4l2-compliance without failures on the driver, but I think adding the
test results right now only distracts from more important open issues in the
driver.

Michael

[0] https://github.com/Xilinx/vcu-firmware/tree/xilinx-v2018.2

Michael Tretter (3):
  media: dt-bindings: media: document allegro-dvt bindings
  [media] allegro: add Allegro DVT video IP core driver
  [media] allegro: add SPS/PPS nal unit writer

 .../devicetree/bindings/media/allegro.txt     |   35 +
 MAINTAINERS                                   |    6 +
 drivers/staging/media/Kconfig                 |    2 +
 drivers/staging/media/Makefile                |    1 +
 drivers/staging/media/allegro-dvt/Kconfig     |    6 +
 drivers/staging/media/allegro-dvt/Makefile    |    6 +
 .../staging/media/allegro-dvt/allegro-core.c  | 2425 +++++++++++++++++
 drivers/staging/media/allegro-dvt/nal-h264.c  | 1278 +++++++++
 drivers/staging/media/allegro-dvt/nal-h264.h  |  188 ++
 9 files changed, 3947 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
 create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
 create mode 100644 drivers/staging/media/allegro-dvt/Makefile
 create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c
 create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.c
 create mode 100644 drivers/staging/media/allegro-dvt/nal-h264.h

-- 
2.19.1

