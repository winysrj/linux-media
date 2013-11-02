Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44515 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3KBJvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 05:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <52742D00.7090805@gmail.com>
References: <1383252859-24221-1-git-send-email-ricardo.ribalda@gmail.com> <52742D00.7090805@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 2 Nov 2013 10:51:20 +0100
Message-ID: <CAPybu_0gMNWOGGW2u6EPWHNvrdQjDgD9wj6gZvfpdBqjCpbMdQ@mail.gmail.com>
Subject: Re: [[PATCH v3]] videobuf2: Add missing lock held on vb2_fop_relase
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester

Thanks for your comments. There is a new patch: v4! :)

On Fri, Nov 1, 2013 at 11:36 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Ricardo,
>
>
> On 10/31/2013 09:54 PM, Ricardo Ribalda Delgado wrote:
>>
>> From: Ricardo Ribalda<ricardo.ribalda@gmail.com>
>>
>> vb2_fop_relase does not held the lock although it is modifying the
>> queue->owner field.
>>
>> This could lead to race conditions on the vb2_perform_io function
>> when multiple applications are accessing the video device via
>> read/write API:
>
> [...]
>
>> v2: Add bug found by Sylvester Nawrocki
>
>
> "v2: Add fix for a bug found..." ? :)

In Spanish it makes sense. it is fixed now, thanks

>
>
>> fimc-capture and fimc-lite where calling vb2_fop_release with the lock
>> held.
>> Therefore a new __vb2_fop_release function has been created to be used by
>> drivers that overload the release function.
>>
>> v3: Comments by Sylvester Nawrocki and Mauro Carvalho Chehab
>>
>> Use vb2_fop_release_locked instead of __vb2_fop_release
>
>
> Such notes normally go after the scissors line ("---") after Signed-off-by
> lines.

Fixed, thanks!

>
>
>> Signed-off-by: Ricardo Ribalda<ricardo.ribalda@gmail.com>
>> Signed-off-by: Ricardo Ribalda Delgado<ricardo.ribalda@gmail.com>
>
>
> Is this duplication really needed ?

I have different slightly different git configuration in 2 computers. Fixed now

>
>
>> ---
>
>
>>   drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
>>   drivers/media/platform/exynos4-is/fimc-lite.c    |  2 +-
>>   drivers/media/v4l2-core/videobuf2-core.c         | 24
>> +++++++++++++++++++++++-
>>   include/media/videobuf2-core.h                   |  1 +
>>   4 files changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c
>> b/drivers/media/platform/exynos4-is/fimc-capture.c
>> index fb27ff7..c3c3b3b 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
>> @@ -549,7 +549,7 @@ static int fimc_capture_release(struct file *file)
>>                 vc->streaming = false;
>>         }
>>
>> -       ret = vb2_fop_release(file);
>> +       ret = vb2_fop_release_locked(file);
>
>
> I'm personally not happy with such a change. It is still not obvious
> if "locked" means that this function takes the lock internally or it
> should be called with the lock held. How about sticking to the common
> practice and instead naming it __vb2_fop_release() ?

I like the locked prefix, but it is a lost war :P. New version is named as __

>
>>         if (close) {
>>                 clear_bit(ST_CAPT_BUSY,&fimc->state);
>>
>> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c
>> b/drivers/media/platform/exynos4-is/fimc-lite.c
>> index e5798f7..b8d417f 100644
>> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
>> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
>> @@ -546,7 +546,7 @@ static int fimc_lite_release(struct file *file)
>>                 mutex_unlock(&entity->parent->graph_mutex);
>>         }
>>
>> -       vb2_fop_release(file);
>> +       vb2_fop_release_locked(file);
>>         pm_runtime_put(&fimc->pdev->dev);
>>         clear_bit(ST_FLITE_SUSPENDED,&fimc->state);
>>
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c
>> index 594c75e..06e6dbd 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2619,18 +2619,40 @@ int vb2_fop_mmap(struct file *file, struct
>> vm_area_struct *vma)
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_fop_mmap);
>>
>> -int vb2_fop_release(struct file *file)
>> +int __vb2_fop_release(struct file *file, bool lock_is_held)
>>   {
>>         struct video_device *vdev = video_devdata(file);
>> +       struct mutex *lock;
>>
>>         if (file->private_data == vdev->queue->owner) {
>> +               if (lock_is_held)
>> +                       lock = NULL;
>> +               else
>> +                       lock = vdev->queue->lock ?
>> +                               vdev->queue->lock : vdev->lock;
>> +               if (lock)
>> +                       mutex_lock(lock);
>>                 vb2_queue_release(vdev->queue);
>>                 vdev->queue->owner = NULL;
>> +               if (lock)
>> +                       mutex_unlock(lock);
>>         }
>>         return v4l2_fh_release(file);
>>   }
>> +EXPORT_SYMBOL_GPL(__vb2_fop_release);
>
>
> We don't need to export this function, do we ?

Not really. Fixed

>
>
>> +int vb2_fop_release(struct file *file)
>> +{
>> +       return __vb2_fop_release(file, false);
>> +}
>>   EXPORT_SYMBOL_GPL(vb2_fop_release);
>>
>> +int vb2_fop_release_locked(struct file *file)
>> +{
>> +       return __vb2_fop_release(file, true);
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_fop_release_locked);
>
>
> --
> Thanks,
> Sylwester

Thanks!



-- 
Ricardo Ribalda
