Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab0CKN1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 08:27:04 -0500
Date: Thu, 11 Mar 2010 10:26:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Dmitri Belimov <d.belimov@gmail.com>
Subject: [PATCH 0/7] tm6000: Remove register magic
Message-ID: <20100311102646.01db8e13@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Dmitri, changeset 2fe1b227458f7a411ab3b5959169a0de6703b60a added 
aliases for most of tm6000 registers. Yet, the driver still uses the
old magic numbers. This set of patches replaces the magic numbers with
the help of some simple perl scripts.

After it, just two registers at req 07 will have an alias missing 
(registers 0xeb and 0xee):

$ grep REQ_0[567] drivers/staging/tm6000/*.c
drivers/staging/tm6000/tm6000-core.c:           tm6000_set_reg(dev, REQ_07_SET_GET_AVREG, 0xeb, 0x60);
drivers/staging/tm6000/tm6000-core.c:           tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0xd8);
drivers/staging/tm6000/tm6000-core.c:           tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0x00eb, 0x08);
drivers/staging/tm6000/tm6000-core.c:   { REQ_07_SET_GET_AVREG,  0xeb, 0x64 }, /* 48000 bits/sample, external input */
drivers/staging/tm6000/tm6000-core.c:   { REQ_07_SET_GET_AVREG,  0xee, 0xc2 },
drivers/staging/tm6000/tm6000-core.c:   val=tm6000_get_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, 0x0);
drivers/staging/tm6000/tm6000-core.c:   val=tm6000_set_reg (dev, REQ_07_SET_GET_AVREG, 0xeb, val);

This series introduces no changes at tm6000 behavior, but it will likely 
help people to improve/maintain the driver.

It would be good to add alias names also for the above registers.

Mauro Carvalho Chehab (7):
  V4L/DVB: tm6000: Replace all Req 7 group of regs with another naming
    convention
  V4L/DVB: tm6000: Replace all Req 8 group of regs with another naming
    convention
  V4L/DVB: tm6000: Add request at Req07/Req08 register definitions
  V4L/DVB: tm6000: Replace all magic values by a register alias
  V4L/DVB: tm6000: Replace naming convention for registers of req 05
    group
  V4L/DVB: tm6000: add request to registers of the group 05
  V4L/DVB: tm6000: replace occurences of req05 magic by a naming alias

 drivers/staging/tm6000/tm6000-alsa.c  |   12 +-
 drivers/staging/tm6000/tm6000-core.c  |  356 +++++-----
 drivers/staging/tm6000/tm6000-regs.h  |  862 ++++++++++++------------
 drivers/staging/tm6000/tm6000-stds.c  | 1156 ++++++++++++++++----------------
 drivers/staging/tm6000/tm6000-video.c |   16 +-
 5 files changed, 1201 insertions(+), 1201 deletions(-)

