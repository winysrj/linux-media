Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60088 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab0JQQza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 12:55:30 -0400
Received: by ewy20 with SMTP id 20so175724ewy.19
        for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 09:55:29 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF card V.2
Date: Sun, 17 Oct 2010 19:55:18 +0300
Cc: Abylai Ospan <aospan@netup.ru>,
	Mauro Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010171955.18806.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc. 
        http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF

Version 2,  Altera FPGA firmware download module reworked.

Features:

PCI-e x1  
Supports two DVB-T/DVB-C transponders simultaneously
Supports two analog audio/video channels simultaneously
Independent descrambling of two transponders
Hardware PID filtering

Components:

Conexant CX23885 
STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip receiver
Xceive XC5000 silicon TV tuner
Altera FPGA for Common Interafce

The following changes since commit 1c8c51f7413ec522c7b729c8ebc5ce815fb7d4a8:

  V4L/DVB: drivers/media/IR/ene_ir.c: fix NULL dereference (2010-10-17 09:50:42 -0200)

are available in the git repository at:
  http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree-2

Abylay Ospan (6):
      cx23885: Altera FPGA CI interface reworked.
      stv0367: change default value for AGC register.
      stv0367: implement uncorrected blocks counter.
      cx23885, cimax2.c: Fix case of two CAM insertion irq.
      Fix CI code for NetUP Dual  DVB-T/C CI RF card
      Force xc5000 firmware loading for NetUP Dual  DVB-T/C CI RF card

Igor M. Liplianin (14):
      Altera FPGA firmware download module.
      Altera FPGA based CI driver module.
      Support for stv0367 multi-standard demodulator.
      xc5000: add support for DVB-C tuning.
      Initial commit to support NetUP Dual DVB-T/C CI RF card.
      cx23885: implement tuner_bus parameter for cx23885_board structure.
      cx23885: implement num_fds_portb, num_fds_portc parameters for cx23885_board structure.
      stv0367: Fix potential divide error
      cx23885: remove duplicate set interrupt mask
      stv0367: coding style corrections
      cx25840: Fix subdev registration and typo in cx25840-core.c
      cx23885: 0xe becomes 0xc again for NetUP Dual DVB-S2
      cx23885: disable MSI for NetUP cards, otherwise CI is not working
      cx23885, altera-ci: enable all PID's less than 0x20 in hardware PID filter.

 drivers/media/common/tuners/xc5000.c        |   18 +
 drivers/media/dvb/frontends/Kconfig         |    7 +
 drivers/media/dvb/frontends/Makefile        |    1 +
 drivers/media/dvb/frontends/stv0367.c       | 3419 +++++++++++++++++++++++++
 drivers/media/dvb/frontends/stv0367.h       |   62 +
 drivers/media/dvb/frontends/stv0367_priv.h  |  211 ++
 drivers/media/dvb/frontends/stv0367_regs.h  | 3614 +++++++++++++++++++++++++++
 drivers/media/video/cx23885/Kconfig         |   12 +-
 drivers/media/video/cx23885/Makefile        |    1 +
 drivers/media/video/cx23885/altera-ci.c     |  841 +++++++
 drivers/media/video/cx23885/altera-ci.h     |  102 +
 drivers/media/video/cx23885/cimax2.c        |   24 +-
 drivers/media/video/cx23885/cx23885-cards.c |  116 +-
 drivers/media/video/cx23885/cx23885-core.c  |   35 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |  175 ++-
 drivers/media/video/cx23885/cx23885-reg.h   |    1 +
 drivers/media/video/cx23885/cx23885-video.c |    7 +-
 drivers/media/video/cx23885/cx23885.h       |    7 +-
 drivers/media/video/cx25840/cx25840-core.c  |    4 +-
 drivers/misc/Kconfig                        |    1 +
 drivers/misc/Makefile                       |    1 +
 drivers/misc/stapl-altera/Kconfig           |    8 +
 drivers/misc/stapl-altera/Makefile          |    3 +
 drivers/misc/stapl-altera/altera.c          | 2603 +++++++++++++++++++
 drivers/misc/stapl-altera/jbicomp.c         |  163 ++
 drivers/misc/stapl-altera/jbiexprt.h        |   32 +
 drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
 drivers/misc/stapl-altera/jbijtag.h         |   83 +
 drivers/misc/stapl-altera/jbistub.c         |   70 +
 include/misc/altera.h                       |   49 +
 30 files changed, 12674 insertions(+), 34 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/stv0367.c
 create mode 100644 drivers/media/dvb/frontends/stv0367.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h
 create mode 100644 drivers/media/video/cx23885/altera-ci.c
 create mode 100644 drivers/media/video/cx23885/altera-ci.h
 create mode 100644 drivers/misc/stapl-altera/Kconfig
 create mode 100644 drivers/misc/stapl-altera/Makefile
 create mode 100644 drivers/misc/stapl-altera/altera.c
 create mode 100644 drivers/misc/stapl-altera/jbicomp.c
 create mode 100644 drivers/misc/stapl-altera/jbiexprt.h
 create mode 100644 drivers/misc/stapl-altera/jbijtag.c
 create mode 100644 drivers/misc/stapl-altera/jbijtag.h
 create mode 100644 drivers/misc/stapl-altera/jbistub.c
 create mode 100644 include/misc/altera.h
