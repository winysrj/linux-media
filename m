Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1EEMRo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 08:17:44 -0400
Message-ID: <4DC29563.10007@redhat.com>
Date: Thu, 05 May 2011 09:17:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] Make the UVC API public (and minor enhancements)
References: <201104271238.03887.laurent.pinchart@ideasonboard.com> <4DC28B00.50505@redhat.com> <201105051340.26661.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105051340.26661.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 08:40, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Thursday 05 May 2011 13:33:20 Mauro Carvalho Chehab wrote:
>> Em 27-04-2011 07:38, Laurent Pinchart escreveu:
>>> Hi Mauro,
>>>
>>> These patches move the uvcvideo.h header file from
>>> drivers/media/video/uvc to include/linux, making the UVC API public.
>>> Support for the old API is kept and will be removed in 2.6.42.
>>>
>>> The following changes since commit 
> a4761a092fd3b6bf8b5f9cfe361670c86cdcc8ca:
>>>   [media] tm6000: fix vbuf may be used uninitialized (2011-04-19 21:13:59
>>>   -0300)
>>>
>>> are available in the git repository at:
>>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
>>>
>>> Laurent Pinchart (5):
>>>       uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
>>>       uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
>>>       uvcvideo: Make the API public
>>
>> Why are you declaring this twice:
>>
>> Index: patchwork/drivers/media/video/uvc/uvcvideo.h
>>
>> ...
>>
>> +#ifndef __KERNEL__
>> #define UVCIOC_CTRL_ADD     _IOW('U', 1, struct uvc_xu_control_info)
>> #define UVCIOC_CTRL_MAP_OLD _IOWR('U', 2, struct uvc_xu_control_mapping_old)
>> #define UVCIOC_CTRL_MAP     _IOWR('U', 2, struct uvc_xu_control_mapping)
>> #define UVCIOC_CTRL_GET     _IOWR('U', 3, struct uvc_xu_control)
>> #define UVCIOC_CTRL_SET     _IOW('U', 4, struct uvc_xu_control)
>> -#define UVCIOC_CTRL_QUERY   _IOWR('U', 5, struct uvc_xu_control_query)
>> +#else
>> +#define __UVCIOC_CTRL_ADD   _IOW('U', 1, struct uvc_xu_control_info)
>> +#define __UVCIOC_CTRL_MAP_OLD _IOWR('U', 2, struct 
> uvc_xu_control_mapping_old)
>> +#define __UVCIOC_CTRL_MAP   _IOWR('U', 2, struct uvc_xu_control_mapping)
>> +#define __UVCIOC_CTRL_GET   _IOWR('U', 3, struct uvc_xu_control)
>> +#define __UVCIOC_CTRL_SET   _IOW('U', 4, struct uvc_xu_control)
>> +#endif
> 
> For compatibility with existing applications. Applications should now include 
> linux/uvcvideo.h instead of drivers/media/video/uvc/uvcvideo.h, but existing 
> applications include the later. I want to make sure they will still compile. A 
> warning will be printed, and this will be removed in 2.6.42.
>> You shouldn't need to do that. In fact, the better would be to have two
>> separate headers: one with just the public API under include/linux, and
>> another with the extra uvc-internal bits, as we did in the past with
>> videobuf2.h.
> 
> That's how linux/uvcvideo.h and drivers/media/video/uvc/uvcvideo.h are 
> partitioned by this patch set, except that the private header still contains 
> userspace API to avoid breaking applications during the transition period.

Ok, so I'm understanding that, on 2.6.42, you'll be removing the checks for
__KERNEL__ from uvcvideo.h, right?


Mauro.
