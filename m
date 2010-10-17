Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab0JQT3r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 15:29:47 -0400
Message-ID: <4CBB4EA3.7070901@redhat.com>
Date: Sun, 17 Oct 2010 17:29:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
Subject: Re: [GIT PATCHES FOR 2.6.37]  s5p-fimc camera host interface and
 SR030PC30 sensor drivers
References: <4CB42FF4.7060707@samsung.com>
In-Reply-To: <4CB42FF4.7060707@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-10-2010 06:52, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> 
> The following changes since commit 9147e3dbca0712a5435cd2ea7c48d39344f904eb
> 
> V4L/DVB: cx231xx: use core-assisted lock (Sat Oct 9 13:13:35 2010)
> 
> are available in the git repository at:
> 
> git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p_fimc_vga_for_2.6.37
> 
> Sylwester Nawrocki (7):
> cd8ea8a V4L/DVB: Add driver for Siliconfile SR030PC30 VGA camera
> 467835b V4L/DVB: s5p-fimc: Add suport for FIMC on S5PC210 SoCs
> ce30889 V4L/DVB: s5p-fimc: Add camera capture support
> bff8eea V4L/DVB: s5p-fimc: Do not lock both buffer queues in s_fmt
> 00c222c V4L/DVB: s5p-fimc: Fix 90/270 deg rotation errors
> 68028d6 V4L/DVB: s5p-fimc: mem2mem driver refactoring and cleanup
> c03564c V4L/DVB: s5p-fimc: Register definition cleanup
> 
> 
> drivers/media/video/Kconfig                 |    6 +
> drivers/media/video/Makefile                |    1 +
> drivers/media/video/s5p-fimc/Makefile       |    2 +-
> drivers/media/video/s5p-fimc/fimc-capture.c |  819 +++++++++++++++++++++
> drivers/media/video/s5p-fimc/fimc-core.c    | 1026 +++++++++++++++++----------
> drivers/media/video/s5p-fimc/fimc-core.h    |  377 ++++++++--
> drivers/media/video/s5p-fimc/fimc-reg.c     |  321 ++++++---
> drivers/media/video/s5p-fimc/regs-fimc.h    |   64 +-
> drivers/media/video/sr030pc30.c             |  893 +++++++++++++++++++++++
> include/media/s3c_fimc.h                    |   60 ++
> include/media/sr030pc30.h                   |   21 +
> 11 files changed, 2992 insertions(+), 598 deletions(-)
> 
> 
> All the patches have been posted to linux-media for review and can be found at
> patchwork at:
> https://patchwork.kernel.org/patch/245901/
> https://patchwork.kernel.org/patch/245911/
> https://patchwork.kernel.org/patch/245881/
> https://patchwork.kernel.org/patch/245871/
> https://patchwork.kernel.org/patch/245921/
> https://patchwork.kernel.org/patch/245891/
> https://patchwork.kernel.org/patch/245471/
> 
> The two patches added in the above repository
> 
> b6eb9a5 v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on
> S5PV210 SoCs
> 03bda68 v4l: s5p-fimc: Fix return value on probe() failure
> 
> are already in 2.6.36.
> 
> The patch cd8ea8a V4L/DVB: Add driver for Siliconfile SR030PC30 VGA camera
> has coding style changes in 3 lines comparing to version posted to ML.

There are a few warnings on it:

drivers/media/video/sr030pc30.c: In function ‘cam_i2c_write’:
drivers/media/video/sr030pc30.c:356: warning: ‘ret’ may be used uninitialized in this function
drivers/media/video/sr030pc30.c: In function ‘sr030pc30_set_params’:
drivers/media/video/sr030pc30.c:345: warning: ‘ret’ may be used uninitialized in this function
drivers/media/video/sr030pc30.c:328: note: ‘ret’ was declared here

Please fix.

Cheers,
Mauro
