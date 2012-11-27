Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2K0RPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 12:15:47 -0500
Date: Tue, 27 Nov 2012 18:15:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org, lbyang@marvell.com
Subject: Re: [PATCH 0/15] [media] marvell-ccic: add soc camera support on
 marvell-ccic
In-Reply-To: <1353677450-23876-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271813350.22273@axis700.grange>
References: <1353677450-23876-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laxman

Just a general comment: this patch series is a huge improvement over the 
previous versions, now it is actually already reviewable! :-) Thanks for 
keeping on with this work!

Best regards
Guennadi

On Fri, 23 Nov 2012, Albert Wang wrote:

> The following patches series will add soc camera support on marvell-ccic
> 
> Change log v2:
> 	- remove register definition patch
> 	- split big patch to some small patches
> 	- split mcam-core.c to mcam-core.c and mcam-core-standard.c
> 	- add mcam-core-soc.c for soc camera support
> 	- split 3 frame buffers support patch into 2 patches
> 
> [PATCH 01/15] [media] marvell-ccic: use internal variable replace
> [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic driver
> [PATCH 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic driver
> [PATCH 04/15] [media] marvell-ccic: reset ccic phy when stop streaming for stability
> [PATCH 05/15] [media] marvell-ccic: refine mcam_set_contig_buffer function
> [PATCH 06/15] [media] marvell-ccic: add new formats support for marvell-ccic driver
> [PATCH 07/15] [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic driver
> [PATCH 08/15] [media] marvell-ccic: switch to resource managed allocation and request
> [PATCH 09/15] [media] marvell-ccic: refine vb2_ops for marvell-ccic driver
> [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts for soc_camera support
> [PATCH 11/15] [media] marvell-ccic: add soc_camera support in mcam core
> [PATCH 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
> [PATCH 13/15] [media] marvell-ccic: add dma burst mode support in marvell-ccic driver
> [PATCH 14/15] [media] marvell-ccic: use unsigned int type replace int type
> [PATCH 15/15] [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode
> 
> 
> v1:
> [PATCH 1/4] [media] mmp: add register definition for marvell ccic
> [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on marvell-ccic mcam-core
> [PATCH 3/4] [media] marvell-ccic: mmp: add soc camera support on marvell-ccic mmp-driver
> [PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers support in DMA_CONTIG mode
> 
> 
> Thanks
> Albert Wang
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
