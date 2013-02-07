Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53635 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab3BGMH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:07:29 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>
Subject: [REVIEW PATCH V4 00/12] [media] marvell-ccic: add soc camera support in marvell-ccic driver
Date: Thu,  7 Feb 2013 20:04:35 +0800
Message-Id: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patches series will add soc_camera support in marvell-ccic driver

Patch set V4 - Change log:
	- remove the first patch of V3 which had been queued in tree
	- merge [PATCH 09/15-12/15] of V3 to [PATCH 10/12] of V4
	- use soc_camera mode replace the old mode for maintain in the future
	- correct some errors of implementation in mcam_ctlr_image()
	- change get_mcam() function name to vq_to_mcam()
	- use proper words replace some inaccurate wordings in description
	- add [PATCH 08/12] to rename varablies for avoiding CamelCase warning
	- adjust patch sequence and move [PATCH 14/15] of V3 to [PATCH 09/12] of V4
	- change some functions implementation include spliting into 2 functions and decreasing parameters

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

Patch set V1 - Log:
	- add mmp register definition
	- add soc_camera support on mcam core and mmp driver
	- add 3 frames buffers support in DMA_CONTIG mode

Thanks
Albert Wang

--
Albert Wang (7):
  [media] marvell-ccic: reset ccic phy when stop streaming for stability
  [media] marvell-ccic: switch to resource managed allocation and request
  [media] marvell-ccic: rename B_DMA* to avoid CamelCase warning
  [media] marvell-ccic: use unsigned int type replace int type
  [media] marvell-ccic: add soc_camera support for marvell-ccic driver
  [media] marvell-ccic: add dma burst support for marvell-ccic driver
  [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode

Libin Yang (5):
  [media] marvell-ccic: add MIPI support for marvell-ccic driver
  [media] marvell-ccic: add clock tree support for marvell-ccic driver
  [media] marvell-ccic: refine mcam_set_contig_buffer function
  [media] marvell-ccic: add new formats support for marvell-ccic driver
  [media] marvell-ccic: add SOF/EOF pair check for marvell-ccic driver

 drivers/media/platform/Makefile                   |    4 +-
 drivers/media/platform/marvell-ccic/Kconfig       |    6 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   | 1362 ++++++++++-----------
 drivers/media/platform/marvell-ccic/mcam-core.h   |  102 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |  306 +++--
 include/media/mmp-camera.h                        |   16 +
 7 files changed, 941 insertions(+), 857 deletions(-)

-- 
1.7.9.5

