Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:55291 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037503AbdDUJyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 05:54:01 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] Synopsys Designware HDMI Video Capture Controller + PHY
Date: Fri, 21 Apr 2017 10:53:19 +0100
Message-Id: <cover.1492767176.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This is a RFC series that is intended to collect comments regarding the
Synopsys Designware HDMI RX controller and Synopsys Designware HDMI RX e405 PHY
drivers.

The Synopsys Designware HDMI RX controller is an HDMI receiver controller that
is responsible to process digital data that comes from a phy. The final result
is a stream of raw video data that can then be connected to a video DMA, for
example, and transfered into RAM so that it can be displayed.

The controller + phy available in this series natively support all HDMI 1.4 and
HDMI 2.0 modes, including deep color. Although, the driver is quite in its
initial stage and unfortunatelly only non deep color modes are supported. Also,
audio is not yet supported in the driver (the controller has several audio
output interfaces).

Feel free to take a look at this series and please leave a comment! I can
expand a little bit more about design decisions and would like to know wether
these were the best choices.

With best regards,
Jose Miguel Abreu

Jose Abreu (2):
  [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
  [media] platform: Add Synopsys Designware HDMI RX Controller Driver

Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org

 drivers/media/platform/Kconfig                |    2 +
 drivers/media/platform/Makefile               |    2 +
 drivers/media/platform/dwc/Kconfig            |   17 +
 drivers/media/platform/dwc/Makefile           |    2 +
 drivers/media/platform/dwc/dw-hdmi-phy-e405.c |  879 ++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-phy-e405.h |   63 ++
 drivers/media/platform/dwc/dw-hdmi-rx.c       | 1396 +++++++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-rx.h       |  313 ++++++
 include/media/dwc/dw-hdmi-phy-pdata.h         |   64 ++
 include/media/dwc/dw-hdmi-rx-pdata.h          |   50 +
 10 files changed, 2788 insertions(+)
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
 create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h
 create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h

-- 
1.9.1
