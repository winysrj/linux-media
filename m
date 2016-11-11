Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49652
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934789AbcKKAfW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 19:35:22 -0500
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device
 dynamically
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1698237.M9v6idgxsX@avalon>
 <87a7cdf5-7964-8a5a-51a8-bd2d440d3f8d@osg.samsung.com>
 <2592222.PCoxoX7ZGe@avalon>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <28c6d507-5a71-a551-268c-ba6143e222e5@osg.samsung.com>
Date: Thu, 10 Nov 2016 17:35:18 -0700
MIME-Version: 1.0
In-Reply-To: <2592222.PCoxoX7ZGe@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2016 05:19 PM, Laurent Pinchart wrote:
> Hi Shuah,
> 
> On Thursday 10 Nov 2016 17:16:31 Shuah Khan wrote:
>> On 11/10/2016 05:11 PM, Laurent Pinchart wrote:
>>> On Thursday 10 Nov 2016 17:00:16 Shuah Khan wrote:
>>>> On 11/10/2016 04:53 PM, Laurent Pinchart wrote:
>>>>> On Tuesday 08 Nov 2016 12:20:29 Shuah Khan wrote:
>>>>>> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus wrote:
>>>>>>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>>>>>>
>>>>>>> Allow allocating the media device dynamically. As the struct
>>>>>>> media_device embeds struct media_devnode, the lifetime of that object
>>>>>>> is that same than that of the media_device.
>>>>>>>
>>>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>>>> ---
>>>>>>>
>>>>>>>  drivers/media/media-device.c | 15 +++++++++++++++
>>>>>>>  include/media/media-device.h | 13 +++++++++++++
>>>>>>>  2 files changed, 28 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/media/media-device.c
>>>>>>> b/drivers/media/media-device.c
>>>>>>> index a31329d..496195e 100644
>>>>>>> --- a/drivers/media/media-device.c
>>>>>>> +++ b/drivers/media/media-device.c
>>>>>>> @@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL_GPL(media_device_init);
>>>>>>>
>>>>>>> +struct media_device *media_device_alloc(struct device *dev)
>>>>>>> +{
>>>>>>> +       struct media_device *mdev;
>>>>>>> +
>>>>>>> +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>>>>>>> +       if (!mdev)
>>>>>>> +               return NULL;
>>>>>>> +
>>>>>>> +       mdev->dev = dev;
>>>>>>> +       media_device_init(mdev);
>>>>>>> +
>>>>>>> +       return mdev;
>>>>>>> +}
>>>>>>> +EXPORT_SYMBOL_GPL(media_device_alloc);
>>>>>>> +
>>>>>>
>>>>>> One problem with this allocation is, this media device can't be shared
>>>>>> across drivers. For au0828 and snd-usb-audio should be able to share
>>>>>> the media_device. That is what the Media Allocator API patch series
>>>>>> does.
>>>>>
>>>>> No disagreement here, Sakari's patches don't address the issues that the
>>>>> media allocator API fixes. The media allocator API, when ready, should
>>>>> replace (or at least complement, if we decide to keep a simpler API for
>>>>> drivers that don't need to share a media device, but I have no opinion
>>>>> on this at this time) this allocation function.
>>>>
>>>> Media Device Allocator API is ready and reviewed. au0828 uses it as the
>>>> first driver using it. I will be sending out snd-usb-audio patch soon
>>>> that makes use of the shared media device.
>>>
>>> I don't think it would be too difficult to rebase this series on top of
>>> the media allocator API, as all that is needed here is a way to
>>> dynamically allocate the media device in a clean fashion. I don't think
>>> Sakari's patches depend on a specific implementation of
>>> media_device_alloc(). Sakari, please let me know if I got this wrong.
>>
>> Media Device Allocator API is independent as well. It doesn't make any
>> assumptions on media_device register and doesn't care really whether it
>> is shared or not. So I think Sakari's work can use the Media Device
>> Allocator API instead of the allocator routine it is adding.
> 
> I think you're right, and the goal is certainly to merge both. The question is 
> just which series should go in first. I have no strong opinion on that, 
> whichever series is ready first can probably get merged first. I'd just like 
> to get a confirmation from Sakari that both orders would be equally fine.
> 
> This being said, I'd of course like to test the combination of both series to 
> make sure neither introduce an issue for the other one.

Audio maintainer has been waiting for the snd-usb-audio media controller api
work to use it as a reference for changing other drivers to use media controller
api.

I have an urgency here to get the snd-usb-audio. So I am going to work
towards getting Media Device Allocator API, au0828, and snd-usb-audio patches
that uses Media Device Allocator API into 4.10

Sakari's work could take longer as it requires driver changes. So I am going
to assume, it will happen after the work I am doing.

thanks,
-- Shuah

