Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:42457 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752226AbeEPK1t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 06:27:49 -0400
Subject: Re: [PATCH] [Patch v2] usbtv: Fix refcounting mixup
To: Oliver Neukum <oneukum@suse.com>, ben.hutchings@codethink.co.uk,
        gregkh@linuxfoundation.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20180515130744.19342-1-oneukum@suse.com>
 <85dd974b-c251-47a5-600d-77b009e2dfcd@xs4all.nl>
 <1526399190.31771.2.camel@suse.com>
 <1ee4b00d-9a55-92cf-e708-1e0c60ca4bfd@xs4all.nl>
 <1526462623.25281.5.camel@suse.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4550f8e2-38a9-b1f4-0277-25e79fed2e14@xs4all.nl>
Date: Wed, 16 May 2018 12:27:32 +0200
MIME-Version: 1.0
In-Reply-To: <1526462623.25281.5.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/16/18 11:23, Oliver Neukum wrote:
> Am Dienstag, den 15.05.2018, 18:01 +0200 schrieb Hans Verkuil:
>> On 05/15/2018 05:46 PM, Oliver Neukum wrote:
>>> Am Dienstag, den 15.05.2018, 16:28 +0200 schrieb Hans Verkuil:
>>>> On 05/15/18 15:07, Oliver Neukum wrote:
> 
>>>>>  usbtv_audio_fail:
>>>>>  	/* we must not free at this point */
>>>>> -	usb_get_dev(usbtv->udev);
>>>>> +	v4l2_device_get(&usbtv->v4l2_dev);
>>>>
>>>> This is very confusing. I think it is much better to move the
>>>
>>> Yes. It confused me.
>>>
>>>> v4l2_device_register() call from usbtv_video_init to this probe function.
>>>
>>> Yes, but it is called here. So you want to do it after registering the
>>> audio?
>>
>> No, before. It's a global data structure, so this can be done before the
>> call to usbtv_video_init() as part of the top-level initialization of the
>> driver.
> 
> Eh, but we cannot create a V4L device before the first device
> is connected and we must certainly create multiple V4L devices if
> multiple physical devices are connected.

v4l2_device_register is a terrible name. It does not create devices
or register with anything, it just initializes a root data structure. I have
proposed renaming this to v4l2_root_init() in the past, but people didn't
want a big rename action.

BTW, with 'global data structure' I meant a data structure in struct usbtv.
All I meant to say is that v4l2_device_register should be called in probe(),
not in usbtv_video_init().

Regards,

	Hans

> 
> Maybe I am dense. Please elaborate.
> It seem to me that the driver is confusing because it uses
> multiple refcounts.
> 
> 	Regards
> 		Oliver
> 
