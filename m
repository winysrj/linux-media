Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33662 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbbLLLkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 06:40:14 -0500
Received: by mail-ig0-f177.google.com with SMTP id mv3so56063900igc.0
        for <linux-media@vger.kernel.org>; Sat, 12 Dec 2015 03:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566A8E48.7080603@st.com>
References: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
	<1449361427.31991.17.camel@collabora.com>
	<CAJ2oMh+MG20jYdNSfXWZN+0vH2BPi_Z+v4OB-VH5ehi7qmfmpw@mail.gmail.com>
	<566A8E48.7080603@st.com>
Date: Sat, 12 Dec 2015 13:40:13 +0200
Message-ID: <CAJ2oMhLt_E9Zq1D_cR4cdcb7XhS2imkfrieYga0D=CjnnP9T9A@mail.gmail.com>
Subject: Re: v4l2 kernel module debugging methods
From: Ran Shalit <ranshalit@gmail.com>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 11, 2015 at 10:50 AM, Fabien DESSENNE
<fabien.dessenne@st.com> wrote:
> Hi Ran,
>
> On 12/10/2015 10:46 PM, Ran Shalit wrote:
>> On Sun, Dec 6, 2015 at 2:23 AM, Nicolas Dufresne
>> <nicolas.dufresne@collabora.com> wrote:
>>> Le dimanche 06 décembre 2015 à 00:00 +0200, Ran Shalit a écrit :
>>>> Hello,
>>>>
>>>> I would like to ask a general question regarding methods to debug a
>>>> v4l2 device driver.
>>>> Since I assume that the kernel driver will probably won't work in
>>>> first try after coding everything inside the device driver...
>>>>
>>>> 1. Do you think qemu/kgdb debugger is a good method for the device
>>>> driver debugging , or is it plain printing ?
>>>>
>>>> 2. Is there a simple way to display the image of a YUV-like buffer in
>>>> memory ?
>>>
>>> Most Linux distribution ships GStreamer. You can with GStreamer read
>>> and display a raw YUV images (you need to know the specific format)
>>> using videoparse element.
>>>
>>>    gst-launch-1.0 filesrc location=my.yuv ! videoparse format=yuy2 width=320 height=240 ! imagefreeze ! videoconvert ! autovideosink
>>>
>>> You could also encode and store to various formats, replacing the
>>> imagefreeze ... section with an encoder and a filesink. Note that
>>> videoparse unfortunatly does not allow passing strides array or
>>> offsets. So it will work only if you set the width/height to padded
>>> width/height.
>>>
>>> regards,
>>> Nicolas
>>
>> Hi Nicolas,
>>
>> Thank you for the comment.
>> As someone expreinced with v4l2 device driver, do you recommened using
>> debugging technique such as qemu (or kgdb) or do you rather use plain
>> printing ?
>>
>> Thank you very much,
>> Ran
>
>
> You can get several level of logs.
> First, you can enable v4l2 core debug logs. Example:
>   echo 3 > /sys/class/video4linux/video0/debug
> More details:
> https://www.kernel.org/doc/Documentation/video4linux/v4l2-framework.txt
>
> If the tested driver uses the v4l2_mem2mem framework you can get M2M
> logs with:
>   echo Y > /sys/module/v4l2_mem2mem/parameters/debug
>
> Get also internal vb2 logs with:
>   echo 3 > /sys/module/videobuf2_core/parameters/debug
>
> And optionally more logs using the dynamic debug feature:
> (https://www.kernel.org/doc/Documentation/dynamic-debug-howto.txt). Example:
>   echo "module my_driver +p" > /sys/kernel/debug/dynamic_debug/control
>
> Fabien

Thank you very much for the helpful ideas.

Regards,
Ran
