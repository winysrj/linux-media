Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50918 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaENV5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 17:57:44 -0400
Received: by mail-lb0-f181.google.com with SMTP id u14so140738lbd.12
        for <linux-media@vger.kernel.org>; Wed, 14 May 2014 14:57:42 -0700 (PDT)
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
	devicetree@vger.kernel.org, galak@codeaurora.org,
	grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
	james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
	maxime.ripard@free-electrons.com, pawel.moll@arm.com,
	rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
	srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v7 0/3] ARM: sunxi: Add support for consumer infrared devices
Date: Thu, 15 May 2014 03:56:39 +0600
Message-Id: <1400104602-16431-1-git-send-email-bay@hackerdom.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces Consumer IR(CIR) support for sunxi boards.

This is based on Alexsey Shestacov's work based on the original driver 
supplied by Allwinner.

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>

---
Changes since version 1: 
 - Fix timer memory leaks 
 - Fix race condition when driver unloads while interrupt handler is active
 - Support Cubieboard 2(need testing)

Changes since version 2:
- More reliable keydown events
- Documentation fixes
- Rename registers accurding to A20 user manual
- Remove some includes, order includes alphabetically
- Use BIT macro
- Typo fixes

Changes since version 3:
- Split the patch on smaller parts
- More documentation fixes
- Add clock-names in DT
- Use devm_clk_get function to get the clocks
- Removed gpios property from ir's DT
- Changed compatible from allwinner,sunxi-ir to allwinner,sun7i-a20-ir in DT
- Use spin_lock_irq instead spin_lock_irqsave in interrupt handler
- Add myself in the copyright ;)
- Coding style and indentation fixes

Changes since version 4:
- Try to fix indentation errors by sending patches with git send-mail

Changes since version 5:
- More indentation fixes
- Make patches pass checkpatch with --strict option
- Replaced magic numbers with defines(patch by Priit Laes)
- Fixed oops on loading(patch by Hans de Goede)

Changes since version 6:
- Removed constants from code
- Better errrors handling on loading
- Renamed sunxi-ir.c to sunxi-cir.c
- Changed description of second commit
- Order entries in dts and dtsi by register address
- Code style fixes


Alexander Bersenev (3):
  ARM: sunxi: Add documentation for sunxi consumer infrared devices
  [media] rc: add sunxi-ir driver
  ARM: sunxi: Add IR controller support in DT on A20

 .../devicetree/bindings/media/sunxi-ir.txt         |  23 ++
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |   6 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   6 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  32 ++
 drivers/media/rc/Kconfig                           |  10 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/sunxi-cir.c                       | 334 +++++++++++++++++++++
 7 files changed, 412 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
 create mode 100644 drivers/media/rc/sunxi-cir.c

-- 
1.9.3
