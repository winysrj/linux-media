Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:42515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0LYOJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 09:09:50 -0500
Message-ID: <4D15FB27.7080302@redhat.com>
Date: Sat, 25 Dec 2010 12:09:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D14B106.2000502@redhat.com> <201012241954.35906.hverkuil@xs4all.nl> <4D15B5ED.8020801@redhat.com>
In-Reply-To: <4D15B5ED.8020801@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 25-12-2010 07:14, Mauro Carvalho Chehab escreveu:
> Em 24-12-2010 16:54, Hans Verkuil escreveu:
>> On Friday, December 24, 2010 15:41:10 Hans de Goede wrote:
>>> Hi,
>>>
>>> On 12/24/2010 03:20 PM, Hans Verkuil wrote:
>>>> On Friday, December 24, 2010 15:19:26 Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
>>>>>> Hans V/Hans G,
>>>>>>
>>>>>> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
>>>>>> all info, if you change the video device. On my tests with uvcvideo (video0)
>>>>>> and a gspca camera (pac7302, video1), it was showing the supported formats
>>>>>> for the uvcvideo camera when I changed from video0 to video1.
>>>>>>
>>>>>> The net result is that the image were handled with the wrong decoder
>>>>>> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
>>>>>> a wrong decoding.
>>>>>>
>>>>>> Could you please take a look on it?

<snip>

>> I wonder if Mauro got confused by the different behavior as well.
> 
> I think I used the libv4l way. I'll re-try on both modes. This way, we'll know for sure if
> the issue is at libv4l or not.

Double checked: when opening in raw mode, everything works fine. However, when
opening with "libv4l" mode, it doesn't update the supported formats.

Cheers,
Mauro
