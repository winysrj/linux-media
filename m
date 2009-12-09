Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43321 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbZLIWEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 17:04:16 -0500
Received: by fxm5 with SMTP id 5so8157488fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 14:04:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59cf47a80912091353o634f234nb83e64eaf7f52dd1@mail.gmail.com>
References: <51be034e0912091153n663111c5pe920f405c5befa13@mail.gmail.com>
	 <loom.20091209T205650-546@post.gmane.org>
	 <59cf47a80912091353o634f234nb83e64eaf7f52dd1@mail.gmail.com>
Date: Wed, 9 Dec 2009 23:04:21 +0100
Message-ID: <51be034e0912091404k34642412waa104abd8e419245@mail.gmail.com>
Subject: Re: MSI StarCam working in vlc only (with poor colors)
From: Jozef Riha <jose1711@gmail.com>
To: linux-media@vger.kernel.org
Cc: Paulo Assis <pj.assis@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[jose@darkstar ~]$ LC_ALL=C guvcview --verbose
guvcview 1.1.4
video_device: /dev/video0
vid_sleep: 0
cap_meth: 1
resolution: 640 x 480
windowsize: 480 x 700
vert pane: 0
spin behavior: 0
mode: mjpg
fps: 1/25
Display Fps: 0
bpp: 0
hwaccel: 1
avi_format: 0
sound: 1
sound Device: 0
sound samp rate: 0
sound Channels: 0
Sound Block Size: 1 seconds
Sound Format: 80
Sound bit Rate: 160 Kbps
Pan Step: 2 degrees
Tilt Step: 2 degrees
Video Filter Flags: 0
image inc: 0
profile(default):/home/jose/default.gpfl
starting portaudio...
language catalog=> dir:/usr/share/locale type:C lang:C cat:guvcview.mo

(guvcview:31380): GLib-GObject-WARNING **: IA__g_object_set_valist:
object class `GtkSettings' has no property named `gtk-button-images'
mjpg: setting format to 1196444237
capture method = 1
video device: /dev/video0
/dev/video0 - device 1
Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
{ pixelformat = 'MJPG', description = 'MJPEG' }
{ discrete: width = 640, height = 480 }
	Time interval between frame: 1/30,
{ discrete: width = 320, height = 240 }
	Time interval between frame: 1/30,
{ discrete: width = 160, height = 120 }
	Time interval between frame: 1/30,
checking format: 1196444237
VIDIOC_S_FORMAT - Unable to set format: Input/output error
Init v4L2 failed !!
Init video returned -2
trying minimum setup ...
capture method = 1
video device: /dev/video0
/dev/video0 - device 1
Init. UVC Camera (1b3b:2951) (location: usb-0000:00:1d.1-1)
{ pixelformat = 'MJPG', description = 'MJPEG' }
{ discrete: width = 640, height = 480 }
	Time interval between frame: 1/30,
{ discrete: width = 320, height = 240 }
	Time interval between frame: 1/30,
{ discrete: width = 160, height = 120 }
	Time interval between frame: 1/30,
checking format: 1196444237
VIDIOC_S_FORMAT - Unable to set format: Input/output error
Init v4L2 failed !!
ERROR: Minimum Setup Failed.
 Exiting...
Terminated.


On Wed, Dec 9, 2009 at 10:53 PM, Paulo Assis <pj.assis@gmail.com> wrote:
> Hi,
> Could you please try guvcview ( http://guvcview.berlios.de )
>
> Please post me the output of guvcview --verbose
>
> Best regards,
> Paulo
>
> 2009/12/9 Jozef Riha <jose1711@gmail.com>:
>> Jozef Riha <jose1711 <at> gmail.com> writes:
>>
>>>
>>> Hello dear ML members,
>>>
>>> I wonder whether you can help me with the following issue. My webcam
>>> MSI StarCam (http://www.aaronpc.cz/produkty/msi-starcam-370i)
>>> identified as
>>>
>>> ...
>>
>>
>> Sorry I forgot to add kernel version. It is 2.6.32, config at
>> http://repos.archlinux.org/wsvn/packages/kernel26/repos/core-i686/config
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
