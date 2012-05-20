Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab2ETMjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 08:39:43 -0400
Message-ID: <4FB8E608.108@redhat.com>
Date: Sun, 20 May 2012 09:39:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR 3.5] s5p-fimc driver updates
References: <4FA3F635.60409@samsung.com> <4FAB80D5.50500@samsung.com> <4FB17B79.2000207@gmail.com>
In-Reply-To: <4FB17B79.2000207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-05-2012 18:39, Sylwester Nawrocki escreveu:
> On 05/10/2012 10:48 AM, Sylwester Nawrocki wrote:
>> On 05/04/2012 05:31 PM, Sylwester Nawrocki wrote:
>>> Hi Mauro,
>>>
>>> The following changes since commit 34b2debaa62bfa384ef91b61cf2c40c48e86a5e2:
>>>
>>>    s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS (2012-05-04 17:07:24 +0200)
>>>
>>> are available in the git repository at:
>>>
>>>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-exynos4x12
>>>
>>> for you to fetch changes up to bab96b068afa07105139be09d3830cc9ed580382:
>>>
>>>    s5p-fimc: Use selection API in place of crop operations (2012-05-04 17:18:38 +0200)
>>
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

Please do that, as this patch doesn't apply as-is.

Regards,
Mauro

$ quilt push
Applying patch patches/lmml_11243_git_pull_for_3_5_s5p_fimc_driver_updates.patch
patching file drivers/media/video/s5p-fimc/fimc-capture.c
Hunk #1 FAILED at 993.
Hunk #2 FAILED at 1489.
Hunk #3 FAILED at 1554.
Hunk #4 FAILED at 1572.
Hunk #5 FAILED at 1580.
Hunk #6 FAILED at 1616.
Hunk #7 FAILED at 1636.
7 out of 7 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-capture.c
patching file drivers/media/video/s5p-fimc/fimc-core.c
Hunk #1 FAILED at 842.
Hunk #2 FAILED at 851.
Hunk #3 FAILED at 866.
Hunk #4 FAILED at 953.
4 out of 4 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-core.c
patching file drivers/media/video/s5p-fimc/fimc-core.h
Hunk #1 FAILED at 331.
Hunk #2 FAILED at 737.
2 out of 2 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-core.h
patching file drivers/media/video/s5p-fimc/fimc-m2m.c
Hunk #1 FAILED at 777.
Hunk #2 FAILED at 789.
2 out of 2 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-m2m.c
patching file drivers/media/video/s5p-fimc/fimc-mdevice.c
Hunk #1 FAILED at 304.
Hunk #2 FAILED at 313.
Hunk #3 FAILED at 401.
Hunk #4 FAILED at 420.
Hunk #5 FAILED at 479.
Hunk #6 FAILED at 588.
Hunk #7 FAILED at 817.
7 out of 7 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-mdevice.c
patching file drivers/media/video/s5p-fimc/fimc-mdevice.h
Hunk #1 FAILED at 24.
1 out of 1 hunk FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-mdevice.h
