Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40701 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab0JKTP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 15:15:56 -0400
Received: by ewy20 with SMTP id 20so760658ewy.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 12:15:55 -0700 (PDT)
Subject: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF card
To: linux-media@vger.kernel.org, Mauro Chehab <mchehab@infradead.org>,
	Abylai Ospan <aospan@netup.ru>
From: "Igor M. Liplianin" <liplianin@me.by>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Steven Toth <stoth@linuxtv.org>
Date: Mon, 11 Oct 2010 22:15:54 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010112215.54720.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc. 
	http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF

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

The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:

  V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102 (2010-10-01 
18:14:35 -0300)

are available in the git repository at:
  http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree

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
 drivers/misc/stapl-altera/altera.c          | 2739 ++++++++++++++++++++
 drivers/misc/stapl-altera/jbicomp.c         |  163 ++
 drivers/misc/stapl-altera/jbiexprt.h        |   94 +
 drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
 drivers/misc/stapl-altera/jbijtag.h         |   83 +
 drivers/misc/stapl-altera/jbistub.c         |   70 +
 include/misc/altera.h                       |   49 +
 30 files changed, 12872 insertions(+), 34 deletions(-)
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
