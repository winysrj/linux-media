Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:35127 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab2LOJ7t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:49 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 00/15] [media] marvell-ccic: add soc camera support on marvell-ccic
Date: Sat, 15 Dec 2012 17:57:49 +0800
Message-Id: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patches series will add soc_camera support on marvell-ccic

Patch set V3 - Change log:
	- correct and enhance the implementation of some functions
	- replace most of preprocessor instruction with runtime detect
	- use devm_clk_get and devm_gpio_request which were missed in previous version
	- change code format in some funcions: replace if-else with switch
	- change some confused variable names
	- remove unnecessary functions: buf_init, buf_cleanup ...
	- remove unnecessary keyword: inline, extern ...
	- remove unnecessary include header file name
	- remove duplicated and unused code
	- remove unnecessary initialization of ret variable
	- [PATCH 09/15] change description

Patch set V2 - Change log:
	- remove register definition patch
	- split big patch to some small patches
	- split mcam-core.c to mcam-core.c and mcam-core-standard.c
	- add mcam-core-soc.c for soc camera support
	- split 3 frame buffers support patch into 2 patches

Patch set V1:
Log:
	- add mmp register definition
	- add soc_camera support on mcam core and mmp driver
	- add 3 frames buffers support in DMA_CONTIG mode

Thanks
Albert Wang

--
Albert Wang (7):
  [media] marvell-ccic: add get_mcam function for marvell-ccic driver
  [media] marvell-ccic: split mcam-core into 2 parts for soc_camera
    support
  [media] marvell-ccic: add soc_camera support in mcam core
  [media] marvell-ccic: add soc_camera support in mmp driver
  [media] marvell-ccic: add dma burst mode support in marvell-ccic
    driver
  [media] marvell-ccic: use unsigned int type replace int type
  [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode

Libin Yang (8):
  [media] marvell-ccic: use internal variable replace global frame
    stats variable:w
  [media] marvell-ccic: add MIPI support for marvell-ccic driver
  [media] marvell-ccic: add clock tree support for marvell-ccic driver
  [media] marvell-ccic: reset ccic phy when stop streaming for
    stability
  [media] marvell-ccic: refine mcam_set_contig_buffer function
  [media] marvell-ccic: add new formats support for marvell-ccic driver
  [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic
    driver
  [media] marvell-ccic: switch to resource managed allocation and
    request

 drivers/media/platform/Makefile                    |    4 +-
 drivers/media/platform/marvell-ccic/Kconfig        |   22 +
 drivers/media/platform/marvell-ccic/Makefile       |    6 +-
 .../media/platform/marvell-ccic/mcam-core-soc.c    |  416 +++++++
 .../media/platform/marvell-ccic/mcam-core-soc.h    |   19 +
 .../platform/marvell-ccic/mcam-core-standard.c     |  820 +++++++++++++
 .../platform/marvell-ccic/mcam-core-standard.h     |   26 +
 drivers/media/platform/marvell-ccic/mcam-core.c    | 1276 +++++---------------
 drivers/media/platform/marvell-ccic/mcam-core.h    |  155 ++-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |  347 ++++--
 include/media/mmp-camera.h                         |   21 +
 11 files changed, 2071 insertions(+), 1041 deletions(-)
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-soc.c
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-soc.h
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.c
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-standard.h

-- 
1.7.9.5

