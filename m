Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23780 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2KZQJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 11:09:10 -0500
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME30047ORJWA6B0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Nov 2012 16:09:32 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0ME300IRTRJ7B810@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Nov 2012 16:09:08 +0000 (GMT)
Message-id: <50B39422.2060906@samsung.com>
Date: Mon, 26 Nov 2012 17:09:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.7-rc] Samsung SoC media driver fixes
References: <50AE6BAC.1030208@samsung.com>
In-reply-to: <50AE6BAC.1030208@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 11/22/2012 07:15 PM, Sylwester Nawrocki wrote:
> The following changes since commit 30677fd9ac7b9a06555318ec4f9a0db39804f9b2:
> 
>   s5p-fimc: Fix potential NULL pointer dereference (2012-11-22 10:15:40 +0100)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/kmpark/linux-samsung media_fixes_for_v3.7
> 
> for you to fetch changes up to 28f497f26c67ab734bdb923b457016122368f69a:
> 
>   s5p-mfc: Handle multi-frame input buffer (2012-11-22 15:13:53 +0100)
> 
> This is a bunch of quite important fixes for the Exynos SoC drivers,
> please apply for v3.7 if possible. This depends on my previous pull
> request (I've applied the patches you indicated you take for v3.7
> previously to the media_fixes_for_v3.7 branch as well).

I have fixed 2 build warnings caused by patch
"s5p-fimc: Prevent race conditions during subdevs registration".
Here is an updated pull request:

The following changes since commit 30677fd9ac7b9a06555318ec4f9a0db39804f9b2:

  s5p-fimc: Fix potential NULL pointer dereference (2012-11-22 10:15:40 +0100)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung media_fixes_for_v3.7

for you to fetch changes up to ffc64574688e1d6f110ca91cef2573f7eca1dbab:

  s5p-mfc: Handle multi-frame input buffer (2012-11-26 15:55:04 +0100)

----------------------------------------------------------------
Arun Kumar K (2):
      s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      s5p-mfc: Handle multi-frame input buffer

Shaik Ameer Basha (1):
      exynos-gsc: Fix settings for input and output image RGB type

Sylwester Nawrocki (5):
      s5p-fimc: Prevent race conditions during subdevs registration
      s5p-fimc: Don't use mutex_lock_interruptible() in device release()
      fimc-lite: Don't use mutex_lock_interruptible() in device release()
      exynos-gsc: Don't use mutex_lock_interruptible() in device release()
      exynos-gsc: Add missing video device vfl_dir flag initialization

 drivers/media/platform/exynos-gsc/gsc-m2m.c     |    4 ++--
 drivers/media/platform/exynos-gsc/gsc-regs.h    |   16 ++++++++--------
 drivers/media/platform/s5p-fimc/fimc-capture.c  |   10 +++++++---
 drivers/media/platform/s5p-fimc/fimc-lite.c     |    6 ++++--
 drivers/media/platform/s5p-fimc/fimc-m2m.c      |    3 +--
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |    4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    7 ++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
 8 files changed, 27 insertions(+), 25 deletions(-)


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
