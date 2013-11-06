Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:55588 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3KFI0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 03:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <5277BB1F.1010501@xs4all.nl>
References: <1383385994-11422-1-git-send-email-ricardo.ribalda@gmail.com>
 <527794F0.40901@xs4all.nl> <CAPybu_0cKxMxhXoSqbK2nTyX3DGCVZdUZPt2bTE6aZR65xDG=w@mail.gmail.com>
 <5277AB62.5000505@xs4all.nl> <5277AE1A.6090303@samsung.com> <5277BB1F.1010501@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 6 Nov 2013 09:26:16 +0100
Message-ID: <CAPybu_3rnWU7puF4PQChXMXVo8sRC=Rh6cghxu6kOTX+s2h3mw@mail.gmail.com>
Subject: Re: [PATCH v4] videobuf2: Add missing lock held on vb2_fop_relase
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
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

Hello Hans and Sywester

I have just posted a new patch. I think it fits the suggestions from
both of you, please take a look to it and please post any comment.

I will also send a patch about the em28xx, to swap the lock order.

Thanks for your comments

On Mon, Nov 4, 2013 at 4:19 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/04/2013 03:24 PM, Sylwester Nawrocki wrote:
>> On 04/11/13 15:12, Hans Verkuil wrote:
>>> On 11/04/2013 02:54 PM, Ricardo Ribalda Delgado wrote:
>>>>> Hello Hans
>>>>>
>>>>> Thanks for your comments.
>>>>>
>>>>> Please take a look to v4 of this patch
>>>>> https://patchwork.linuxtv.org/patch/20529/
>>>>>
>>>>> On Mon, Nov 4, 2013 at 1:37 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>>>> On 11/02/2013 10:53 AM, Ricardo Ribalda Delgado wrote:
>>>>>>>>> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>>>>>>>>
>>>>>>>>> vb2_fop_relase does not held the lock although it is modifying the
>>>>>>>>> queue->owner field.
>>>>>>>>>
>>>>>>>>> This could lead to race conditions on the vb2_perform_io function
>>>>>>>>> when multiple applications are accessing the video device via
>>>>>>>>> read/write API:
>>>>>>>
>>>>>>> It's also called directly by drivers/media/usb/em28xx/em28xx-video.c!
>>>>>>>
>>>>>
>>>>> em28xx-video does not hold the lock, therefore it can call the normal
>>>>> function. On v2 we made a internal function that should be called if
>>>>> the funciton is called directly by the driver. Please take a look to
>>>>> the old comments. https://patchwork.linuxtv.org/patch/20460/
>>>
>>> static int em28xx_v4l2_close(struct file *filp)
>>> {
>>>         struct em28xx_fh *fh  = filp->private_data;
>>>         struct em28xx    *dev = fh->dev;
>>>         int              errCode;
>>>
>>>         em28xx_videodbg("users=%d\n", dev->users);
>>>
>>>         mutex_lock(&dev->lock);
>>>         vb2_fop_release(filp);
>>>      ...
>>>
>>> vb2_fop_release(filp) will, with your patch, also try to get dev->lock.
>>>
>>> Sylwester's comment re em28xx is incorrect.
>>
>> dev->lock is not used as the video queue lock:
>>
>> $ git grep "lock =" drivers/media/usb/em28xx/
>> ...
>> drivers/media/usb/em28xx/em28xx-video.c:        dev->vdev->queue->lock = &dev->vb_queue_lock;
>> drivers/media/usb/em28xx/em28xx-video.c:                dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
>>
>> There is a separate mutex for the video queue which needs to be acquired
>> independently.
>
> Darn, I missed that one. I was looking for it in em28xx_vdev_init(), which is
> where I expected the queue->lock to be set, if there was any.
>
> That said, wouldn't it be a good idea to swap the order:
>
>         vb2_fop_release(filp);
>         mutex_lock(&dev->lock);
>
> I don't believe there is a good reason for nesting mutexes here.
>
> Regards,
>
>         Hans
>
>>
>> --
>> Regards,
>> Sylwester
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Ricardo Ribalda
