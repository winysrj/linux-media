Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35928
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755212AbcKOAN6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 19:13:58 -0500
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device
 dynamically
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Shuah Khan <shuahkhan@gmail.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
 <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
 <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
 <20161114134049.GS3217@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <06878b75-8a8e-cb10-5f8e-819c810bf4fe@osg.samsung.com>
Date: Mon, 14 Nov 2016 17:13:52 -0700
MIME-Version: 1.0
In-Reply-To: <20161114134049.GS3217@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2016 06:40 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Tue, Nov 08, 2016 at 12:20:29PM -0700, Shuah Khan wrote:
>> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus
>> <sakari.ailus@linux.intel.com> wrote:
>>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>>
>>> Allow allocating the media device dynamically. As the struct media_device
>>> embeds struct media_devnode, the lifetime of that object is that same than
>>> that of the media_device.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
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
>> One problem with this allocation is, this media device can't be shared across
>> drivers. For au0828 and snd-usb-audio should be able to share the
>> media_device. That is what the Media Allocator API patch series does.
>> This a quick review and I will review the patch series and get back to
>> you.
> 
> The assumption has always been there that a media device has a single struct
> device related to it. It hasn't been visible in the function call API
> though, just in the data structures.
> 
> I have to admit I may have forgotten something that was discussed back then,
> but do you need to share the same media device over multiple devices in the
> system? I don't see that at least in the allocator patch itself. It's
> "[PATCH v3] media: Media Device Allocator API", isn't it?
> 


Hi Sakari,

Remember the work I am doing that adds Media Controller API to snd-usb-audio
and au0828 so they can share the media resources. That is where we need the
media device sharable. Please see the following: this patch series includes
the API and au0828 change to use it. I tested it with snd-usb-audio change,
didn't include it at that time.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg98793.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97779.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97704.html

I am going to be sending the rebased Media Device Allocator patches with both
au0828 and snd-usb-audio using it in a couple of days. No code changes, just
rebased to Linux 4.9-rc4

thanks,
-- Shuah
