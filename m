Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:7089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0L1Wqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 17:46:46 -0500
Message-ID: <4D1A6A54.8050401@redhat.com>
Date: Tue, 28 Dec 2010 23:53:08 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D14B106.2000502@redhat.com> <201012241954.35906.hverkuil@xs4all.nl> <4D15B5ED.8020801@redhat.com> <4D15FB27.7080302@redhat.com>
In-Reply-To: <4D15FB27.7080302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/25/2010 03:09 PM, Mauro Carvalho Chehab wrote:
> Em 25-12-2010 07:14, Mauro Carvalho Chehab escreveu:
>> Em 24-12-2010 16:54, Hans Verkuil escreveu:
>>> On Friday, December 24, 2010 15:41:10 Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 12/24/2010 03:20 PM, Hans Verkuil wrote:
>>>>> On Friday, December 24, 2010 15:19:26 Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
>>>>>>> Hans V/Hans G,
>>>>>>>
>>>>>>> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
>>>>>>> all info, if you change the video device. On my tests with uvcvideo (video0)
>>>>>>> and a gspca camera (pac7302, video1), it was showing the supported formats
>>>>>>> for the uvcvideo camera when I changed from video0 to video1.
>>>>>>>
>>>>>>> The net result is that the image were handled with the wrong decoder
>>>>>>> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
>>>>>>> a wrong decoding.
>>>>>>>
>>>>>>> Could you please take a look on it?
>
> <snip>
>
>>> I wonder if Mauro got confused by the different behavior as well.
>>
>> I think I used the libv4l way. I'll re-try on both modes. This way, we'll know for sure if
>> the issue is at libv4l or not.
>
> Double checked: when opening in raw mode, everything works fine. However, when
> opening with "libv4l" mode, it doesn't update the supported formats.
>

I've spend some time looking at this, with interesting results. There is a bug
in libv4lconvert, which gets exposed when using qv4l2 with a pac7311 camera
(no need to first open another type of device).

As suspected, qv4l2 tries to call into libv4lconvert directly even when going
through libv4l. So what happens is:
1) qv4l2 sees rgb24 as a format supported by the device and selects it
    (because of libv4l2 being used)
2) qv4l2 still tries to use libv4lconvert directly and ends up setting up
    conversion from rgb24 to rgb24 (the conversion from pjpg to rgb24 is
    already done transparently by libv4l)
3) libv4lconvert (or rather libv4lcontrol which is part of libv4lconvert)
    enables software whitebalancing by default on pac7311 cameras

libv4lconvert has special code to detect src_fmt == dest_fmt and just do
a memcpy, however this code does not trigger because of 3 (as when doing
processing just a memcpy is not what we want). However libv4lconvert
API is based on providing a src and destination buffer, and in this case
libv4lconvert_convert ends up skipping all steps (conversion, cropping,
flipping and rotating) except for processing, and the processing code
works by modifying the buffer it is passed rather then using a separate
input output buffer, so since none of the other separate input output
buffer needing steps where done, the data never gets copied to the
destination buffer!

I've just pushed a patch to v4l-utils git fixing this bug.

Note that qv4l2 should still be fixed to not call libv4lconvert directly
when not in raw mode (instead it should just do a s_fmt rgb24, which
libv4l will always offer for all supported devices), as the way things
are now libv4lconvert_convert ends up getting called twice. Which will
lead to various software processing steps being done twice, which
is not a problem for whitebalance, but it makes software vflip and
hflip no-ops. And for cameras which need 90 degrees rotation (pac7302)
it will completely screw up the image.

In general an app can either use libv4lconvert directly, or call
libv4l2 functions and let it deal with handling conversion transparently
using both at the same time is not supported.

Regards,

Hans
