Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35814 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753959AbdGUKSQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:18:16 -0400
Subject: Re: [PATCH 1/4] media-device: set driver_version in media_device_init
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170721090234.6501-1-hverkuil@xs4all.nl>
 <20170721090234.6501-2-hverkuil@xs4all.nl> <3878230.p4nklYSnFj@avalon>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eb1eebeb-930b-3ff9-4360-ce242affd7a3@xs4all.nl>
Date: Fri, 21 Jul 2017 12:18:11 +0200
MIME-Version: 1.0
In-Reply-To: <3878230.p4nklYSnFj@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/07/17 12:12, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 21 Jul 2017 11:02:31 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Set the driver_version to LINUX_VERSION_CODE in the media_device_init
>> call, just as the other media subsystems do.
>>
>> There is no point in doing anything else, since version numbers that
>> are set by drivers are never, ever updated. LINUX_VERSION_CODE will
>> be updated, and is also set correctly when backporting the media
>> subsystem to an older kernel using the media_build system.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Wouldn't it be even better to drop the driver_version field completely from 
> struct media_device, as it's now hardcoded ?

True, good point. I'll change this.

Regards,

	Hans

> 
>> ---
>>  drivers/media/media-device.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index fce91b543c14..2beffe3e3464 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -681,6 +681,7 @@ void media_device_init(struct media_device *mdev)
>>  	INIT_LIST_HEAD(&mdev->entity_notify);
>>  	mutex_init(&mdev->graph_mutex);
>>  	ida_init(&mdev->entity_internal_idx);
>> +	mdev->driver_version = LINUX_VERSION_CODE;
>>
>>  	dev_dbg(mdev->dev, "Media device initialized\n");
>>  }
>> @@ -833,8 +834,6 @@ void media_device_pci_init(struct media_device *mdev,
>>  	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
>>
>>  			    | pci_dev->subsystem_device;
>>
>> -	mdev->driver_version = LINUX_VERSION_CODE;
>> -
>>  	media_device_init(mdev);
>>  }
>>  EXPORT_SYMBOL_GPL(media_device_pci_init);
>> @@ -862,7 +861,6 @@ void __media_device_usb_init(struct media_device *mdev,
>>  		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
>>  	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
>>  	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
>> -	mdev->driver_version = LINUX_VERSION_CODE;
>>
>>  	media_device_init(mdev);
>>  }
> 
