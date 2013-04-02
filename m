Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654Ab3DBI7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Apr 2013 04:59:00 -0400
Message-ID: <515A9EA6.1080703@redhat.com>
Date: Tue, 02 Apr 2013 11:02:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xawtv: release buffer if it can't be displayed
References: <201303301047.41952.hverkuil@xs4all.nl> <201304011219.30985.hverkuil@xs4all.nl> <51599877.2050801@redhat.com> <201304011639.57747.hverkuil@xs4all.nl>
In-Reply-To: <201304011639.57747.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/01/2013 04:39 PM, Hans Verkuil wrote:
> On Mon April 1 2013 16:23:51 Hans de Goede wrote:
>> Hi,
>>
>> On 04/01/2013 12:19 PM, Hans Verkuil wrote:
>>> Hi Hans,
>>>
>>> On Sun March 31 2013 14:48:01 Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 03/30/2013 10:47 AM, Hans Verkuil wrote:
>>>>> This patch for xawtv3 releases the buffer if it can't be displayed because
>>>>> the resolution of the current format is larger than the size of the window.
>>>>>
>>>>> This will happen if the hardware cannot scale down to the initially quite
>>>>> small xawtv window. For example the au0828 driver has a fixed size of 720x480,
>>>>> so it will not display anything until the window is large enough for that
>>>>> resolution.
>>>>>
>>>>> The problem is that xawtv never releases (== calls QBUF) the buffer in that
>>>>> case, and it will of course run out of buffers and stall. The only way to
>>>>> kill it is to issue a 'kill -9' since ctrl-C won't work either.
>>>>>
>>>>> By releasing the buffer xawtv at least remains responsive and a picture will
>>>>> appear after resizing the window. Ideally of course xawtv should resize itself
>>>>> to the minimum supported resolution, but that's left as an exercise for the
>>>>> reader...
>>>>>
>>>>> Hans, the xawtv issues I reported off-list are all caused by this bug and by
>>>>> by the scaling bug introduced recently in em28xx. They had nothing to do with
>>>>> the alsa streaming, that was a red herring.
>>>>
>>>> Thanks for the debugging and for the patch. I've pushed the patch to
>>>> xawtv3.git. I've a 2 patch follow up set which should fix the issue with being
>>>> able to resize the window to a too small size.
>>>>
>>>> I'll send this patch set right after this mail, can you test it with the au0828
>>>> please?
>>>
>>> I've tested it and it is not yet working. I've tracked it down to video_gd_configure
>>> where it calls ng_ratio_fixup() which changes the cur_tv_width of 736 to 640. The
>>> height remains the same at 480.
>>
>> Thanks for testing and for figuring out where the problem lies. I've attached a
>> second version of the second patch, can you give that a try please?
>
> This is now working for au0828, but now vivi is broken... That worked fine with your
> previous patch.
>
> I'm getting:
>
> $ xawtv
> This is xawtv-3.102, running on Linux/x86_64 (3.9.0-rc1-tschai)
> ioctl: VIDIOC_QUERYMENU(id=134217731;index=2;name="Menu Item 1";reserved=0): Invalid argument
> vid-open-auto: using grabber/webcam device /dev/video0
> libv4l2: error setting pixformat: Device or resource busy
> ioctl: VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x34524742 [BGR4];fmt.pix.field=INTERLACED;fmt.pix.bytesperline=1536;fmt.pix.sizeimage=442368;fmt.pix.colorspace=SRGB;fmt.pix.priv=0): Device or resource busy
>
> Note that the QUERYMENU error is harmless, although it would be nice if xawtv
> would understand menu controls with 'holes' in the menu list.
>
> The 'Device or resource busy' errors are new and I didn't have them in your
> previous version.

After much debugging I feel it is safe to say, that these errors are not new, and not
caused by my patch. But still a good catch. They are caused by a pre-existing timing
dependent bug. I can trigger the problem both with / without my patch by simply
starting xawtv with the vivi driver a number of times, and 1 in every 2-5 times it
triggers.

I've also debugged and fixed this, see the commit message for details:
http://git.linuxtv.org/xawtv3.git/commit/f0d84401dfa392ad86d11a76dda1f722269f3eaa

I'm going to work on fixing the snapshot function with videobuf2 based drivers next,
and when that is fixed I'll do a new xawtv3 release, unless someone yells NOOO
before that time.

Regards,

Hans
