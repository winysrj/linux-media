Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49722 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3BFKsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 05:48:45 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS007B0OLNYC60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 10:48:43 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHS00BKVOP75I80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 10:48:43 +0000 (GMT)
Message-id: <5112350A.60906@samsung.com>
Date: Wed, 06 Feb 2013 11:48:42 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.8] Exynos/s5p driver fixes
References: <50FAA6C4.9020606@gmail.com> <20130205184356.7e513290@redhat.com>
In-reply-to: <20130205184356.7e513290@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 02/05/2013 09:43 PM, Mauro Carvalho Chehab wrote:
[..]
>> The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:
>>
>>    Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)
>>
>> are available in the git repository at:
>>    git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes
>>
>> Kamil Debski (1):
>>        s5p-mfc: end-of-stream handling in encoder bug fix
>>
>> Sylwester Nawrocki (2):
>>        s5p-fimc: Fix fimc-lite entities deregistration
>>        s5p-csis: Fix clock handling on error path in probe()
>>
>>   drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
>>   drivers/media/platform/s5p-fimc/mipi-csis.c    |    2 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |    2 ++
>>   3 files changed, 4 insertions(+), 2 deletions(-)
>>
>>
>> pwclient update -s accepted 16223
>> pwclient update -s accepted 16206
>> pwclient update -s accepted 16314
> 
> Error:
> 
> Importing patches from git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes
> fatal: Couldn't find remote ref v3.8-rc5-fixes

Here is the updated pull request, after rebase onto staging/for_v3.9:


The following changes since commit 9b4539bebb86310afdc5563653ec4475ae110088:

  [media] em28xx: input: use common work_struct callback function for IR RC key
polling (2013-02-05 20:43:16 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes-2

for you to fetch changes up to 4a3dd932afe11a5edb3e5747a4d943b14062023f:

  s5p-fimc: Fix fimc-lite entities deregistration (2013-02-06 11:35:34 +0100)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: end-of-stream handling in encoder bug fix

Sylwester Nawrocki (2):
      s5p-csis: Fix clock handling on error path in probe()
      s5p-fimc: Fix fimc-lite entities deregistration

 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c    |    7 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |    2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

--

Thanks,
Sylwester
