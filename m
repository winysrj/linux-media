Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37627 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJJIHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 04:07:49 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND700C16YP4FV60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Oct 2014 09:10:16 +0100 (BST)
Message-id: <543793B9.4020100@samsung.com>
Date: Fri, 10 Oct 2014 10:07:21 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
 <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
 <54353124.1060704@redhat.com> <54353AA3.3040506@samsung.com>
 <54364566.9030102@redhat.com>
In-reply-to: <54364566.9030102@redhat.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/09/2014 10:20 AM, Hans de Goede wrote:
> Hi,
>
> On 10/08/2014 03:22 PM, Jacek Anaszewski wrote:
>> Hi Hans,
>>
>> On 10/08/2014 02:42 PM, Hans de Goede wrote:
>
> <snip>
>
>>>> +    }
>>>> +
>>>> +    /* refresh device topology data after linking */
>>>> +    release_entities(mdev);
>>>> +
>>>> +    ret = get_device_topology(mdev);
>>>> +
>>>> +    /* close media device fd as it won't be longer required */
>>>> +    close(mdev->media_fd);
>>>> +
>>>> +    if (ret < 0)
>>>> +        goto err_get_dev_topology;
>>>> +
>>>> +    /* discover a pipeline for the capture device */
>>>> +    ret = discover_pipeline_by_fd(mdev, fd);
>>>> +    if (ret < 0)
>>>> +        goto err_discover_pipeline;
>>>
>>> There does not seem to be any code here to ensure that this plugin does
>>> not bind to non exonys4 fimc devices. Please fix that.
>>
>> There is. Please look above at the
>>
>> "if (!capture_entity(media_entity_name))" condition above.
>
> I already checked that, that just checks for the string "capture", which is
> way too generic, please add a more narrow guard.

While making cleanup I mistakenly removed checking for the driver name
after QUERYCAP in the beginning of plugin_init. Will fix it in the next
version.

Regards,
Jacek
