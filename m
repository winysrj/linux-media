Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57870 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab3AHHpE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 02:45:04 -0500
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LaIM4-1T8iRf1Mcg-00m3PB for
 <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 08:45:01 +0100
Message-ID: <50EBCE7B.1050204@fisher-privat.net>
Date: Tue, 08 Jan 2013 08:44:59 +0100
From: Oleksij Rempel <bug-track@fisher-privat.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Peter Ross <pross@xvid.org>, linux-uvc-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [PATCH 0/2] uvcvideo: Support Logitech RGB
 Bayer formats
References: <cover.1357039246.git.pross@xvid.org> <20130102090346.GA2243@b9d1a1848204a80b27c5d574b483f38a> <50E4110B.5080905@fisher-privat.net> <2056413.0Wge1Fvauc@avalon>
In-Reply-To: <2056413.0Wge1Fvauc@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.01.2013 23:45, schrieb Laurent Pinchart:
> Hi Oleksij,
>
> (CC'ing linux-media)
>
> On Wednesday 02 January 2013 11:50:51 Oleksij Rempel wrote:
>> Am 02.01.2013 10:03, schrieb Peter Ross:
>>> On Tue, Jan 01, 2013 at 05:16:44PM +0100, Oleksij Rempel wrote:
>>>> Hi Peter,
>>>>
>>>> thank you for your work, but most of it belongs to uvcdynctrl.
>>>> You will need to add it here:
>>>> /usr/share/uvcdynctrl/data/046d/logitech.xml
>>>
>>> Using uvcdynctrl is problematic for two reasons.
>>>
>>> 1. Setting the Logitech 'disable video processing' and 'raw data bpp'
>>>     controls independently from uvcvideo causes the driver to *always* drop
>>>     frames.
>>>
>>>     uvc_video_decode_isoc() performs a sanity check on the size of incoming
>>>     uncompressed frames. It expects to receive frame sizes reported by the
>>>     8-bit yuyv 4:2:2 format description. The check fails when video
>>>     processing is disabled, because the 8-/10-bit RGB Bayer frame sizes are
>>>     always smaller.
>>>
>>> 2. Userspace applications need to distinguish the yuyv 4:2:2 format from
>>>     the the additional RGB Bayer formats.
>>>
>>>     Currently, when video processing is disabled, user applications expect
>>>     to receive yuyv 4:2:2 pixels, because thats what it and uvcvideo has
>>>     agreed to (mediate by V4L2). Instead the application receives RGB Bayer
>>>     pixels and attempts to process them as yuyv resulting in visual
>>>     garbage.
>
> One could argue that an application that explicitly disables processing would
> be able to handle that. However, I agree that point 1 is problematic, and
> point 2 is definitely not clean.
>
>>> Some of this has been discussed previously, see
>>> <http://article.gmane.org/gmane.linux.drivers.uvc.devel/3061/>.
>>>
>>> The patch tries to solve both of these problems: 1) making uvcvideo aware
>>> of the Logitech controls and recalculating the expected frame sizes, and
>>> 2) presenting the RGB Bayer formats through the V4L2 interface, so user
>>> application can request them.
>>
>> If, the problem seems to be bigger.
>> We have:
>> 1. Formats provided by usb descriptor and controlled over uvc protocol.
>> 2. Formats provided by usb descriptor and controlled over XU
>
> Do we really have devices that expose formats through the standard UVC
> descriptors but require XU access to select them ?

h264? Can be started over uvc, but mostly use less without XU.
I'll bet, if you will accept this XUs, some body will ask to add XU for 
h264.

>
>> 3. Formats controlled over XU and provided by documentation other kind
>> of knowledge.
>>
>> Last case in not properly handled by uvcvideo.ko, but IMHO it is not good
>> way to have all possible XU in driver.
>> Both problems you described should be fixed, but not in this way. If it
>> is possible - uvcdynctl should provide/update format descriptor over
>> uvc_xu_control_query interface or some other way.
>>
>> Beside, i was working on kernel space plugin system for uvcvideo driver,
>> which was probably not the best idea. How about to do some part of it in
>> userspace? For example, uvcdynctl can provide bandwidth information too.
>> This way we can fix many buggy cams without needing to permanently
>> update kernel driver.
>> Laurent?
>
> I'm really undecided here.
>
> On one hand I agree with you, from a theoretical point of view the driver
> should not know about all possible XUs. This just can't scale.
>
> On the other hand, it's pretty clear that we don't need to scale. We only have
> a single public dynamic controls XML file, and looking at the descriptors of
> most devices it's pretty clear that they reuse the same XUs, as they are based
> on only a dozen or so different chips.
>
> The dynamic controls API brings additional complexity to the driver, and I
> think that it was a good design decision. However, in some cases, the
> implications of changing an XU control value go well beyond what is usually
> expected of a control. I'm thus tempted to allow handling of XU controls in
> the kernel when there's a good reason to do so. Of course I want the code to
> be clean, without lots of hooks all over the place that would make the driver
> sources impossible to read and understand :-)
>
> Comments and thoughts will be appreciated.

I had my doubts in that because:
- we don't know if same XU was used for some thing different in ... 
older version of some hardware.
- we can't guarantee anything here. This XUs are not documented and not 
a part of sail strategy. If some thing will not work, or will brake 
because of it - only we will be responsible.
- In this case we will not have any win in case of bandwidth[1]. To 
enable this stream we should ask YUV and webcam wil allocate bandwidth 
for it.

- but all this is just FUD. I always happy to see, if some body goes 
beyond it and revers undocumented XUs and brings patches to make use of 
it for all :) Peter thx!


[1] - bandwidth seems to be number one in our "top 3" of always coming 
problems :)
-- 
Regards,
Oleksij
