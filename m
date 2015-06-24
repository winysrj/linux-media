Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34650 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbFXPL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:27 -0400
Received: by wicnd19 with SMTP id nd19so137764882wic.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:25 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 00/12] Add c8sectpfe LinuxDVB demux driver
Date: Wed, 24 Jun 2015 16:10:58 +0100
Message-Id: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maruro,

This patchset adds support for a LinuxDVB demux driver for the
ST STB stih407 family SoC's. It is what I spoke to you about
when we met at ELC-E in Dusseldorf last year.

One advantage of having a upstream demux driver implementation for ST
SoC's is that it will be easier to add support and maintain existing support
for the ST demodulators and tuners which are upstream. As this driver allows
ST NIM daughter boards (which typically have a tuner/demod combination)
to be used with a upstream kernel.

This initial patchset adds support for the following demux HW called c8sectpfe: -
* Input Block HW
* HW PID filtering
* memdma engine (moves TS from sram to RAM)

The driver creates one Linux DVB adapter, and each tsin channel which is
described in DT has a set of LDVB dev nodes.

Currently the driver supports 7 tsin channels. This driver has been tested with
the stih407-b2120 board and stih410-b2120 reference design boards, and currently
we support the following DVB fronend cards:
 - STMicroelectronics DVB-T B2100A (STV0367 + TDA18212)
 - STMicroelectronics DVB-T STV0367 PLL board (STV0367 + DTT7546X)
 - STMicroelectronics DVB-S/S2 STV0903 + STV6110 + LNBP24 board

There are also some small changes to dvb-pll.c and stv0367.c to get these
NIM daughterboards working correctly.

regards,

Peter.

p.s. The series which adds pinctrl config used by this driver is
https://lkml.org/lkml/2015/6/10/377

Peter Griffin (12):
  ARM: DT: STi: stihxxx-b2120: Add pulse-width properties to ssc2 & ssc3
  [media] dvb-pll: Add support for THOMSON DTT7546X tuner.
  [media] stv0367: Refine i2c error trace to include i2c address
  [media] stv0367: Add support for 16Mhz reference clock
  [media] tsin: c8sectpfe: Add DT bindings documentation for c8sectpfe
    driver.
  ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node.
  [media] tsin: c8sectpfe: STiH407/10 Linux DVB demux support
  [media] tsin: c8sectpfe: Add LDVB helper functions.
  [media] tsin: c8sectpfe: Add support for various ST NIM cards.
  [media] tsin: c8sectpfe: Add c8sectpfe debugfs support.
  [media] tsin: c8sectpfe: Add Kconfig and Makefile for the driver.
  MAINTAINERS: Add c8sectpfe driver directory to STi section

 .../bindings/media/stih407-c8sectpfe.txt           |   90 ++
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |   60 +-
 drivers/media/Kconfig                              |    1 +
 drivers/media/Makefile                             |    1 +
 drivers/media/dvb-frontends/dvb-pll.c              |   74 +-
 drivers/media/dvb-frontends/dvb-pll.h              |    1 +
 drivers/media/dvb-frontends/stv0367.c              |   17 +-
 drivers/media/tsin/c8sectpfe/Kconfig               |   26 +
 drivers/media/tsin/c8sectpfe/Makefile              |   11 +
 drivers/media/tsin/c8sectpfe/c8sectpfe-common.c    |  266 +++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-common.h    |   66 ++
 drivers/media/tsin/c8sectpfe/c8sectpfe-core.c      | 1105 ++++++++++++++++++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-core.h      |  288 +++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-debugfs.c   |  271 +++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-debugfs.h   |   26 +
 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c       |  296 ++++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h       |   20 +
 include/dt-bindings/media/c8sectpfe.h              |   14 +
 19 files changed, 2617 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
 create mode 100644 drivers/media/tsin/c8sectpfe/Kconfig
 create mode 100644 drivers/media/tsin/c8sectpfe/Makefile
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-common.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-common.h
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-core.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-core.h
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-debugfs.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-debugfs.h
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-dvb.h
 create mode 100644 include/dt-bindings/media/c8sectpfe.h

-- 
1.9.1

