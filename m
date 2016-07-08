Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:46140 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbcGHOMG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 10:12:06 -0400
Message-ID: <577FA569.7070300@ispras.ru>
Date: Fri, 08 Jul 2016 17:06:49 +0400
From: Pavel Andrianov <andrianov@ispras.ru>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Vladis Dronov <vdronov@redhat.com>,
	Insu Yun <wuninsu@gmail.com>, Oliver Neukum <oneukum@suse.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vaishali Thakkar <vaishali.thakkar@oracle.com>,
	ldv-project@linuxtesting.org
Subject: Re: A potential race
References: <57727001.7040606@ispras.ru> <577680B3.5010901@ispras.ru> <8c161772-d2d9-0897-7f76-40caea5f0a93@xs4all.nl> <577685EE.1050704@ispras.ru> <efc6a5f7-00c7-b26c-074e-f7510adc3f60@xs4all.nl>
In-Reply-To: <efc6a5f7-00c7-b26c-074e-f7510adc3f60@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

We have no hardware to test possible fixes. If somebody has it and 
agrees to check our patches, we will prepare them.

Best regards,
Pavel

01.07.2016 20:17, Hans Verkuil пишет:
> On 07/01/2016 05:02 PM, Pavel Andrianov wrote:
>> 01.07.2016 19:53, Hans Verkuil пишет:
>>> On 07/01/2016 04:39 PM, Pavel Andrianov wrote:
>>>>    Hi!
>>>>
>>>> There is a potential race condition between usbvision_v4l2_close and usbvision_disconnect. The possible scenario may be the following. usbvision_disconnect starts execution, assigns usbvision->remove_pending = 1, and is interrupted
>>>> (rescheduled) after mutex_unlock. After that usbvision_v4l2_close is executed, decrease usbvision->user-- , checks usbvision->remove_pending, executes usbvision_release and finishes. Then usbvision_disconnect continues its execution. It checks
>>>> usbversion->user (it is already 0) and also execute usbvision_release. Thus, release is executed twice. The same situation may
>>>> occur if usbvision_v4l2_close is interrupted by usbvision_disconnect. Moreover, the same problem is in usbvision_radio_close. In all these cases the check before call usbvision_release under mutex_lock protection does not solve the problem, because  there may occur an open() after the check and the race takes place again. The question is: why the usbvision_release
>>>> is called from close() (usbvision_v4l2_close and usbvision_radio_close)? Usually release functions are called from
>>>> disconnect.
>>> Please don't use html mail, mailinglists will silently reject this.
>>>
>>> The usbvision driver is old and unloved and known to be very bad code. It needs a huge amount of work to make all this work correctly.
>>>
>>> I don't see anyone picking this up...
>>>
>>> Regards,
>>>
>>> 	Hans
>> If you know the driver, could you, please, explain me, why
>> usbvision_release is called from close functions (usbvision_v4l2_close
>> and usbvision_radio_close) and not only from disconnect? Thanks!
>>
> Because the author didn't know what he was doing. Although, to be fair, we have much better
> solutions for this. But who is willing to put in the time to fix this properly?
>
> The basic idea was: if someone still has a video/radio node open when disconnect happens, then
> we leave it to the last close to call release, otherwise we can call release right away.
>
> It needs to be rewritten.
>
> If you're volunteering to clean this up, then I can give pointers.
>
> Regards,
>
> 	Hans


-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru

