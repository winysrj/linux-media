Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823Ab2GFTKc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 15:10:32 -0400
Message-ID: <4FF73821.9010108@redhat.com>
Date: Fri, 06 Jul 2012 16:10:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.5] S5P driver fixes
References: <4FEC864D.5040608@samsung.com> <4FEDEE7C.7080105@samsung.com>
In-Reply-To: <4FEDEE7C.7080105@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-06-2012 15:05, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> On 06/28/2012 06:29 PM, Sylwester Nawrocki wrote:
>>
>> The following changes since commit 433002d69888238b16f8ea9434447feaa1fc9bf0:
>>
>>    Merge remote-tracking branch 'party-public/v4l-fimc-fixes' into v4l-fixes
>> (2012-06-27 16:28:08 +0200)
>>
>> are available in the git repository at:
>>
>>
>>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes
>>
>> for you to fetch changes up to f8a623efac978987be818a0a9d2d407791a066e4:
>>
>>    Revert "[media] V4L: JPEG class documentation corrections" (2012-06-27
>> 16:31:20 +0200)
>>
>> ----------------------------------------------------------------
>> Kamil Debski (1):
>>        s5p-mfc: Fixed setup of custom controls in decoder and encoder
>>
>> Sylwester Nawrocki (2):
>>        s5p-fimc: Add missing FIMC-LITE file operations locking
>>
>> This patch depends on my previous pull request:
>> http://patchwork.linuxtv.org/patch/11503
>>
>>        Revert "[media] V4L: JPEG class documentation corrections"
>>
>>   Documentation/DocBook/media/v4l/controls.xml           |    2 +-
>>   Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
>>   drivers/media/video/s5p-fimc/fimc-lite.c               |   61
>> ++++++++++++++++++++++++++++++++++++++++++++-----------------
>>   drivers/media/video/s5p-mfc/s5p_mfc_dec.c              |    1 +
>>   drivers/media/video/s5p-mfc/s5p_mfc_enc.c              |    1 +
>>   5 files changed, 47 insertions(+), 25 deletions(-)
> 
> Sorry, I messed up this pull request by rebasing it onto wrong branch.
> Here it is corrected, against staging/for_v3.5 and on top of merged
> v4l-fimc-fixes branch, as per http://patchwork.linuxtv.org/patch/11503
> 
> 
> The following changes since commit 96fc9f0f51d6b0d807aeb1f6e38485a3de429fd4:
> 
>    s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails (2012-06-05 13:28:25 +0200)
> 
> are available in the git repository at:
> 
>    git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes
> 
> for you to fetch changes up to c7de5370086a948c67cb7eeb5f25178c8979b0fe:
> 
>    Revert "[media] V4L: JPEG class documentation corrections" (2012-06-29 16:00:33 +0200)
> 
> ----------------------------------------------------------------
> Kamil Debski (1):
>        s5p-mfc: Fixed setup of custom controls in decoder and encoder

This patch applied OK.

> Sylwester Nawrocki (2):
>        s5p-fimc: Add missing FIMC-LITE file operations locking

This one didn't apply for v3.5:

Applying patch patches/0016-s5p-fimc-Add-missing-FIMC-LITE-file-operations-locki.patch
patching file drivers/media/video/s5p-fimc/fimc-lite.c
Hunk #1 FAILED at 453.
Hunk #2 succeeded at 492 (offset -2 lines).
1 out of 2 hunks FAILED -- rejects in file drivers/media/video/s5p-fimc/fimc-lite.c
Patch patches/0016-s5p-fimc-Add-missing-FIMC-LITE-file-operations-locki.patch does not apply (enforce with -f)
Patch didn't apply. Aborting


>        Revert "[media] V4L: JPEG class documentation corrections"

My scripts say that this patch were already applied.

$ test_patch
testing if patches/0017-Revert-media-V4L-JPEG-class-documentation-correction.patch applies
patch -p1 -i patches/0017-Revert-media-V4L-JPEG-class-documentation-correction.patch --dry-run -t -N
patching file Documentation/DocBook/media/v4l/controls.xml
patching file Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
 Documentation/DocBook/media/v4l/controls.xml           |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)
Subject: Revert "[media] V4L: JPEG class documentation corrections"
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Wed, 27 Jun 2012 15:12:31 +0200
Patch applies OK
total: 0 errors, 0 warnings, 21 lines checked

patches/0017-Revert-media-V4L-JPEG-class-documentation-correction.patch has no obvious style problems and is ready for submission.
Patch is likely applied

So, from this series, I'll only apply the "s5p-fimc: Add missing FIMC-LITE file operations locking"
patch.

Regards,
Mauro
