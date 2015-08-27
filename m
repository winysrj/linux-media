Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34420 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbH0MaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 08:30:09 -0400
Received: by widdq5 with SMTP id dq5so76443144wid.1
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 05:30:08 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 0/5] [media] c8sectpfe: Various fixups
Date: Thu, 27 Aug 2015 13:29:30 +0100
Message-Id: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series includes a couple of fixes for the c8sectpfe Linux dvb driver.

One was caused by omitting a patch from the original c8sectpfe series which
defined the ssc2 and ssc3 dt nodes, which was then used by the later DT patch.

This patch is included, along with the original patch which you reverted.

Also Valentin Rothberg spotted LIBELF32 Kconfig symbol I was selecting in the
Kconfig, this isn't required upstream and is left over legacy so I've removed
it.

Sorry for the delay in sending these fixes, I've been on holiday for the last
3 weeks.

Changes since v1:
 - Various formating patches to DT node
 - Update to reset-gpios
 - Use GPIO_ACTIVE_HIGH, GIC_SPI and IRQ_TYPE_NONE defines

kind regards,

Peter.

Peter Griffin (5):
  ARM: DT: STi: stihxxx-b2120: Add pulse-width properties to ssc2 & ssc3
  ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node.
  [media] c8sectpfe: Remove select on undefined LIBELF_32
  [media] c8sectpfe: Update binding to reset-gpios
  [media] c8sectpfe: Update DT binding doc with some minor fixes

 .../bindings/media/stih407-c8sectpfe.txt           | 22 +++++------
 arch/arm/boot/dts/stihxxx-b2120.dtsi               | 44 +++++++++++++++++++++-
 drivers/media/platform/sti/c8sectpfe/Kconfig       |  1 -
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  2 +-
 4 files changed, 53 insertions(+), 16 deletions(-)

-- 
1.9.1

