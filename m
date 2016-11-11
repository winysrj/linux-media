Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49474
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935365AbcKKAA4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 19:00:56 -0500
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device
 dynamically
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkhan@gmail.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
 <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
 <4251827.ADF06xmuSS@avalon>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <2d71d705-bfd4-696d-52ff-c5a043eed158@osg.samsung.com>
Date: Thu, 10 Nov 2016 17:00:16 -0700
MIME-Version: 1.0
In-Reply-To: <4251827.ADF06xmuSS@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2016 04:53 PM, Laurent Pinchart wrote:
> Hi Shuah,
> 
> On Tuesday 08 Nov 2016 12:20:29 Shuah Khan wrote:
>> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus wrote:
>>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>>
>>> Allow allocating the media device dynamically. As the struct media_device
>>> embeds struct media_devnode, the lifetime of that object is that same than
>>> that of the media_device.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>
>>>  drivers/media/media-device.c | 15 +++++++++++++++
>>>  include/media/media-device.h | 13 +++++++++++++
>>>  2 files changed, 28 insertions(+)
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index a31329d..496195e 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(media_device_init);
>>>
>>> +struct media_device *media_device_alloc(struct device *dev)
>>> +{
>>> +       struct media_device *mdev;
>>> +
>>> +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>>> +       if (!mdev)
>>> +               return NULL;
>>> +
>>> +       mdev->dev = dev;
>>> +       media_device_init(mdev);
>>> +
>>> +       return mdev;
>>> +}
>>> +EXPORT_SYMBOL_GPL(media_device_alloc);
>>> +
>>
>> One problem with this allocation is, this media device can't be shared
>> across drivers. For au0828 and snd-usb-audio should be able to share the
>> media_device. That is what the Media Allocator API patch series does.
> 
> No disagreement here, Sakari's patches don't address the issues that the media 
> allocator API fixes. The media allocator API, when ready, should replace (or 
> at least complement, if we decide to keep a simpler API for drivers that don't 
> need to share a media device, but I have no opinion on this at this time) this 
> allocation function.

Media Device Allocator API is ready and reviewed. au0828 uses it as the first
driver using it. I will be sending out snd-usb-audio patch soon that makes use
of the shared media device.

thanks,
-- Shuah

> 
>> This a quick review and I will review the patch series and get back to
>> you.
>>
>>>  void media_device_cleanup(struct media_device *mdev)
>>>  {
>>>         ida_destroy(&mdev->entity_internal_idx);
>>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>>> index 96de915..c9b5798 100644
>>> --- a/include/media/media-device.h
>>> +++ b/include/media/media-device.h
>>> @@ -207,6 +207,15 @@ static inline __must_check int
>>> media_entity_enum_init(
>>>  void media_device_init(struct media_device *mdev);
>>>  
>>>  /**
>>> + * media_device_alloc() - Allocate and initialise a media device
>>> + *
>>> + * @dev:       The associated struct device pointer
>>> + *
>>> + * Allocate and initialise a media device. Returns a media device.
>>> + */
>>> +struct media_device *media_device_alloc(struct device *dev);
>>> +
>>> +/**
>>>   * media_device_cleanup() - Cleanups a media device element
>>>   *
>>>   * @mdev:      pointer to struct &media_device
>>> @@ -451,6 +460,10 @@ void __media_device_usb_init(struct media_device
>>> *mdev,
>>>                              const char *driver_name);
>>>  #else
>>> +static inline struct media_device *media_device_alloc(struct device *dev)
>>> +{
>>> +       return NULL;
>>> +}
>>>  static inline int media_device_register(struct media_device *mdev)
>>>  {
>>>         return 0;
> 

