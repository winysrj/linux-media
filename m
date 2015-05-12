Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:55785 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbbELTyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 15:54:49 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org
Subject: v4.1-rcX regression in v4l2 build
Date: Tue, 12 May 2015 21:46:27 +0200
Message-ID: <87d225mve4.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Today I noticed the mioa701 build is broken on v4.1-rcX series. It was working
in v4.0.

The build error I get is :
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
drivers/built-in.o: In function `v4l2_clk_set_rate':
/home/rj/mio_linux/kernel/drivers/media/v4l2-core/v4l2-clk.c:196: undefined reference to `clk_round_rate'
Makefile:932: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
make: Target '_all' not remade because of errors.

I have no idea what changed. Do you have a clue ?

Cheers.

-- 
Robert

PS: A small extract of my .config
rj@belgarion:~/mio_linux/kernel$ grep CLK .config
CONFIG_HAVE_CLK=y
CONFIG_PM_CLK=y
# CONFIG_MMC_CLKGATE is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_CLKSRC_OF=y
CONFIG_CLKSRC_MMIO=y
CONFIG_CLKSRC_PXA=y
rj@belgarion:~/mio_linux/kernel$ grep V4L .config
CONFIG_VIDEO_V4L2=y
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
CONFIG_DVB_AU8522_V4L=m
