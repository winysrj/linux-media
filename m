Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30657 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2EOPlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 11:41:47 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M42003I4M63H3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 16:39:39 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4200D63M9GTJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 16:41:45 +0100 (BST)
Date: Tue, 15 May 2012 17:41:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR 3.5] s5p-fimc driver updates
In-reply-to: <4FB17B79.2000207@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4FB27930.9020408@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4FA3F635.60409@samsung.com> <4FAB80D5.50500@samsung.com>
 <4FB17B79.2000207@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 05/14/2012 11:39 PM, Sylwester Nawrocki wrote:
> On 05/10/2012 10:48 AM, Sylwester Nawrocki wrote:
>> On 05/04/2012 05:31 PM, Sylwester Nawrocki wrote:
...
>> Mauro,
>>
>> I've found a few issues in this series afterwards and re-edited 3 commits there.
>> Here is an updated pull request:
>>
>> The following changes since commit ae45d3e9aea0ab951dbbca2238fbfbf3993f1e7f:
>>
>>    s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-09 16:07:49 +0200)
>>
>> are available in the git repository at:
>>
>>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
>>
>> for you to fetch changes up to 5feefe6656583de6fd4ef1d53b19031dd5efeec1:
>>
>>    s5p-fimc: Use selection API in place of crop operations (2012-05-09 16:11:29 +0200)
>>
>> ----------------------------------------------------------------
>> Sylwester Nawrocki (14):
>>        V4L: Extend V4L2_CID_COLORFX with more image effects
>>        s5p-fimc: Avoid crash with null platform_data
>>        s5p-fimc: Move m2m node driver into separate file
> 
> It seems there is a conflict now with this patch:
> http://git.linuxtv.org/media_tree.git/commit/5126f2590bee412e3053de851cb07f531e4be36a
> 
> Attached are updated versions of the two conflicting patches, the others 
> don't need touching.
> 
> I could provide rebased version of the whole change set tomorrow - if needed.

Here comes the updated change set:

The following changes since commit 152a3a7320d1582009db85d8be365ce430d079af:

  [media] v4l2-dev: rename two functions (2012-05-14 15:06:50 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12

for you to fetch changes up to 7df337fdecb908d6b7762b0b6d9160a911d0cafe:

  s5p-fimc: Use selection API in place of crop operations (2012-05-15 11:02:53
+0200)

----------------------------------------------------------------
Sylwester Nawrocki (14):
      s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS
      s5p-fimc: Avoid crash with null platform_data
      s5p-fimc: Move m2m node driver into separate file
      s5p-fimc: Use v4l2_subdev internal ops to register video nodes
      s5p-fimc: Refactor the register interface functions
      s5p-fimc: Add FIMC-LITE register definitions
      s5p-fimc: Rework the video pipeline control functions
      s5p-fimc: Prefix format enumerations with FIMC_FMT_
      s5p-fimc: Minor cleanups
      s5p-fimc: Make sure an interrupt is properly requested
      s5p-fimc: Add support for Exynos4x12 FIMC-LITE
      s5p-fimc: Update copyright notices
      s5p-fimc: Add color effect control
      s5p-fimc: Use selection API in place of crop operations

 drivers/media/video/Kconfig                  |   24 +-
 drivers/media/video/s5p-fimc/Kconfig         |   48 +++
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |  500
++++++++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.c     | 1109
+++++++++++----------------------------------------------------------
 drivers/media/video/s5p-fimc/fimc-core.h     |  256 +++++-----------
 drivers/media/video/s5p-fimc/fimc-lite-reg.c |  300 +++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite-reg.h |  150 ++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.c     | 1576
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-lite.h     |  213 ++++++++++++++
 drivers/media/video/s5p-fimc/fimc-m2m.c      |  824
++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c  |  407 +++++++++++++++++---------
 drivers/media/video/s5p-fimc/fimc-mdevice.h  |   18 +-
 drivers/media/video/s5p-fimc/fimc-reg.c      |  613
+++++++++++++++++++++------------------
 drivers/media/video/s5p-fimc/fimc-reg.h      |  326 +++++++++++++++++++++
 drivers/media/video/s5p-fimc/regs-fimc.h     |  301 -------------------
 include/media/s5p_fimc.h                     |   16 +
 17 files changed, 4635 insertions(+), 2052 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/Kconfig
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite-reg.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-m2m.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.h
 delete mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h

--
Regards,
Sylwester
