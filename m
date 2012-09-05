Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59394 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2IEQMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 12:12:06 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9V00MQMX0TXO80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Sep 2012 17:12:29 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M9V00L7EX03Y210@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Sep 2012 17:12:04 +0100 (BST)
Message-id: <504779D3.7040804@samsung.com>
Date: Wed, 05 Sep 2012 18:12:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR v3.6] Samsung media driver fixes
References: <5034991F.5040403@samsung.com>
In-reply-to: <5034991F.5040403@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/22/2012 10:32 AM, Sylwester Nawrocki wrote:
> The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:
> 
>   Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes
> 
> for you to fetch changes up to 0e59db054e30658c6955d6e27b0a252cef9bfafc:
> 
>   s5p-mfc: Fix second memory bank alignment (2012-08-16 19:12:19 +0200)
> 
> ----------------------------------------------------------------
> Kamil Debski (1):
>       s5p-mfc: Fix second memory bank alignment
> 
> Sylwester Nawrocki (7):
>       s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
>       s5p-fimc: Don't allocate fimc-lite video device structure dynamically
>       s5p-fimc: Don't allocate fimc-capture video device dynamically
>       s5p-fimc: Don't allocate fimc-m2m video device dynamically
>       m5mols: Add missing free_irq() on error path
>       m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
>       s5p-fimc: Fix setup of initial links to FIMC entities

I've added 2 more patches to this series:


The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:

  Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

for you to fetch changes up to 06ed4e72ce30ef7d15ef2de7e15ed47107d05ded:

  s5p-fimc: fimc-lite: Propagate frame format on the subdev (2012-09-05 15:21:33 +0200)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fix second memory bank alignment

Sylwester Nawrocki (9):
      s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
      s5p-fimc: Don't allocate fimc-lite video device structure dynamically
      s5p-fimc: Don't allocate fimc-capture video device dynamically
      s5p-fimc: Don't allocate fimc-m2m video device dynamically
      m5mols: Add missing free_irq() on error path
      m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
      s5p-fimc: Fix setup of initial links to FIMC entities
      s5p-fimc: fimc-lite: Correct Bayer pixel format definitions
      s5p-fimc: fimc-lite: Propagate frame format on the subdev

 drivers/media/video/m5mols/m5mols.h          |  4 ++--
 drivers/media/video/m5mols/m5mols_controls.c |  4 ++--
 drivers/media/video/m5mols/m5mols_core.c     |  4 +++-
 drivers/media/video/s5p-fimc/Kconfig         |  2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  | 31 ++++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.h     |  4 ++--
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  8 ++++----
 drivers/media/video/s5p-fimc/fimc-lite.c     | 49 ++++++++++++++---------------
 drivers/media/video/s5p-fimc/fimc-lite.h     |  2 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c      | 40 +++++++++---------------
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |  9 ++++++---
 drivers/media/video/s5p-fimc/fimc-mdevice.h  |  6 ++----
 drivers/media/video/s5p-fimc/fimc-reg.c      |  6 +++---
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  2 +-
 14 files changed, 73 insertions(+), 98 deletions(-)

>  drivers/media/video/m5mols/m5mols.h          |  4 +--
>  drivers/media/video/m5mols/m5mols_controls.c |  4 +--
>  drivers/media/video/m5mols/m5mols_core.c     |  4 ++-
>  drivers/media/video/s5p-fimc/Kconfig         |  2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c  | 31 +++++++-----------
>  drivers/media/video/s5p-fimc/fimc-core.h     |  4 +--
>  drivers/media/video/s5p-fimc/fimc-lite-reg.c |  2 +-
>  drivers/media/video/s5p-fimc/fimc-lite.c     | 42 ++++++++++---------------
>  drivers/media/video/s5p-fimc/fimc-lite.h     |  2 +-
>  drivers/media/video/s5p-fimc/fimc-m2m.c      | 40 ++++++++---------------
>  drivers/media/video/s5p-fimc/fimc-mdevice.c  |  9 ++++--
>  drivers/media/video/s5p-fimc/fimc-mdevice.h  |  6 ++--
>  drivers/media/video/s5p-fimc/fimc-reg.c      |  6 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  2 +-
>  14 files changed, 65 insertions(+), 93 deletions(-)
 
--

Thanks,
Sylwester
