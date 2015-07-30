Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35931 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbbG3RJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:09:06 -0400
Received: by wicgb10 with SMTP id gb10so563437wic.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 10:09:05 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	m.krufky@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, joe@perches.com
Subject: [PATCH v2 00/11]  Add c8sectpfe LinuxDVB demux driver
Date: Thu, 30 Jul 2015 18:08:50 +0100
Message-Id: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maruro and linux-media folks,

This patchset adds support for a LinuxDVB demux driver for the
ST STB stih407 family SoC's. Mauro - it is what I spoke to you about
when we met at ELC-E in Dusseldorf last year.

One big advantage of having a upstream demux driver for ST
SoC's is that it will be easier to maintain support for the ST demodulators
and tuners which are already upstream (and also add support for newer demods
such as the stv6120 and stv910). As this driver allows ST NIM reference boards
(which typically have a tuner/demod combination on)
to be used easily with a upstream kernel on ST STB reference designs.

Up until now it is not easy to test stv0367, stv6110 stv90x.c demod and tuner
drivers which are supported upstream with ST STB reference hardware,
and as such makes helping support these devices difficult.

It also furthers the aim of having a completely open source A/V pipeline for STi
chipsets. A upstream DRM driver is already merged for STi SoC's. ALSA SoC is
current under review, and when this driver is accepted we would have a totaly
open source frontend support (tuner->demod->demux) :-)

This initial patchset adds support for the following demux HW called c8sectpfe: -
* Input Block HW
* HW PID filtering
* memdma engine (moves TS from input block sram to RAM)

The driver creates one Linux DVB adapter, and each tsin channel which is
described in DT has a set of LDVB device nodes.

Currently the driver supports 7 tsin channels. This driver has been tested with
the stih407-b2120 board and stih410-b2120 reference design boards, and currently
we support the following DVB fronend cards:
 - STMicroelectronics DVB-T B2100A (STV0367 + TDA18212)
 - STMicroelectronics DVB-S/S2 STV0903 + STV6110 + LNBP24 board

This patchset also includes some small changes to stv0367.c to get
the upstream driver working correctly with the ST NIM reference board. Also Joe
Perches dvb-pll patch is included with this series.

regards,

Peter.

Changes since v1:
- Rebase patches on v4.2-rc3 (Peter)
- Rework firmware loading mechanism to be async (Peter)
- Rework ELF firmware loading code (Peter)
- Add support for 8192 special PID (Peter)
- Fixup Kconfig depedencies for c8sectpfe (Peter)
- Fix typo in Makefile rule for c8sectpfe-debugfs (Paul)

- Include Joe Perches dvb-pll patch as requested by (Mauro)
- Remove BUG_ON from various places (Mauro)
- Drop THOMSON DTT7546X tuner support (rework based on tuner-simple later) (Mike)
- Move driver to drivers/media/platform/sti/c8sectpfe/
- usleep_range instead of msleep (Mauro)

Joe Perches (1):
  dvb-pll: Convert struct dvb_pll_desc uses to const.

Peter Griffin (10):
  [media] stv0367: Refine i2c error trace to include i2c address
  [media] stv0367: Add support for 16Mhz reference clock
  [media] c8sectpfe: Add DT bindings documentation for c8sectpfe driver.
  ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node.
  [media] c8sectpfe: STiH407/10 Linux DVB demux support
  [media] c8sectpfe: Add LDVB helper functions.
  [media] c8sectpfe: Add support for various ST NIM cards.
  [media] c8sectpfe: Add c8sectpfe debugfs support.
  [media] c8sectpfe: Add Kconfig and Makefile for the driver.
  MAINTAINERS: Add c8sectpfe driver directory to STi section

 .../bindings/media/stih407-c8sectpfe.txt           |   89 ++
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |   38 +
 drivers/media/dvb-frontends/dvb-pll.c              |   50 +-
 drivers/media/dvb-frontends/stv0367.c              |   17 +-
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/sti/c8sectpfe/Kconfig       |   28 +
 drivers/media/platform/sti/c8sectpfe/Makefile      |    9 +
 .../platform/sti/c8sectpfe/c8sectpfe-common.c      |  265 +++++
 .../platform/sti/c8sectpfe/c8sectpfe-common.h      |   64 +
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  | 1235 ++++++++++++++++++++
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.h  |  288 +++++
 .../platform/sti/c8sectpfe/c8sectpfe-debugfs.c     |  271 +++++
 .../platform/sti/c8sectpfe/c8sectpfe-debugfs.h     |   26 +
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.c   |  244 ++++
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.h   |   20 +
 include/dt-bindings/media/c8sectpfe.h              |   12 +
 18 files changed, 2632 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Kconfig
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Makefile
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h
 create mode 100644 include/dt-bindings/media/c8sectpfe.h

-- 
1.9.1

