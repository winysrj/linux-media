Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0AQOWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 09:22:01 -0500
Message-ID: <4B531CDC.8020400@redhat.com>
Date: Sun, 17 Jan 2010 12:21:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.33] DVB Mantis driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git mantis

For the DVB mantis driver. This is a new driver that add support for the DVB devices
based on ST mantis chips. This design is becoming very popular and the driver were
already out of the kernel tree for some time.

As this driver doesn't touch on the existing code, were already confirmed to work
by several people, and is being on linux-next since December, I'm hoping that you'll
accept its late submission for 2.6.33.

Cheers,
Mauro.

---

 drivers/media/dvb/Kconfig                  |    4 +
 drivers/media/dvb/Makefile                 |   14 +-
 drivers/media/dvb/frontends/Kconfig        |   19 +
 drivers/media/dvb/frontends/Makefile       |    2 +
 drivers/media/dvb/frontends/mb86a16.c      | 1878 ++++++++++++++++++++++++++++
 drivers/media/dvb/frontends/mb86a16.h      |   52 +
 drivers/media/dvb/frontends/mb86a16_priv.h |  151 +++
 drivers/media/dvb/frontends/tda10021.c     |    4 +
 drivers/media/dvb/frontends/tda665x.c      |  257 ++++
 drivers/media/dvb/frontends/tda665x.h      |   52 +
 drivers/media/dvb/mantis/Kconfig           |   32 +
 drivers/media/dvb/mantis/Makefile          |   28 +
 drivers/media/dvb/mantis/hopper_cards.c    |  275 ++++
 drivers/media/dvb/mantis/hopper_vp3028.c   |   88 ++
 drivers/media/dvb/mantis/hopper_vp3028.h   |   30 +
 drivers/media/dvb/mantis/mantis_ca.c       |  207 +++
 drivers/media/dvb/mantis/mantis_ca.h       |   27 +
 drivers/media/dvb/mantis/mantis_cards.c    |  305 +++++
 drivers/media/dvb/mantis/mantis_common.h   |  179 +++
 drivers/media/dvb/mantis/mantis_core.c     |  238 ++++
 drivers/media/dvb/mantis/mantis_core.h     |   57 +
 drivers/media/dvb/mantis/mantis_dma.c      |  256 ++++
 drivers/media/dvb/mantis/mantis_dma.h      |   30 +
 drivers/media/dvb/mantis/mantis_dvb.c      |  296 +++++
 drivers/media/dvb/mantis/mantis_dvb.h      |   35 +
 drivers/media/dvb/mantis/mantis_evm.c      |  117 ++
 drivers/media/dvb/mantis/mantis_hif.c      |  240 ++++
 drivers/media/dvb/mantis/mantis_hif.h      |   29 +
 drivers/media/dvb/mantis/mantis_i2c.c      |  267 ++++
 drivers/media/dvb/mantis/mantis_i2c.h      |   30 +
 drivers/media/dvb/mantis/mantis_input.c    |  148 +++
 drivers/media/dvb/mantis/mantis_ioc.c      |  130 ++
 drivers/media/dvb/mantis/mantis_ioc.h      |   51 +
 drivers/media/dvb/mantis/mantis_link.h     |   83 ++
 drivers/media/dvb/mantis/mantis_pci.c      |  177 +++
 drivers/media/dvb/mantis/mantis_pci.h      |   27 +
 drivers/media/dvb/mantis/mantis_pcmcia.c   |  120 ++
 drivers/media/dvb/mantis/mantis_reg.h      |  197 +++
 drivers/media/dvb/mantis/mantis_uart.c     |  186 +++
 drivers/media/dvb/mantis/mantis_uart.h     |   58 +
 drivers/media/dvb/mantis/mantis_vp1033.c   |  212 ++++
 drivers/media/dvb/mantis/mantis_vp1033.h   |   30 +
 drivers/media/dvb/mantis/mantis_vp1034.c   |  119 ++
 drivers/media/dvb/mantis/mantis_vp1034.h   |   33 +
 drivers/media/dvb/mantis/mantis_vp1041.c   |  358 ++++++
 drivers/media/dvb/mantis/mantis_vp1041.h   |   33 +
 drivers/media/dvb/mantis/mantis_vp2033.c   |  187 +++
 drivers/media/dvb/mantis/mantis_vp2033.h   |   30 +
 drivers/media/dvb/mantis/mantis_vp2040.c   |  186 +++
 drivers/media/dvb/mantis/mantis_vp2040.h   |   32 +
 drivers/media/dvb/mantis/mantis_vp3028.c   |   38 +
 drivers/media/dvb/mantis/mantis_vp3028.h   |   33 +
 drivers/media/dvb/mantis/mantis_vp3030.c   |  105 ++
 drivers/media/dvb/mantis/mantis_vp3030.h   |   30 +
 54 files changed, 7801 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/mb86a16.c
 create mode 100644 drivers/media/dvb/frontends/mb86a16.h
 create mode 100644 drivers/media/dvb/frontends/mb86a16_priv.h
 create mode 100644 drivers/media/dvb/frontends/tda665x.c
 create mode 100644 drivers/media/dvb/frontends/tda665x.h
 create mode 100644 drivers/media/dvb/mantis/Kconfig
 create mode 100644 drivers/media/dvb/mantis/Makefile
 create mode 100644 drivers/media/dvb/mantis/hopper_cards.c
 create mode 100644 drivers/media/dvb/mantis/hopper_vp3028.c
 create mode 100644 drivers/media/dvb/mantis/hopper_vp3028.h
 create mode 100644 drivers/media/dvb/mantis/mantis_ca.c
 create mode 100644 drivers/media/dvb/mantis/mantis_ca.h
 create mode 100644 drivers/media/dvb/mantis/mantis_cards.c
 create mode 100644 drivers/media/dvb/mantis/mantis_common.h
 create mode 100644 drivers/media/dvb/mantis/mantis_core.c
 create mode 100644 drivers/media/dvb/mantis/mantis_core.h
 create mode 100644 drivers/media/dvb/mantis/mantis_dma.c
 create mode 100644 drivers/media/dvb/mantis/mantis_dma.h
 create mode 100644 drivers/media/dvb/mantis/mantis_dvb.c
 create mode 100644 drivers/media/dvb/mantis/mantis_dvb.h
 create mode 100644 drivers/media/dvb/mantis/mantis_evm.c
 create mode 100644 drivers/media/dvb/mantis/mantis_hif.c
 create mode 100644 drivers/media/dvb/mantis/mantis_hif.h
 create mode 100644 drivers/media/dvb/mantis/mantis_i2c.c
 create mode 100644 drivers/media/dvb/mantis/mantis_i2c.h
 create mode 100644 drivers/media/dvb/mantis/mantis_input.c
 create mode 100644 drivers/media/dvb/mantis/mantis_ioc.c
 create mode 100644 drivers/media/dvb/mantis/mantis_ioc.h
 create mode 100644 drivers/media/dvb/mantis/mantis_link.h
 create mode 100644 drivers/media/dvb/mantis/mantis_pci.c
 create mode 100644 drivers/media/dvb/mantis/mantis_pci.h
 create mode 100644 drivers/media/dvb/mantis/mantis_pcmcia.c
 create mode 100644 drivers/media/dvb/mantis/mantis_reg.h
 create mode 100644 drivers/media/dvb/mantis/mantis_uart.c
 create mode 100644 drivers/media/dvb/mantis/mantis_uart.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1033.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1033.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1034.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1034.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1041.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp1041.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp2033.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp2033.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp2040.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp2040.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp3028.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp3028.h
 create mode 100644 drivers/media/dvb/mantis/mantis_vp3030.c
 create mode 100644 drivers/media/dvb/mantis/mantis_vp3030.h

David Woodhouse (1):
      V4L/DVB (13716): [Mantis] Bug: incorrect byte swap

Magnus Horlin (1):
      V4L/DVB (13748): [Mantis/VP-2040] Add support for VP-2040 (TDA10023 frontend based)

Manu Abraham (101):
      V4L/DVB (13699): [Mantis, MB86A16] Initial checkin: Mantis, MB86A16
      V4L/DVB (13700): [MB86A16] Need a bit of settling time
      V4L/DVB (13701): [MB86A16] Reduce Carrier Recovery range to 3Mhz
      V4L/DVB (13702): [MB86A16] need to wait a bit more than the computed time for a Factor of safety
      V4L/DVB (13703): [MB86A16] Fix wrong message printed out
      V4L/DVB (13704): [MB86A16] FIX: Don't loop again, if we have SYNC
      V4L/DVB (13705): [Mantis] FIX: Do not return IRQ_HANDLED in the unlikely case
      V4L/DVB (13706): [MB86A16] Overhaul
      V4L/DVB (13707): [Mantis] Whitespace cleanup
      V4L/DVB (13708): [Mantis] Remove some dead code
      V4L/DVB (13709): [Mantis/VP-1034] Switch 13/18v for the VP-1034 properly
      V4L/DVB (13710): [Mantis] FIX: Use swfilter (188/204) accordingly
      V4L/DVB (13712): [Mantis] Add locking for concurrent access
      V4L/DVB (13714): [MB86A16] FIX/Code simplification: use hwconfig->ts_size instead of ts_size
      V4L/DVB (13715): [Mantis] Kernel I2C changes: use PCI parent device
      V4L/DVB (13717): [MB86A16] Statistics Updates
      V4L/DVB (13719): [Mantis/VP-2033] Initial test switch to the tda10021, from the cu1216
      V4L/DVB (13720): [Mantis/Terratec Cinergy C] Add support for the Terratec Cinergy C PCI
      V4L/DVB (13721): [Mantis] Bug! Before bailing out, Unlock
      V4L/DVB (13722): [Mantis] Revert 13560
      V4L/DVB (13723): [Mantis/VP-2040, Terratec Cinergy C] Add support for the Cinergy C, VP-2040 clone
      V4L/DVB (13724): [Mantis/VP-1041] Initial support for Mantis VP-1041
      V4L/DVB (13725): [Mantis/VP-1041] Revert to old register initialization parameters, for now.
      V4L/DVB (13726): [Mantis/Skystar HD2] Add support for the Technisat Skystar HD2
      V4L/DVB (13727): [Mantis/VP-1041] Bugfix: Sigh! Don't look for the STOP bit
      V4L/DVB (13728): [Mantis] Add in some Host Interface definitions
      V4L/DVB (13729): [Mantis] Add in a license header
      V4L/DVB (13730): [Mantis] Add in some UART definitions
      V4L/DVB (13731): [Mantis] Add in a license header
      V4L/DVB (13732): [Mantis] Add in some Link Layer definitions
      V4L/DVB (13733): [Mantis] Start with the PCMCIA interface
      V4L/DVB (13734): [Mantis] Initial go at an Event Manager
      V4L/DVB (13735): [Mantis] Implement the Event Manager tasklet
      V4L/DVB (13736): [Mantis] Implement CAM Plug IN and Unplug events
      V4L/DVB (13737): [Mantis] Register the CA device, dummy functions for now
      V4L/DVB (13738): [Mantis] Enable IRQ0 events
      V4L/DVB (13739): [Mantis] Event Manager: Handle Masked events only
      V4L/DVB (13740): [Mantis] Schedule the work instead of handling the task directly
      V4L/DVB (13741): [Mantis] Implement HIF Mem Read/Write operations
      V4L/DVB (13742): [Mantis] Implement PCMCIA I/O Rd/Wr operations
      V4L/DVB (13743): [Mantis CA] Use DVB_CA Tuple parser
      V4L/DVB (13744): [Mantis CA] Use Module status to signal Slot events
      V4L/DVB (13745): [Mantis CA] Add some debug statements
      V4L/DVB (13746): [Mantis CA] Bug: Remove duplicated symbol
      V4L/DVB (13749): [Mantis CA] CA_SLAVE: Do not change Slave Configuration setup
      V4L/DVB (13750): [Mantis] GPIO_CONTROL: Cache a given GPIO Bit Setup for a given event
      V4L/DVB (13751): [Mantis] GPIO_CONTROL: Do not toggle GPIO CW's on HIF operations
      V4L/DVB (13752): [Mantis CA] CAM_CONTROL: All CAM control operations now handled by the worker thread
      V4L/DVB (13753): [Mantis CA] SLOT_CONTROL: Implement Slot RESET
      V4L/DVB (13754): [Mantis] CAM_CONTROL: Implement TS control
      V4L/DVB (13755): [Mantis CA] CAM_CONTROL: Use appropriate flags
      V4L/DVB (13756): [Mantis CA] CAM_CONTROL: Use CAMCHANGE_IRQ events
      V4L/DVB (13757): [Mantis CA] CAM_CONTROL: Use FRDA_IRQ Events
      V4L/DVB (13758): [Mantis CA] CAM_CONTROL: Use CAMREADY_IRQ event
      V4L/DVB (13759): [Mantis] HIF I/O: Use the LSB octet only
      V4L/DVB (13761): [Mantis] HIF I/O: Temporary workaround, use SBUF_OPDONE flag instead
      V4L/DVB (13762): [Mantis CA] CA_MODULE: Look for the module status on driver unload as well
      V4L/DVB (13763): [Mantis] HIF I/O: trim delays a bit appropriately
      V4L/DVB (13764): [Mantis CA] SLOT: Add some debug status
      V4L/DVB (13765): [Mantis] HIF I/O: Add some debug statements
      V4L/DVB (13767): [Mantis/VP-1041] Bug: Add in missing Master clock settings
      V4L/DVB (13768): [Mantis] Enable WRACK
      V4L/DVB (13769): [Mantis] Smart Buffer Burst Read Ready cannot flag FR/DA Irq
      V4L/DVB (13770): [Mantis] Bug Do not trigger FR/DA IRQ from SBUF OPDONE
      V4L/DVB (13771): [Mantis] Reset Flags at the earliest possible
      V4L/DVB (13772): [Mantis] Do not enable Common Memory Access
      V4L/DVB (13773): [Mantis] Enable all interrupts
      V4L/DVB (13775): [Mantis] Remove unnecessary job queues
      V4L/DVB (13776): [Mantis] Use a simple timeout instead, interruptible
      V4L/DVB (13777): [Mantis] Use a Write wait queue for Write events
      V4L/DVB (13778): [Mantis] Wr ACK is already handled in the fast path,
      V4L/DVB (13779): [Mantis] Missing wakeup for write queue
      V4L/DVB (13781): [Mantis CA] Bug: Fix wrong usage of HIFRDWRN
      V4L/DVB (13782): [Mantis] Temporarily disable FRDA irq
      V4L/DVB (13784): [Mantis] Use PCI API instead of hardcoded length
      V4L/DVB (13785): [Mantis] Do not disable IRQ's while being invoked
      V4L/DVB (13786): [Mantis] Bug: HIF bits already shifted ..
      V4L/DVB (13787): [Mantis] Fix build
      V4L/DVB (13788): [Mantis CA] use a lock for the relevant CI Read/Write operations
      V4L/DVB (13789): [Mantis CA] Initialize the mutex
      V4L/DVB (13790): [Mantis] Relocate queue initialization
      V4L/DVB (13794): [Mantis/VP-3028] Initial go at Serial interface implementation, add support for VP-3028
      V4L/DVB (13795): [Mantis/Hopper] Code overhaul, add Hopper devices into the PCI ID list
      V4L/DVB (13796): [Mantis] Add missing file in previous commit
      V4L/DVB (13797): [Mantis/Hopper/TDA665x] Large overhaul,
      V4L/DVB (13798): [Mantis] Enable power for all cards, use byte mode only on relevant devices
      V4L/DVB (13799): [Mantis] Unregister frontend
      V4L/DVB (13800): [Mantis] I2C optimization. Required delay is much lesser than 1mS.
      V4L/DVB (13801): [MB86A16] Use the search callback
      V4L/DVB (13802): [Mantis/Hopper] Fix all build related warnings
      V4L/DVB (13803): Remove unused dependency on CU1216
      V4L/DVB (13804): Remove unused I2C Adapter ID
      V4L/DVB (13805): Fix: Unregister the frontend before detaching
      V4L/DVB (13806): Register and Initialize Remote control
      V4L/DVB (13807): Fix: Free device in the device registration failure case
      V4L/DVB (13809): Fix Checkpatch violations
      V4L/DVB (13810): [MB86A16] Use DVB_* macros
      V4L/DVB (13811): [MB86A16] Update Copyright header
      V4L/DVB (13812): [Mantis/Hopper] Update Copyright header
      V4L/DVB (13808): [Mantis/Hopper] Build update for Mantis/Hopper based cards
      V4L/DVB (13851): Fix Input dependency for Mantis

Marko Ristola (2):
      V4L/DVB (13711): [Mantis] FIX: Do nor toggle GPIF status
      V4L/DVB (13718): [Mantis] Use gpio_set_bits to turn OFF the bits as well

Marko Viitamaki (1):
      V4L/DVB (13783): [Mantis/Technisat Cablestar HD2] Add support for the Technisat Cablestar HD2

Mauro Carvalho Chehab (3):
      V4L/DVB(13808a): mantis: convert it to the new ir-core register/unregister functions
      V4L/DVB (13808b): mantis: replace DMA_nnBIT_MASK to DMA_BIT_MASK(32)
      V4L/DVB(13824a): mantis: Fix __devexit bad annotations

Niklas Edmundsson (2):
      V4L/DVB (13791): [TDA10021] Do not claim TDA10023
      V4L/DVB (13792): [Mantis/VP-2033] Do not claim TDA10023

Sigmund Augdal (6):
      V4L/DVB (13713): [MB86A16] Fix: Initialize SNR/STATUS
      V4L/DVB (13747): [Mantis] Bug Fix!: Use Register Address rather than register field
      V4L/DVB (13760): [Mantis CA] CA_MODULE: Look for module status on driver load
      V4L/DVB (13766): [Mantis] Bug: Fix wrong exit condition
      V4L/DVB (13774): [Mantis] Remove redundant wait for Burst Reads, wakeup the HIF event
      V4L/DVB (13780): [Mantis] HIF I/O: Enable Interrupts for Read

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
