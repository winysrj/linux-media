Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d03.mx.aol.com ([205.188.109.200]:47188 "EHLO
	omr-d03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDRaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 12:30:17 -0500
Message-ID: <5277D6F1.3090608@netscape.net>
Date: Mon, 04 Nov 2013 14:18:41 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx23885: Add basic analog radio support
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com> <524F0F57.5020605@netscape.net> <20131031081255.65111ad6@samsung.com>
In-Reply-To: <20131031081255.65111ad6@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

El 31/10/13 07:12, Mauro Carvalho Chehab escribió:
> Em Fri, 04 Oct 2013 15:56:23 -0300
> Alfredo Jesús Delaiti  <alfredodelaiti@netscape.net> escreveu:
>
>> Hi all
>>
>>
>> El 14/01/12 15:25, Miroslav Slugeň escribió:
>>> New version of patch, fixed video modes for DVR3200 tuners and working
>>> audio mux.
>> I tested this patch (https://linuxtv.org/patch/9498/) with the latest
>> versions of git (September 28, 2013) with my TV card (Mygica X8507) and
>> it works.
>> I found some issue, although it may be through a bad implementation of mine.
>>
>> Details of them:
>>
>> 1) Some warning when compiling
>>
>> ...
>>     CC [M]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8:
>> : initialization from incompatible pointer type [enabled by default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8:
>> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner')
>> [enabled by default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8:
>> warning: initialization from incompatible pointer type [enabled by default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8:
>> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio')
>> [enabled by default]
>>     CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
>> ...
>>
>> --------------------------------------------------------
>> static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>>
>>          .vidioc_s_tuner       = radio_s_tuner, /* line 1910 */
>>          .vidioc_s_audio       = radio_s_audio, /* line 1911 */
>>
>> --------------------------------------------------------
>>
>> 2)
>> No reports signal strength or stereo signal with KRadio. XC5000 neither
>> reported (modprobe xc5000 debug=1). Maybe a feature XC5000.
>> To listen in stereo, sometimes, you have to turn on the Digital TV then
>> Analog TV and then radio.
>>
>> 3)
>> To listen Analog TV I need changed to NTSC standard and then PAL-Nc (the
>> norm in my country is PAL-Nc). If I leave the tune in NTSC no problem
>> with sound.
>> The patch (https://linuxtv.org/patch/9505/) corrects the latter, if used
>> tvtime with xawtv not always.
>> If I see-Digital TV (ISDB-T), then so as to listen the radio I have
>> first put the TV-Analog, because I hear very low and a strong white noise.
>> The latter is likely to be corrected by resetting the tuner, I have to
>> study it more.
>>
>> I put below attached the patch applied to the plate: X8507.
>>
>> Have you done any update of this patch?
> Hi Alfredo,
>
> My understanding is that the patch you've enclosed is incomplete and
> depends on Miroslav's patch.

If so. My intention was to support the work of Miroslav, indicating that 
it could be used in another plate, with the problems I encountered with 
the implementation I did.

Unfortunately, Mirslav no longer working on it. See the last message 
sent by him.

> As he have you his ack to rework on it, could you please prepare a
> patch series addressing the above comments for us to review?
>
> Than

I can put back the patch from Miroslav, general support radio (but no 
for any card particular) and adapted to the latest versions of the 
drivers that are in git, and in a second patch, again, put the 
particular patch Mygica X8507.
I did not put in the subject "Patch" because as I said, has some bugs. 
Is it right to put in the subject "Patch" when is something incomplete?

Regards,

Alfredo
