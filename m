Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51014 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab2KWNbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:31:11 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, lbyang@marvell.com,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH 0/15] [media] marvell-ccic: add soc camera support on marvell-ccic
Date: Fri, 23 Nov 2012 21:30:50 +0800
Message-Id: <1353677450-23876-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patches series will add soc camera support on marvell-ccic

Change log v2:
	- remove register definition patch
	- split big patch to some small patches
	- split mcam-core.c to mcam-core.c and mcam-core-standard.c
	- add mcam-core-soc.c for soc camera support
	- split 3 frame buffers support patch into 2 patches

[PATCH 01/15] [media] marvell-ccic: use internal variable replace
[PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic driver
[PATCH 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic driver
[PATCH 04/15] [media] marvell-ccic: reset ccic phy when stop streaming for stability
[PATCH 05/15] [media] marvell-ccic: refine mcam_set_contig_buffer function
[PATCH 06/15] [media] marvell-ccic: add new formats support for marvell-ccic driver
[PATCH 07/15] [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
[PATCH 08/15] [media] marvell-ccic: switch to resource managed allocation and request
[PATCH 09/15] [media] marvell-ccic: refine vb2_ops for marvell-ccic driver
[PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts for soc_camera support
[PATCH 11/15] [media] marvell-ccic: add soc_camera support in mcam core
[PATCH 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
[PATCH 13/15] [media] marvell-ccic: add dma burst mode support in marvell-ccic driver
[PATCH 14/15] [media] marvell-ccic: use unsigned int type replace int type
[PATCH 15/15] [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode


v1:
[PATCH 1/4] [media] mmp: add register definition for marvell ccic
[PATCH 2/4] [media] marvell-ccic: core: add soc camera support on marvell-ccic mcam-core
[PATCH 3/4] [media] marvell-ccic: mmp: add soc camera support on marvell-ccic mmp-driver
[PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers support in DMA_CONTIG mode


Thanks
Albert Wang

