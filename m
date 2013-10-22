Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m09.mx.aol.com ([64.12.143.82]:47167 "EHLO
	omr-m09.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3JVDHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 23:07:08 -0400
Message-ID: <5265EBD7.3040406@netscape.net>
Date: Tue, 22 Oct 2013 00:07:03 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.m@email.cz>
CC: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: cx23885: Add basic analog radio support
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com> <524F0F57.5020605@netscape.net> <5262AC1E.5030303@email.cz>
In-Reply-To: <5262AC1E.5030303@email.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Miroslav

El 19/10/13 12:58, Miroslav Slugeň escribió:
> Hi, i am not using those devices anymore for analog, we do change our 
> devices to SDR and SW demodulation, but i am sending my latest patches 
> all for kernel 3.2.XX
>
> Feel free to resubmit any kind of my code by your name ;)
>
> Miroslav Slugeň
> +420 724 825 885
>

Thanks you Miroslav, but is your code.

Regards,

Alfredo



> Alfredo Jesús Delaiti napsal(a):
>> Hi all
>>
>>
>> El 14/01/12 15:25, Miroslav Slugeň escribió:
>>> New version of patch, fixed video modes for DVR3200 tuners and working
>>> audio mux.
>>
>> I tested this patch (https://linuxtv.org/patch/9498/) with the latest
>> versions of git (September 28, 2013) with my TV card (Mygica X8507) and
>> it works.
>> I found some issue, although it may be through a bad implementation of
>> mine.
>>
>> Details of them:
>>
>> 1) Some warning when compiling
>>
>> ...
>> CC [M] 
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
>>
>> : initialization from incompatible pointer type [enabled by default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: 
>>
>> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner')
>> [enabled by default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
>>
>> warning: initialization from incompatible pointer type [enabled by 
>> default]
>> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: 
>>
>> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio')
>> [enabled by default]
>> CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
>> ...
>>
>> --------------------------------------------------------
>> static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>>
>> .vidioc_s_tuner = radio_s_tuner, /* line 1910 */
>> .vidioc_s_audio = radio_s_audio, /* line 1911 */
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
>> first put the TV-Analog, because I hear very low and a strong white 
>> noise.
>> The latter is likely to be corrected by resetting the tuner, I have to
>> study it more.
>>
>> I put below attached the patch applied to the plate: X8507.
>>
>> Have you done any update of this patch?
>>
>> Thanks

