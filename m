Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24862 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbcLIHoA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 02:44:00 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OHW00DMNQT9VJ50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Dec 2016 07:43:57 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 4/7] mediactl: Add media_device creation
 helpers
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <befbb8c5-fa9a-c47c-2397-9c50f597725f@samsung.com>
Date: Fri, 09 Dec 2016 08:43:55 +0100
MIME-version: 1.0
In-reply-to: <20161208230507.GI16630@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-5-git-send-email-j.anaszewski@samsung.com>
 <20161124121731.GF16630@valkosipuli.retiisi.org.uk>
 <9fb6265e-db41-21db-4cd6-7f14092b0920@gmail.com>
 <CGME20161208230551epcas2p384b8f2418a7c2d1251b975762493deeb@epcas2p3.samsung.com>
 <20161208230507.GI16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hhi Sakari,

On 12/09/2016 12:05 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Dec 08, 2016 at 11:04:20PM +0100, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> On 11/24/2016 01:17 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Thanks for the patchset.
>>>
>>> On Wed, Oct 12, 2016 at 04:35:19PM +0200, Jacek Anaszewski wrote:
>>>> Add helper functions that allow for easy instantiation of media_device
>>>> object basing on whether the media device contains v4l2 subdev with
>>>> given file descriptor.
>>>
>>> Doesn't this work with video nodes as well? That's what you seem to be using
>>> it for later on. And I think that's actually more useful.
>>>
>>> The existing implementation uses udev to look up devices. Could you use
>>> libudev device enumeration API to find the media devices, and fall back to
>>> sysfs if udev doesn't work? There seems to be a reasonable-looking example
>>> here:
>>>
>>> <URL:http://stackoverflow.com/questions/25361042/how-to-list-usb-mass-storage-devices-programatically-using-libudev-in-linux>
>>
>> Actually I am calling media_get_devname_udev() at first and falling back
>> to sysfs similarly as it is accomplished in media_enum_entities().
>> Is there any specific reason for which I should use libudev device
>> enumeration API in media_device_new_by_subdev_fd()?
>
> Yes. You rely on the API udev provides; the sysfs implementation is just a
> fallback in case udev isn't available in the system. I guess it'd mostly
> work but, for instance, you assume sysfs is found under /sys. The sysfs
> itself isn't one of the most stable APIs either. Udev is a simply better
> option when it's there.

Thanks for clarifying that. I'll check the libudev device enumeration
API then.

-- 
Best regards,
Jacek Anaszewski
