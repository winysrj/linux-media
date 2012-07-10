Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40585 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab2GJMx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:53:59 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
CC: "'LMML'" <linux-media@vger.kernel.org>,
	"'dlos'" <davinci-linux-open-source@linux.davincidsp.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: [GIT PULL] Davinci VPIF feature enhancement and fixes for v3.5
Date: Tue, 10 Jul 2012 12:53:52 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CE0035@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following VPIF driver feature enhancement and fixes for v3.5

Thanks and Regards,
--Prabhakar Lad

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_vpif

Lad, Prabhakar (2):
      davinci: vpif capture: migrate driver to videobuf2
      davinci: vpif display: migrate driver to videobuf2

Manjunath Hadli (12):
      davinci: vpif: add check for genuine interrupts in the isr
      davinci: vpif: make generic changes to re-use the vpif drivers on da850/omap-l138 soc
      davinci: vpif: make request_irq flags as shared
      davinci: vpif: fix setting of data width in config_vpif_params() function
      davinci: vpif display: size up the memory for the buffers from the buffer pool
      davinci: vpif capture: size up the memory for the buffers from the buffer pool
      davinci: vpif: add support for clipping on output data
      davinci: vpif display: Add power management support
      davinci: vpif capture:Add power management support
      davinci: vpif: Add suspend/resume callbacks to vpif driver
      davinci: vpif: add build configuration for vpif drivers
      davinci: vpif: Enable selection of the ADV7343 and THS7303

 drivers/media/video/davinci/Kconfig        |   30 +-
 drivers/media/video/davinci/Makefile       |    8 +-
 drivers/media/video/davinci/vpif.c         |   45 ++-
 drivers/media/video/davinci/vpif.h         |   45 ++
 drivers/media/video/davinci/vpif_capture.c |  690 +++++++++++++++-------------
 drivers/media/video/davinci/vpif_capture.h |   16 +-
 drivers/media/video/davinci/vpif_display.c |  684 +++++++++++++++------------
 drivers/media/video/davinci/vpif_display.h |   23 +-
 include/media/davinci/vpif_types.h         |    2 +
 9 files changed, 881 insertions(+), 662 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
sage to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

