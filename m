Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:3580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0LYIy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 03:54:29 -0500
Message-ID: <4D15B140.4090300@redhat.com>
Date: Sat, 25 Dec 2010 06:54:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com> <4D14ABEE.40206@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D14B106.2000502@redhat.com>
In-Reply-To: <4D14B106.2000502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 24-12-2010 12:41, Hans de Goede escreveu:
> Hi,
> 
> On 12/24/2010 03:20 PM, Hans Verkuil wrote:
>> On Friday, December 24, 2010 15:19:26 Hans de Goede wrote:
>>> Hi,
>>>
>>> On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
>>>> Hans V/Hans G,
>>>>
>>>> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
>>>> all info, if you change the video device. On my tests with uvcvideo (video0)
>>>> and a gspca camera (pac7302, video1), it was showing the supported formats
>>>> for the uvcvideo camera when I changed from video0 to video1.
>>>>
>>>> The net result is that the image were handled with the wrong decoder
>>>> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
>>>> a wrong decoding.
>>>>
>>>> Could you please take a look on it?
>>>
>>> I'm pretty sure this is not a libv4l issue (other apps which allows witching
>>> the source work fine), but rather a qv4l2 problem, esp. as it uses libv4lconvert
>>> directly rather then going through libv4l (iirc).
>>
>> And I'm pretty sure it isn't a qv4l2 issue :-)
>>
>> For the record: qv4l2 can open a device node either in 'raw' mode bypassing libv4l
>> and using v4lconvert to convert unsupported pixformats, or in 'wrapped' mode where
>> libv4l is used for all device node accesses.
>>
> 
> Interesting, how does it switch between the modes? Mauro were you using wrapped mode
> or raw mode when you saw this ?

I have no idea, as I also didn't know about this feature, nor how to switch from one
mode to the other ;)
> 
> Regards,
> 
> hans

