Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728604AbeH3BIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 21:08:25 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7TL8nhG055009
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2018 17:09:43 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2m6158vscp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2018 17:09:43 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Wed, 29 Aug 2018 17:09:41 -0400
From: Eddie James <eajames@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, andrew@aj.id.au, mchehab@kernel.org,
        joel@jms.id.au, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eddie James <eajames@linux.vnet.ibm.com>
Subject: [PATCH 0/4] media: platform: Add Aspeed Video Engine driver
Date: Wed, 29 Aug 2018 16:09:29 -0500
Message-Id: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
can capture and compress video data from digital or analog sources. With
the Aspeed chip acting as a service processor, the Video Engine can
capture the host processor graphics output.

This series adds a V4L2 driver for the VE, providing a read() interface
only. The driver triggers the hardware to capture the host graphics output
and compress it to JPEG format.

Testing on an AST2500 determined that the videobuf/streaming/mmap interface
was significantly slower than the simple read() interface, so I have not
included the streaming part.

It's also possible to use an automatic mode for the VE such that
re-triggering the HW every frame isn't necessary. However this wasn't
reliable on the AST2400, and probably used more CPU anyway due to excessive
interrupts. It was approximately 15% faster.

The series also adds the necessary parent clock definitions to the Aspeed
clock driver, with both a mux and clock divider.

Eddie James (4):
  clock: aspeed: Add VIDEO reset index definition
  clock: aspeed: Setup video engine clocking
  dt-bindings: media: Add Aspeed Video Engine binding documentation
  media: platform: Add Aspeed Video Engine driver

 .../devicetree/bindings/media/aspeed-video.txt     |   23 +
 drivers/clk/clk-aspeed.c                           |   41 +-
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/aspeed-video.c              | 1307 ++++++++++++++++++++
 include/dt-bindings/clock/aspeed-clock.h           |    1 +
 6 files changed, 1379 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
 create mode 100644 drivers/media/platform/aspeed-video.c

-- 
1.8.3.1
