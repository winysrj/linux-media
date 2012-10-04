Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43251 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2JDKHL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Oct 2012 06:07:11 -0400
Message-ID: <506D5FBF.8010601@ti.com>
Date: Thu, 4 Oct 2012 15:36:55 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LMML <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.7] Davinci VPIF driver cleanup
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull the following patches for davinci VPIF driver.
There are patches which affect davinci platform code, on top
of which cleanup was done, So to avoid conflicts these patches
need to go through media tree. Patches affecting davinci platform
code have been Acked by Sekhar.

Thanks and Regards,
--Prabhakar Lad

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx
(2012-10-02 17:15:22 -0300)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git da850_vpif_machine

Hans Verkuil (14):
      vpif_capture: remove unused data structure.
      vpif_display: remove unused data structures.
      vpif_capture: move input_idx to channel_obj.
      vpif_display: move output_id to channel_obj.
      vpif_capture: remove unnecessary can_route flag.
      vpif_capture: move routing info from subdev to input.
      vpif_capture: first init subdevs, then register device nodes.
      vpif_display: first init subdevs, then register device nodes.
      vpif_display: fix cleanup code.
      vpif_capture: fix cleanup code.
      vpif_capture: separate subdev from input.
      vpif_display: use a v4l2_subdev pointer to call a subdev.
      davinci: move struct vpif_interface to chan_cfg.
      tvp514x: s_routing should just change routing, not try to detect a
signal.

Lad, Prabhakar (4):
      media: davinci: vpif: add check for NULL handler
      media: davinci: vpif: display: separate out subdev from output
      media: davinci: vpif: Add return code check at vb2_queue_init()
      media: davinci: vpif: set device capabilities

Manjunath Hadli (2):
      ARM: davinci: da850: Add SoC related definitions for VPIF
      ARM: davinci: da850 evm: Add EVM specific code for VPIF to work

 arch/arm/mach-davinci/Kconfig                 |    7 +
 arch/arm/mach-davinci/board-da850-evm.c       |  179 ++++++++++++
 arch/arm/mach-davinci/board-dm646x-evm.c      |   80 ++++--
 arch/arm/mach-davinci/da850.c                 |  152 ++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h    |   11 +
 arch/arm/mach-davinci/include/mach/mux.h      |   42 +++
 arch/arm/mach-davinci/include/mach/psc.h      |    1 +
 drivers/media/i2c/tvp514x.c                   |   77 +-----
 drivers/media/platform/davinci/vpif_capture.c |  370
++++++++++++-------------
 drivers/media/platform/davinci/vpif_capture.h |   16 +-
 drivers/media/platform/davinci/vpif_display.c |  275 ++++++++++++------
 drivers/media/platform/davinci/vpif_display.h |   18 +-
 include/media/davinci/vpif_types.h            |   26 ++-
 13 files changed, 837 insertions(+), 417 deletions(-)
