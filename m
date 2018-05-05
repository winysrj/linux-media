Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45610 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeEEHqy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 03:46:54 -0400
Subject: Re: 4.17-rc3 regression in UVC driver
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20180504181900.pm72mxyueqb3fu3z@earth.universe>
 <3a5a32b0-a78d-571c-60af-416656f81e69@ideasonboard.com>
Cc: Sebastian Reichel <sre@kernel.org>
Message-ID: <5976e224-ba79-ffbb-d377-734e85fadde4@ideasonboard.com>
Date: Sat, 5 May 2018 08:46:50 +0100
MIME-Version: 1.0
In-Reply-To: <3a5a32b0-a78d-571c-60af-416656f81e69@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello again,

On 05/05/18 08:34, Kieran Bingham wrote:
> Hi Sebastian,
> 
> On 04/05/18 19:45, Sebastian Reichel wrote:
>> Hi,
>> 
>> I just got the following error message every ms with 4.17-rc3 after 
>> upgrading to for first ~192 seconds after system start (Debian 
>> 4.17~rc3-1~exp1 kernel) on my Thinkpad X250:
>> 
>>> uvcvideo: Failed to query (GET_MIN) UVC control 2 on unit 1: -32 (exp. 
>>> 1).
> 
> I have submitted a patch to fix this ... (and I thought it would have got 
> in by now ... so I'll chase this up)


Mauro - I just saw Laurent sent a pull-request for this last week, so I guess
maybe it's on it's way:

[GIT FIXES FOR v4.17] UVC fixes (25/04/2018)

But perhaps it got missed ? - I don't see this patch in media/v4.17-4:

git log media/v4.17-4 --grep="media: uvcvideo: Prevent setting unavailable flags
"
<blank>

Anyway, I'll leave this in your hands.

- --
Regards

Kieran


> Please see : https://patchwork.linuxtv.org/patch/48043/ and apply the
> patch to bring your system logs back to a reasonable state :D
> 
> Laurent, Mauro,
> 
> This is the second bug report I've had on this topic. Can we aim to get 
> this patch merged please?
> 
>> I see /dev/video0 and /dev/video1. The first one seems to be functional. 
>> The second one does not work and does not make sense to me (the system 
>> has only one webcam). I did not try to bisect anything. Here is some
>> more information, that might be useful:
> 
> There are two device nodes now, as one is provided to output meta-data or 
> such.
> 
> 
>>> sre@earth ~ % mpv /dev/video1 Playing: /dev/video1 [ffmpeg/demuxer] 
>>> video4linux2,v4l2: ioctl(VIDIOC_G_INPUT): Inappropriate ioctl for 
>>> device [lavf] avformat_open_input() failed Failed to recognize file 
>>> format. sre@earth ~ % udevadm info /dev/video0 P: 
>>> /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video0
>>> N: video0 E: DEVNAME=/dev/video0 E: 
>>> DEVPATH=/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video0
>>>
>>>
>>> 
E: MAJOR=81
>>> E: MINOR=0 E: SUBSYSTEM=video4linux sre@earth ~ % udevadm info 
>>> /dev/video1 P: 
>>> /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video1
>>> N: video1 E: DEVNAME=/dev/video1 E: 
>>> DEVPATH=/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video1
>>>
>>>
>>> 
E: MAJOR=81
>>> E: MINOR=1 E: SUBSYSTEM=video4linux sre@earth ~ % lsusb -d 04ca:703c 
>>> Bus 001 Device 004: ID 04ca:703c Lite-On Technology Corp.
>> 
>> -- Sebastian
> 
> 
> Regards
> 
> Kieran
> 
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrtYWoACgkQoR5GchCk
Yf3tQg/7BgBFIj9more5vTaCFEU2L+tapdOBItO+mgzHI9fFXVHAmaVUlSjVAiMX
PlyRx1NsSnCRSZ4b6R/ydjEuNG5dLr2B8LfS5QP/6ABmUCONdCBIbx/2mDk+DtoX
XZeI65MMr3nZG7f6ZNq2EoVPIcFF4WLY4CsfixBOye3ps4e91IkTDFA/EVG0qkD8
XLRHACYSe/7lMS2TcAyOlmzWecYLYqnFBxfjlBD80NfdWITsDZdooZ3KUdHTCqN4
ooWjyifkeh79D8M9PGhnNGoB4gbHjTMhbZEH4RaABdv/jO/L4kPExX+2Wjc4LnRj
QlWmLm9svIisXJaPO6sPg+rIUr6xLTs5Dv5yYU+UpR9AVfVusHy7FfFoYkcHpThZ
h0rc1yi6eU4/Nnz1BvQbLCdjab2yEF5nD05PQs22r4ZJy04ymiz+y3SZvlr8vYfu
2ZRJzjkvFHtWV3yd/LfjxmuzmYXH4Yn+yN8jMGu8sY4JtJEsSF8qPbjDpicOhXvI
pv4V9xvDGscsZdKFaNv0IES+NHNRsgPvx0sR0DOb3MC8T9p+aEJPfQEBly1XBPG0
4GkvuA//DKpBASFdlSpKt4YW6OX56X+g8BPOcaBJV8BlBRzumDk4cAZ/T2t4DLm5
w3GnEwWLu0BiWl1LKqgh4xVgOg45IqcJJmDgupM3WzjCrYwVCbo=
=B80a
-----END PGP SIGNATURE-----
