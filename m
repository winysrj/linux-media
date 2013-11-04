Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34363 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3KDOMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 09:12:34 -0500
Message-id: <5277AB4A.5050007@samsung.com>
Date: Mon, 04 Nov 2013 15:12:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4] videobuf2: Add missing lock held on vb2_fop_relase
References: <1383385994-11422-1-git-send-email-ricardo.ribalda@gmail.com>
 <527794F0.40901@xs4all.nl>
 <CAPybu_0cKxMxhXoSqbK2nTyX3DGCVZdUZPt2bTE6aZR65xDG=w@mail.gmail.com>
In-reply-to: <CAPybu_0cKxMxhXoSqbK2nTyX3DGCVZdUZPt2bTE6aZR65xDG=w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/11/13 14:54, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> Thanks for your comments.
> 
> Please take a look to v4 of this patch
> https://patchwork.linuxtv.org/patch/20529/

We're discussing v4 actually ;)

> On Mon, Nov 4, 2013 at 1:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 11/02/2013 10:53 AM, Ricardo Ribalda Delgado wrote:
>>> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>>
>>> vb2_fop_relase does not held the lock although it is modifying the
>>> queue->owner field.
>>>
>>> This could lead to race conditions on the vb2_perform_io function
>>> when multiple applications are accessing the video device via
>>> read/write API:
>>
>> It's also called directly by drivers/media/usb/em28xx/em28xx-video.c!
>>
> 
> em28xx-video does not hold the lock, therefore it can call the normal
> function. On v2 we made a internal function that should be called if
> the funciton is called directly by the driver. Please take a look to
> the old comments. https://patchwork.linuxtv.org/patch/20460/
[...]
>>> -int vb2_fop_release(struct file *file)
>>> +static int _vb2_fop_release(struct file *file, bool lock_is_held)
>>>  {
>>>       struct video_device *vdev = video_devdata(file);
>>> +     struct mutex *lock;
>>>
>>>       if (file->private_data == vdev->queue->owner) {
>>> +             if (lock_is_held)
>>> +                     lock = NULL;
>>> +             else
>>> +                     lock = vdev->queue->lock ?
>>> +                             vdev->queue->lock : vdev->lock;
>>> +             if (lock)
>>> +                     mutex_lock(lock);
>>>               vb2_queue_release(vdev->queue);
>>>               vdev->queue->owner = NULL;
>>> +             if (lock)
>>> +                     mutex_unlock(lock);
>>>       }
>>>       return v4l2_fh_release(file);
>>>  }
>>> +
>>> +int vb2_fop_release(struct file *file)
>>> +{
>>> +     return _vb2_fop_release(file, false);
>>> +}
>>>  EXPORT_SYMBOL_GPL(vb2_fop_release);
>>>
>>> +int __vb2_fop_release(struct file *file)
>>> +{
>>> +     return _vb2_fop_release(file, true);
>>> +}
>>> +EXPORT_SYMBOL_GPL(__vb2_fop_release);
>>
>> Sorry for introducing yet another opinion, but I think this is very confusing.
> 
> It is confusing the lock_held parameter or the __ naming for unlocked versions?
> 
>>
>> I would do this:
>>
>> static int __vb2_fop_release(struct file *file, struct mutex *lock)
>> {
>>         struct video_device *vdev = video_devdata(file);
>>
>>         if (file->private_data == vdev->queue->owner) {
>>                 if (lock)
>>                         mutex_lock(lock);
>>                 vb2_queue_release(vdev->queue);
>>                 vdev->queue->owner = NULL;
>>                 if (lock)
>>                         mutex_unlock(lock);
>>         }
>>         return v4l2_fh_release(file);
>> }
>>
>> int vb2_fop_release(struct file *file)
>> {
>>         struct video_device *vdev = video_devdata(file);
>>         struct mutex *lock = vdev->queue->lock ?
>>                                 vdev->queue->lock : vdev->lock;
>>
>>         return __vb2_fop_release(file, lock);
>> }
>> EXPORT_SYMBOL_GPL(vb2_fop_release);
>>
>> int vb2_fop_release_unlock(struct file *file)
>> {
>>         return __vb2_fop_release(file, NULL);
>> }
>> EXPORT_SYMBOL_GPL(vb2_fop_release_unlock);
>>
>> Optionally, __vb2_fop_release can be exported and then vb2_fop_release_unlock
>> isn't necessary.
>>
> 
> i dont have any strong opinion in any direction. All I really care is
> that the oops is fixed :).
> 
> If your concern about the patch is the is_lock_held function, I can
> make a patch with the params on your proposal and the __naming as
> Sylvester suggested, so everyone is happy.
> 
> Sylvester, Hanshat do you think?

I like Hans' proposal, probably it's better to export __vb2_fop_release(),
so it can be also used in cases like em28xx, to make things a bit more
clear. But I'm fine with vb2_fop_release_unlock() as well, don't really
have strong preference. It's up to you.

--
Thanks,
Sylwester
