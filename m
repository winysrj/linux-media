Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2CGLK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 06:10:59 -0500
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0I009WDHPSPMC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Mar 2012 20:10:40 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0I00JNSHPNVC10@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 07 Mar 2012 20:10:39 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: jtp.park@samsung.com, linux-media@vger.kernel.org
Cc: janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
References: <007001ccf81a$5efa1e70$1cee5b50$%park@samsung.com>
In-reply-to: <007001ccf81a$5efa1e70$1cee5b50$%park@samsung.com>
Subject: RE: [PATCH 0/3] Multi Format Codec 6.x driver for Exynos5
Date: Wed, 07 Mar 2012 12:10:34 +0100
Message-id: <002a01ccfc52$ed94ede0$c8bec9a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeongtae,

I have applied your patches to the kernel I am using with my Exynos4,
so I am still using MFC 5.1.

Unfortunately after applying your patches the MFC 5.1 device no longer works.
Did you test you patches with MFC 5.1? Adding support to MFC 6.0 should not
break the support for older hardware.

I have run the decoding example application and had received the following
error:
[  135.929705] samsung-pd samsung-pd.0: enable finished
[  135.978223] Unable to handle kernel paging request at virtual address e087ffff
[  135.987409] pgd = db210000
[  135.988637] [e087ffff] *pgd=5b825811, *pte=00000000, *ppte=00000000
[  135.994891] Internal error: Oops: 807 [#1] PREEMPT
[  135.999660] Modules linked in:
[  136.002701] CPU: 0    Not tainted  (3.2.0+ #3334)
[  136.007395] PC is at s5p_mfc_reset+0x58/0x29c
[  136.011732] LR is at get_parent_ip+0x10/0x2c
[  136.015982] pc : [<c0262460>]    lr : [<c001d628>]    psr: 60000013
[  136.015988] sp : db2add90  ip : 00000001  fp : 00000000
[  136.027437] r10: dbb90964  r9 : 60000013  r8 : db022004
[  136.032645] r7 : db0791e0  r6 : 00000000  r5 : dbb90800  r4 : dbb90800
[  136.039155] r3 : e0880000  r2 : 00000fee  r1 : a0000013  r0 : 00000000
[  136.045667] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  136.052783] Control: 10c53c7d  Table: 5b210059  DAC: 00000015
[  136.058512] Process v4l2_decode (pid: 2872, stack limit = 0xdb2ac2e8)
[  136.064934] Stack: (0xdb2add90 to 0xdb2ae000)
[!snip!]
[  136.232472] [<c0262460>] (s5p_mfc_reset+0x58/0x29c) from [<c0262aa0>] (s5p_mfc_init_hw+0x68/0x41c)
[  136.241405] [<c0262aa0>] (s5p_mfc_init_hw+0x68/0x41c) from [<c025c89c>] (s5p_mfc_open+0x254/0x45c)
[  136.250349] [<c025c89c>] (s5p_mfc_open+0x254/0x45c) from [<c0240a08>] (v4l2_open+0xb0/0xe8)
[  136.258682] [<c0240a08>] (v4l2_open+0xb0/0xe8) from [<c008df68>] (chrdev_open+0x174/0x194)
[  136.266931] [<c008df68>] (chrdev_open+0x174/0x194) from [<c00896f8>] (__dentry_open+0x1dc/0x2e8)
[  136.275694] [<c00896f8>] (__dentry_open+0x1dc/0x2e8) from [<c00898b4>] (nameidata_to_filp+0x50/0x5c)
[  136.284808] [<c00898b4>] (nameidata_to_filp+0x50/0x5c) from [<c00979c4>] (do_last+0x560/0x6a0)
[  136.293398] [<c00979c4>] (do_last+0x560/0x6a0) from [<c0097bc8>] (path_openat+0xc4/0x394)
[  136.301556] [<c0097bc8>] (path_openat+0xc4/0x394) from [<c0097f78>] (do_filp_open+0x30/0x7c)
[  136.309978] [<c0097f78>] (do_filp_open+0x30/0x7c) from [<c0089380>] (do_sys_open+0xd8/0x174)
[  136.318401] [<c0089380>] (do_sys_open+0xd8/0x174) from [<c000dbc0>] (ret_fast_syscall+0x0/0x30)
[  136.327076] Code: 0a000000 e12fff33 e59430a0 e3002fee (e5032001) 
[  136.341366] ---[ end trace 14efbfaf5f28c406 ]---

This has nothing to do with the BYTES/BITS change that would break encoding.

> From: Jeongtae Park [mailto:jtp.park@samsung.com]
> Sent: 02 March 2012 03:16
> 
> Hi Everyone,
> 
> This patch series is the 1st version of the MFC 6.x driver based on
> MFC 5.1 driver
> I would be grateful for your comments.
> 
> This patch series contains:
> 
> [PATCH 1/3] v4l: add contorl definitions for codec devices.
> [PATCH 2/3] v4l2-ctrl: add codec controls support to the control
> framework
> [PATCH 3/3] MFC: update MFC v4l2 driver to support MFC6.x
> 
> Best regards,
> Jeongtae Park
> 
> Patch summary:
> 
> Jeongtae Park (3):
> 	v4l: add contorl definitions for codec devices.
> 	v4l2-ctrl: add codec controls support to the control framework
> 	MFC: update MFC v4l2 driver to support MFC6.x
> 
> drivers/media/video/Kconfig                  |   15 +-
> drivers/media/video/s5p-mfc/Makefile         |    7 +-
> drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  671 +++++++++++
> drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
> drivers/media/video/s5p-mfc/s5p_mfc.c        |  157 ++-
> drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    4 +-
> drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
> drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  129 ++
> drivers/media/video/s5p-mfc/s5p_mfc_common.h |  125 ++-
> drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  113 ++-
> drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  212 +++-
> drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  364 +++++--
> drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
> drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  266 +++--
> drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   20 +-
> drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1670
> ++++++++++++++++++++++++++
> drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  137 +++
> drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   27 +-
> drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
> drivers/media/video/v4l2-ctrls.c             |   41 +-
> include/linux/videodev2.h                    |   51 +-
> 21 files changed, 3675 insertions(+), 380 deletions(-)
> create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
> create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
> create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
> create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

