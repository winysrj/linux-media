Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62446 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0JRIwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 04:52:40 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LAH000AG9ZP6X@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 09:52:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAH005XR9ZPSS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 09:52:37 +0100 (BST)
Date: Mon, 18 Oct 2010 10:52:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PATCHES FOR 2.6.37]  s5p-fimc camera host interface and
 SR030PC30 sensor drivers
In-reply-to: <4CBB4EA3.7070901@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
Message-id: <4CBC0AD4.80105@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 8BIT
References: <4CB42FF4.7060707@samsung.com> <4CBB4EA3.7070901@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 10/17/2010 09:29 PM, Mauro Carvalho Chehab wrote:
> Em 12-10-2010 06:52, Sylwester Nawrocki escreveu:
>> Hi Mauro,
>>
>>
>> The following changes since commit 9147e3dbca0712a5435cd2ea7c48d39344f904eb
>>
>> V4L/DVB: cx231xx: use core-assisted lock (Sat Oct 9 13:13:35 2010)
>>
>> are available in the git repository at:
>>
>> git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p_fimc_vga_for_2.6.37
>>
>> Sylwester Nawrocki (7):
>> cd8ea8a V4L/DVB: Add driver for Siliconfile SR030PC30 VGA camera
>> 467835b V4L/DVB: s5p-fimc: Add suport for FIMC on S5PC210 SoCs
>> ce30889 V4L/DVB: s5p-fimc: Add camera capture support
>> bff8eea V4L/DVB: s5p-fimc: Do not lock both buffer queues in s_fmt
>> 00c222c V4L/DVB: s5p-fimc: Fix 90/270 deg rotation errors
>> 68028d6 V4L/DVB: s5p-fimc: mem2mem driver refactoring and cleanup
>> c03564c V4L/DVB: s5p-fimc: Register definition cleanup
>>
>>
>> drivers/media/video/Kconfig                 |    6 +
>> drivers/media/video/Makefile                |    1 +
>> drivers/media/video/s5p-fimc/Makefile       |    2 +-
>> drivers/media/video/s5p-fimc/fimc-capture.c |  819 +++++++++++++++++++++
>> drivers/media/video/s5p-fimc/fimc-core.c    | 1026 +++++++++++++++++----------
>> drivers/media/video/s5p-fimc/fimc-core.h    |  377 ++++++++--
>> drivers/media/video/s5p-fimc/fimc-reg.c     |  321 ++++++---
>> drivers/media/video/s5p-fimc/regs-fimc.h    |   64 +-
>> drivers/media/video/sr030pc30.c             |  893 +++++++++++++++++++++++
>> include/media/s3c_fimc.h                    |   60 ++
>> include/media/sr030pc30.h                   |   21 +
>> 11 files changed, 2992 insertions(+), 598 deletions(-)
>>
>>
>> All the patches have been posted to linux-media for review and can be found at
>> patchwork at:
>> https://patchwork.kernel.org/patch/245901/
>> https://patchwork.kernel.org/patch/245911/
>> https://patchwork.kernel.org/patch/245881/
>> https://patchwork.kernel.org/patch/245871/
>> https://patchwork.kernel.org/patch/245921/
>> https://patchwork.kernel.org/patch/245891/
>> https://patchwork.kernel.org/patch/245471/
>>
>> The two patches added in the above repository
>>
>> b6eb9a5 v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on
>> S5PV210 SoCs
>> 03bda68 v4l: s5p-fimc: Fix return value on probe() failure
>>
>> are already in 2.6.36.
>>
>> The patch cd8ea8a V4L/DVB: Add driver for Siliconfile SR030PC30 VGA camera
>> has coding style changes in 3 lines comparing to version posted to ML.
> 
> There are a few warnings on it:
> 
> drivers/media/video/sr030pc30.c: In function ‘cam_i2c_write’:
> drivers/media/video/sr030pc30.c:356: warning: ‘ret’ may be used uninitialized in this function
> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_set_params’:
> drivers/media/video/sr030pc30.c:345: warning: ‘ret’ may be used uninitialized in this function
> drivers/media/video/sr030pc30.c:328: note: ‘ret’ was declared here
> 
> Please fix.

Sorry about this quite obvious error, to follow is the patch to fix this.
And thank you for applying the patchset!

Regards,
 Sylwester
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
