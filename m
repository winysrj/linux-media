Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15202 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422732AbbD2I6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 04:58:25 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NNK00IQW8XAY090@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Apr 2015 09:58:22 +0100 (BST)
Message-id: <55409D2C.8050007@samsung.com>
Date: Wed, 29 Apr 2015 10:58:20 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: S_CTRL must be called twice  to set volatile controls
References: <5540895A.5060102@samsung.com> <55408DE7.3020906@cisco.com>
In-reply-to: <55408DE7.3020906@cisco.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/29/2015 09:53 AM, Hans Verkuil wrote:
> Hi Jacek,
>
> On 04/29/15 09:33, Jacek Anaszewski wrote:
>> Hi,
>>
>> After testing my v4l2-flash helpers patch [1] with the recent patches
>> for v4l2-ctrl.c ([2] and [3]) s_ctrl op isn't called despite setting
>> the value that should be aligned to the other step than default one.
>>
>> This happens for V4L2_CID_FLASH_TORCH_INTENSITY control with
>> V4L2_CTRL_FLAG_VOLATILE flag.
>>
>> The situation improves after setting V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
>> flag for the control. Is this flag required now for volatile controls
>> to be writable?
>
> Yes, you need that if you want to be able to write to a volatile control.
>
> It was added for exactly that purpose.

Thanks for the explanation.

> Why is V4L2_CID_FLASH_TORCH_INTENSITY volatile? Volatile typically only
> makes sense if the hardware itself is modifying the value without the
> software knowing about it.

This can be the case for the flash LED devices that can reduce torch
current when battery voltage level falls below predefined threshold.

-- 
Best Regards,
Jacek Anaszewski
