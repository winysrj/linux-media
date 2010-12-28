Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20175 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0L1RDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:23 -0500
Date: Tue, 28 Dec 2010 18:03:05 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/10] V4L2 mem-to-mem framework and s5p-fimc driver conversion
 for videobuf2
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

the following patches is a continuation of patch series from Marek adding 
the videobuf2 framework. Please see this thread for reference:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg25988.html

The first and second patches convert v4l2-mem2mem framework and the mem2mem testdev
to videobuf2.

Patch 04/15 converts s5p-fimc, both mem2mem and camera capture interface drivers.
Except that it creates separate videobuf queue operation callback set for
the m2m and capture video nodes.

Patch 05/15 converts s5p-fimc driver so it supports multiplanar formats 
and thus can be used for hardware assisted video playback together with
S5P MFC (multi-format codec) driver.

The driver implements only *_mplane ioctl handlers so in case of
standard non-multiplane V4L2 application the buffers are converted
in v4l2 ioctl handling code.

Patch 06/15 just cleans up the driver by removing all locking from 
ioctl and file operation handlers and using v4l core lock.

Patches 07..15/15 are various s5p-fimc driver improvements and fixes.
Patch 15/15 introduces little changes for what was introduced by
HyounWoong Kim patches.


The patch series contains:

[PATCH 01/15] v4l: mem2mem: port to videobuf2
[PATCH 02/15] v4l: mem2mem: port m2m_testdev to vb2
[PATCH 03/15] v4l: Add multiplanar format fourccs for s5p-fimc driver
[PATCH 04/15] [media] s5p-fimc: Porting to videobuf 2
[PATCH 05/15] [media] s5p-fimc: Conversion to multiplanar formats
[PATCH 06/15] [media] s5p-fimc: Use v4l core mutex in ioctl and file operations
[PATCH 07/15] [media] s5p-fimc: Rename s3c_fimc* to s5p_fimc*
[PATCH 08/15] [media] s5p-fimc: Derive camera bus width from mediabus pixelcode
[PATCH 09/15] [media] s5p-fimc: Enable interworking without subdev s_stream
[PATCH 10/15] [media] s5p-fimc: Use default input DMA burst count
[PATCH 11/15] [media] s5p-fimc: Enable simultaneous rotation and flipping
[PATCH 12/15] [media] s5p-fimc: Add control of the external sensor clock
[PATCH 15/15] [media] s5p-fimc: Move scaler details handling to the register API file

Patches 13/15, 14/15 from HyounWoong Kim can be found here:

https://patchwork.kernel.org/patch/428901/
https://patchwork.kernel.org/patch/428891/

Full source tree containing the last Videobuf2, multiplanar extension patches
together with vivi, v4l2-mem2mem framework, mem2mem testdev and s5p-fimc driver
conversion to vb2 patches will be available within few hours on the following 
GIT tree:
git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2 branch.

Gitweb:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2

The tree is based on git://linuxtv.org/media_tree.git staging/for_v2.6.38.

I am still working on DocBook entries for new non-contiguous multiplanar fourccs
introduced in patch 03/15 and I expect to post them tomorrow. 


Regards,
Sylwester 


--
Sylwester Nawrocki
Samsung Poland R&D Center
