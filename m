Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51352 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2F2SFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 14:05:51 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6E00ALX4YIES30@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Jun 2012 19:06:18 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M6E004YA4XPN500@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 29 Jun 2012 19:05:49 +0100 (BST)
Message-id: <4FEDEE7C.7080105@samsung.com>
Date: Fri, 29 Jun 2012 20:05:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.5] S5P driver fixes
References: <4FEC864D.5040608@samsung.com>
In-reply-to: <4FEC864D.5040608@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 06/28/2012 06:29 PM, Sylwester Nawrocki wrote:
> 
> The following changes since commit 433002d69888238b16f8ea9434447feaa1fc9bf0:
> 
>   Merge remote-tracking branch 'party-public/v4l-fimc-fixes' into v4l-fixes
> (2012-06-27 16:28:08 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes
> 
> for you to fetch changes up to f8a623efac978987be818a0a9d2d407791a066e4:
> 
>   Revert "[media] V4L: JPEG class documentation corrections" (2012-06-27
> 16:31:20 +0200)
> 
> ----------------------------------------------------------------
> Kamil Debski (1):
>       s5p-mfc: Fixed setup of custom controls in decoder and encoder
> 
> Sylwester Nawrocki (2):
>       s5p-fimc: Add missing FIMC-LITE file operations locking
> 
> This patch depends on my previous pull request:
> http://patchwork.linuxtv.org/patch/11503
> 
>       Revert "[media] V4L: JPEG class documentation corrections"
> 
>  Documentation/DocBook/media/v4l/controls.xml           |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
>  drivers/media/video/s5p-fimc/fimc-lite.c               |   61
> ++++++++++++++++++++++++++++++++++++++++++++-----------------
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c              |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c              |    1 +
>  5 files changed, 47 insertions(+), 25 deletions(-)

Sorry, I messed up this pull request by rebasing it onto wrong branch.
Here it is corrected, against staging/for_v3.5 and on top of merged
v4l-fimc-fixes branch, as per http://patchwork.linuxtv.org/patch/11503


The following changes since commit 96fc9f0f51d6b0d807aeb1f6e38485a3de429fd4:

  s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails (2012-06-05 13:28:25 +0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

for you to fetch changes up to c7de5370086a948c67cb7eeb5f25178c8979b0fe:

  Revert "[media] V4L: JPEG class documentation corrections" (2012-06-29 16:00:33 +0200)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fixed setup of custom controls in decoder and encoder

Sylwester Nawrocki (2):
      s5p-fimc: Add missing FIMC-LITE file operations locking
      Revert "[media] V4L: JPEG class documentation corrections"

 Documentation/DocBook/media/v4l/controls.xml           |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
 drivers/media/video/s5p-fimc/fimc-lite.c               |   61 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c              |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c              |    1 +
 5 files changed, 47 insertions(+), 25 deletions(-)

---
Regards,
Sylwester
