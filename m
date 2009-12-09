Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:42167 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbZLIWxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 17:53:16 -0500
Received: by ewy1 with SMTP id 1so4963935ewy.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 14:53:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51be034e0912091436l6308f894xdb6997fb0b20ca42@mail.gmail.com>
References: <51be034e0912091153n663111c5pe920f405c5befa13@mail.gmail.com>
	 <loom.20091209T205650-546@post.gmane.org>
	 <59cf47a80912091353o634f234nb83e64eaf7f52dd1@mail.gmail.com>
	 <51be034e0912091404k34642412waa104abd8e419245@mail.gmail.com>
	 <59cf47a80912091420x32c2cac6ve55a4cced8517da1@mail.gmail.com>
	 <51be034e0912091436l6308f894xdb6997fb0b20ca42@mail.gmail.com>
Date: Wed, 9 Dec 2009 22:53:21 +0000
Message-ID: <59cf47a80912091453v685784b8h54f3cbfd5afad0c0@mail.gmail.com>
Subject: Re: MSI StarCam working in vlc only (with poor colors)
From: Paulo Assis <pj.assis@gmail.com>
To: Jozef Riha <jose1711@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You must reload the driver,

rmmod uvcvideo
modprobe uvcvideo

otherwise the quirks want have any effect.

uvcvideo is now mantained in the mercurial repo at linuxtv,
installing v4l-dvb will also install uvcvideo, but if you want, just
follow the instructions on the wiki to compile, but use:
 hg clone http://linuxtv.org/hg/~pinchartl/uvcvideo/
so that you get the very latest (testing) uvc code.
In any case the quirks should be enough:
http://lists.berlios.de/pipermail/linux-uvc-devel/2009-October/005235.html

Best regards,
Paulo

2009/12/9 Jozef Riha <jose1711@gmail.com>:
> setting quirks to 2 unfortunately did not help. gucview's 1.2.1 output below
>
> [jose@darkstar ~]$ LC_ALL=C guvcview --verbose
> guvcview 1.2.1
> unexpected integer value (1) for snd_numsec
> Strings must be quoted
> video_device: /dev/video0
> vid_sleep: 0
> cap_meth: 1
> resolution: 640 x 480
> windowsize: 480 x 700
> vert pane: 0
> spin behavior: 0
> mode: mjpg
> fps: 1/25
> Display Fps: 0
> bpp: 0
> hwaccel: 1
> avi_format: 0
> sound: 1
> sound Device: 0
> sound samp rate: 0
> sound Channels: 0
> Sound delay: 0 nanosec
> Sound Format: 80
> Sound bit Rate: 160 Kbps
> Pan Step: 2 degrees
> Tilt Step: 2 degrees
> Video Filter Flags: 0
> image inc: 0
> profile(default):/home/jose/default.gpfl
> starting portaudio...
> language catalog=> dir:/usr/share/locale type:C lang:C cat:guvcview.mo
> mjpg: setting format to 1196444237
> capture method = 1
> video device: /dev/video0
> /dev/video0 - device 1
> Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
> { pixelformat = 'MJPG', description = 'MJPEG' }
> { discrete: width = 640, height = 480 }
>        Time interval between frame: 1/30,
> { discrete: width = 320, height = 240 }
>        Time interval between frame: 1/30,
> { discrete: width = 160, height = 120 }
>        Time interval between frame: 1/30,
> vid:1b3b
> pid:2951
> driver:uvcvideo
> checking format: 1196444237
> VIDIOC_S_FORMAT - Unable to set format: Input/output error
> Init v4L2 failed !!
> Init video returned -2
> trying minimum setup ...
> capture method = 1
> video device: /dev/video0
> /dev/video0 - device 1
> Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
> { pixelformat = 'MJPG', description = 'MJPEG' }
> { discrete: width = 640, height = 480 }
>        Time interval between frame: 1/30,
> { discrete: width = 320, height = 240 }
>        Time interval between frame: 1/30,
> { discrete: width = 160, height = 120 }
>        Time interval between frame: 1/30,
> vid:1b3b
> pid:2951
> driver:uvcvideo
> checking format: 1196444237
> VIDIOC_S_FORMAT - Unable to set format: Input/output error
> Init v4L2 failed !!
> ERROR: Minimum Setup Failed.
>  Exiting...
> free audio mutex
> VIDIOC_REQBUFS - Failed to delete buffers: Invalid argument (errno 22)
> closed v4l2 strutures
> free controls - vidState
> cleaned allocations - 100%
> Closing portaudio ...OK
> Terminated.
>
> are you sure with the web-page? i cannot see a relationship between
> dvb and uvcvideo. shouldn't i download the most recent driver from
> http://linux-uvc.berlios.de/#download ?
>
> thank you,
>
> joe
>
> On Wed, Dec 9, 2009 at 11:20 PM, Paulo Assis <pj.assis@gmail.com> wrote:
>> Hi, could you try the following:
>>
>> echo 2 > /sys/module/uvcvideo/parameters/quirks
>>
>> this will set uvcvideo quirks to 2
>>
>> or you can also try the latest uvcvideo:
>> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>>
>> please if you can, use the latest version for guvcview (1.2.1)  :D
>>
>> Regards,
>> Paulo
>>
>> 2009/12/9 Jozef Riha <jose1711@gmail.com>:
>>> [jose@darkstar ~]$ LC_ALL=C guvcview --verbose
>>> guvcview 1.1.4
>>> video_device: /dev/video0
>>> vid_sleep: 0
>>> cap_meth: 1
>>> resolution: 640 x 480
>>> windowsize: 480 x 700
>>> vert pane: 0
>>> spin behavior: 0
>>> mode: mjpg
>>> fps: 1/25
>>> Display Fps: 0
>>> bpp: 0
>>> hwaccel: 1
>>> avi_format: 0
>>> sound: 1
>>> sound Device: 0
>>> sound samp rate: 0
>>> sound Channels: 0
>>> Sound Block Size: 1 seconds
>>> Sound Format: 80
>>> Sound bit Rate: 160 Kbps
>>> Pan Step: 2 degrees
>>> Tilt Step: 2 degrees
>>> Video Filter Flags: 0
>>> image inc: 0
>>> profile(default):/home/jose/default.gpfl
>>> starting portaudio...
>>> language catalog=> dir:/usr/share/locale type:C lang:C cat:guvcview.mo
>>>
>>> (guvcview:31380): GLib-GObject-WARNING **: IA__g_object_set_valist:
>>> object class `GtkSettings' has no property named `gtk-button-images'
>>> mjpg: setting format to 1196444237
>>> capture method = 1
>>> video device: /dev/video0
>>> /dev/video0 - device 1
>>> Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
>>> { pixelformat = 'MJPG', description = 'MJPEG' }
>>> { discrete: width = 640, height = 480 }
>>>        Time interval between frame: 1/30,
>>> { discrete: width = 320, height = 240 }
>>>        Time interval between frame: 1/30,
>>> { discrete: width = 160, height = 120 }
>>>        Time interval between frame: 1/30,
>>> checking format: 1196444237
>>> VIDIOC_S_FORMAT - Unable to set format: Input/output error
>>> Init v4L2 failed !!
>>> Init video returned -2
>>> trying minimum setup ...
>>> capture method = 1
>>> video device: /dev/video0
>>> /dev/video0 - device 1
>>> Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
>>> { pixelformat = 'MJPG', description = 'MJPEG' }
>>> { discrete: width = 640, height = 480 }
>>>        Time interval between frame: 1/30,
>>> { discrete: width = 320, height = 240 }
>>>        Time interval between frame: 1/30,
>>> { discrete: width = 160, height = 120 }
>>>        Time interval between frame: 1/30,
>>> checking format: 1196444237
>>> VIDIOC_S_FORMAT - Unable to set format: Input/output error
>>> Init v4L2 failed !!
>>> ERROR: Minimum Setup Failed.
>>>  Exiting...
>>> Terminated.
>>>
>>>
>>> On Wed, Dec 9, 2009 at 10:53 PM, Paulo Assis <pj.assis@gmail.com> wrote:
>>>> Hi,
>>>> Could you please try guvcview ( http://guvcview.berlios.de )
>>>>
>>>> Please post me the output of guvcview --verbose
>>>>
>>>> Best regards,
>>>> Paulo
>>>>
>>>> 2009/12/9 Jozef Riha <jose1711@gmail.com>:
>>>>> Jozef Riha <jose1711 <at> gmail.com> writes:
>>>>>
>>>>>>
>>>>>> Hello dear ML members,
>>>>>>
>>>>>> I wonder whether you can help me with the following issue. My webcam
>>>>>> MSI StarCam (http://www.aaronpc.cz/produkty/msi-starcam-370i)
>>>>>> identified as
>>>>>>
>>>>>> ...
>>>>>
>>>>>
>>>>> Sorry I forgot to add kernel version. It is 2.6.32, config at
>>>>> http://repos.archlinux.org/wsvn/packages/kernel26/repos/core-i686/config
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>
