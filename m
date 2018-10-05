Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36661 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbeJEQNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 12:13:08 -0400
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
 <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
 <CAC5umygWnJOOd3efR1FVK=4660+aYiDg0U+GAqEXzzLgi7h6Yw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <80911eb7-c777-b8a4-8c24-a1f60fd30863@xs4all.nl>
Date: Fri, 5 Oct 2018 11:15:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAC5umygWnJOOd3efR1FVK=4660+aYiDg0U+GAqEXzzLgi7h6Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/18 18:17, Akinobu Mita wrote:
> 2018年10月1日(月) 18:40 Hans Verkuil <hverkuil@xs4all.nl>:
>>
>> On 09/23/2018 06:34 PM, Akinobu Mita wrote:
>>> The video_i2c_data is allocated by kzalloc and released by the video
>>> device's release callback.  The release callback is called when
>>> video_unregister_device() is called, but it will still be accessed after
>>> calling video_unregister_device().
>>>
>>> Fix the use after free by allocating video_i2c_data by devm_kzalloc() with
>>> i2c_client->dev so that it will automatically be released when the i2c
>>> driver is removed.
>>
>> Hmm. The patch is right, but the explanation isn't. The core problem is
>> that vdev.release was set to video_i2c_release, but that should only be
>> used if struct video_device was kzalloc'ed. But in this case it is embedded
>> in a larger struct, and then vdev.release should always be set to
>> video_device_release_empty.
>>
>> That was the real reason for the invalid access.
> 
> How about the commit log below?
> 
> struct video_device for video-i2c is embedded in a struct video_i2c_data,
> and then vdev.release should always be set to video_device_release_empty.
> 
> However, the vdev.release is currently set to video_i2c_release which
> frees the whole struct video_i2c_data.  In video_i2c_remove(), some fields
> (v4l2_dev, lock, and queue_lock) in struct video_i2c_data are still
> accessed after video_unregister_device().
> 
> This fixes the use after free by setting the vdev.release to
> video_device_release_empty.  Also, convert to use devm_kzalloc() for
> allocating a struct video_i2c_data in order to simplify the code.
> 

Looks good.

Regards,

	Hans
