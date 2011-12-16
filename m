Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45455 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1LPAyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 19:54:01 -0500
Received: by wgbdr13 with SMTP id dr13so5027044wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 16:54:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE9C7A1.8060303@matrix-vision.de>
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
	<4EE9A8B6.4040102@matrix-vision.de>
	<CAOy7-nPY_Nffgj_Ax=ziT9WYH-egvL8QnZfb50Xurn+AF4yWCQ@mail.gmail.com>
	<4EE9C7A1.8060303@matrix-vision.de>
Date: Fri, 16 Dec 2011 08:53:59 +0800
Message-ID: <CAOy7-nNbGh0C-H60ZJ-WVYavYAyLnADLWsjvbwwoOV9Sd+chFA@mail.gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Thu, Dec 15, 2011 at 6:10 PM, Michael Jones
<michael.jones@matrix-vision.de> wrote:
> Hi James,
>
>
> On 12/15/2011 10:49 AM, James wrote:
>>
>> Hi Michael,
>>
>> On Thu, Dec 15, 2011 at 3:58 PM, Michael Jones
>> <michael.jones@matrix-vision.de>  wrote:
>>>
>>> Hi James,
>>>
>>>
>>> On 12/15/2011 08:14 AM, James wrote:
>>>>
>>>>
>>>> Hi all,
>>>>
>>>> I'm using an OMAP3530 board and a monochrome 12-bit grey sensor.
>>>>
>>>> Can anyone enlighten me why is the 12-bit grey formats at the CCDC
>>>> input (Y12) is truncated to Y10 at the CCDC output?
>>>
>>>
>>>
>>> There are 2 CCDC outputs: CCDC_PAD_SOURCE_OF and CCDC_PAD_SOURCE_VP. Only
>>> the VP (video port) truncates data to 10 bits, and it does that because
>>> the
>>> subdevs it feeds can only handle 10 bits max.
>>
>>
>> Thank you for the clarification.
>>
>>>> I need to read the entire RAW 12-bit grey value from the CCDC to
>>>> memory and the data does not pass through other OMAP3ISP sub-devices.
>>>>
>>>> I intend to use Laurent's yavta to capture the data to file to verify
>>>> its operation for the moment.
>>>>
>>>> Can this 12-bit (Y12) raw capture be done?
>>>
>>>
>>>
>>> Yes. If you are writing the 12-bit gray value directly into memory, you
>>> will
>>> use SOURCE_OF and can write the full 12-bits into memory.  You need to
>>> set
>>> up your media pipeline to do sensor->CCDC->OMAP3 ISP CCDC output.
>>
>>
>> Is there further modification needed to apply to the OMAP3ISP to achieve
>> this?
>>
>> Do you have an application to test the pipeline for this setting to
>> simple display?
>
>
> Let's establish where you're coming from.  Are you familiar with the media
> controller?  Laurent has a program 'media-ctl' to set up the pipeline (see
> http://git.ideasonboard.org/?p=media-ctl.git).  You will find many examples
> of its usage in the archives of this mailing list. It will look something
> like:
> media-ctl -r
> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]'
> media-ctl -l '"your-sensor-name":0 -> "OMAP3 ISP CCDC":0 [1]'
>
> you will also need to set the formats through the pipeline with 'media-ctl
> --set-format'.
>
> After you use media-ctl to set up the pipeline, you can use yavta to capture
> the data from the CCDC output (for me, this is /dev/video2).
>

Yes, I've been using Laurent's media-ctl & yavta to test out MT9V032
on the Overo board.
He has been helping and guiding me with it as there isn't any success
with using MT9V032 on the Overo board then. (^^)

What I've been looking for since then is any other application such as
GUI MPlayer or gst-launch that can open the device and playback the
data to either LCD or DVI display on the board. (i.e. direct
'streaming')

Do you know of any? I wish to avoid any further components (e.g.
ffmpeg) that modify/convert the raw data as much as possible.

sensor->CCDC->application->display

Many thanks in adv.

-- 
Regards,
James
