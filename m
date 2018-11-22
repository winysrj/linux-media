Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54685 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388647AbeKVXWy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 18:22:54 -0500
Subject: Re: Logitech QuickCam USB detected by Linux, but not user space
 applications
To: Paul Menzel <pmenzel@molgen.mpg.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b9140bbf-1537-1431-1250-da0a21208992@molgen.mpg.de>
 <20181115033813.6ff626d5@silica.lan>
 <53bce637-985e-2c74-1d6b-151ba81550db@molgen.mpg.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd498a43-75cd-eec1-415f-f9d4569a302e@xs4all.nl>
Date: Thu, 22 Nov 2018 13:43:39 +0100
MIME-Version: 1.0
In-Reply-To: <53bce637-985e-2c74-1d6b-151ba81550db@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On 11/16/2018 03:39 PM, Paul Menzel wrote:
> Dear Mauro,
> 
> 
> Thank you very much for the quick reply.
> 
> 
> On 11/15/18 12:38, Mauro Carvalho Chehab wrote:
>> Em Thu, 15 Nov 2018 11:42:32 +0100 Paul Menzel escreveu:
> 
>>> I tried to get a Logitech QuickCam USB camera working, but unfortunately, it is 
>>> not detected by user space (Cheese, MPlayer).
>>
>> Could you please try it with Camorama?
>>
>> 	https://github.com/alessio/camorama
> 
> Thank you for the suggestion. At first, I only saw a black image, but changing the
> resolution made it work. See the status below.
> 
> 1.  does *not* work
> 
>     a)  160x120
>     b)  176x144
> 
> 2.  works
> 
>     a)  320x240
>     b)  352x288

Try this patch:

https://patchwork.linuxtv.org/patch/53043/

It probably fixes the same problem you are experiencing.

Regards,

	Hans

> 
>>> It’s an old device, so it could be broken, but as it’s detected by the Linux
>>> kernel, I wanted to check with you first.
>>>
>>> Linux 4.18.10 from Debian Sid/unstable is used.
>>>
>>> ```
>>> $ dmesg
>>> […]
>>> [ 2891.404361] usb 3-3: new full-speed USB device number 4 using ohci-pci
>>> [ 2891.626934] usb 3-3: New USB device found, idVendor=046d, idProduct=092e, bcdDevice= 0.00
>>> [ 2891.626945] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [ 2891.626951] usb 3-3: Product: Camera
>>> [ 2891.626957] usb 3-3: Manufacturer:
>>> [ 2893.110249] calling  media_devnode_init+0x0/0x1000 [media] @ 11704
>>> [ 2893.110256] media: Linux media interface: v0.10
>>> [ 2893.110329] initcall media_devnode_init+0x0/0x1000 [media] returned 0 after 56 usecs
>>> [ 2893.210078] calling  videodev_init+0x0/0x79 [videodev] @ 11704
>>> [ 2893.210084] videodev: Linux video capture interface: v2.00
>>> [ 2893.210123] initcall videodev_init+0x0/0x79 [videodev] returned 0 after 21 usecs
>>> [ 2893.333140] calling  gspca_init+0x0/0x1000 [gspca_main] @ 11704
>>> [ 2893.333148] gspca_main: v2.14.0 registered
>>> [ 2893.333161] initcall gspca_init+0x0/0x1000 [gspca_main] returned 0 after 3 usecs
>>> [ 2893.370672] calling  sd_driver_init+0x0/0x1000 [gspca_spca561] @ 11704
>>> [ 2893.370751] gspca_main: spca561-2.14.0 probing 046d:092e
>>> [ 2893.482675] input: spca561 as /devices/pci0000:00/0000:00:12.0/usb3/3-3/input/input17
>>> [ 2893.485415] usbcore: registered new interface driver spca561
>>> [ 2893.485434] initcall sd_driver_init+0x0/0x1000 [gspca_spca561] returned 0 after 112054 usecs
>>> […]
>>> $ ls -l /dev/video*
>>> crw-rw----+ 1 root video 81, 0 Nov 15 09:26 /dev/video0
>>>
>>> $ mplayer tv:// -tv driver=v4l2:device=/dev/video0
>>> MPlayer 1.3.0 (Debian), built with gcc-8 (C) 2000-2016 MPlayer Team
>>> do_connect: could not connect to socket
>>> connect: No such file or directory
>>> Failed to open LIRC support. You will not be able to use your remote control.
>>>
>>> Playing tv://.
>>> TV file format detected.
>>> Selected driver: v4l2
>>>  name: Video 4 Linux 2 input
>>>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>>>  comment: first try, more to come ;-)
>>> v4l2: your device driver does not support VIDIOC_G_STD ioctl, VIDIOC_G_PARM was used instead.
>>> Selected device: Camera
>>>  Capabilities:  video capture  read/write  streaming
>>>  supported norms:
>>>  inputs: 0 = spca561;
>>>  Current input: 0
>>>  Current format: unknown (0x31363553)
>>
>> The problem is likely here: mplayer is probably not using libv4l2. Without
>> that, it can't decode the spca561 specific output format. It is probably
>> due to some option used when mplayer was built.
> 
> I’ll try to look more into that in the next weeks.
> 
>> In the case of Cheese, it uses Gstreamer, with defaults to not use libv4l2
>> either. On newest versions of it, there is an environment var that would
>> allow enabling it (I don't remember what var).
> 
> Thank you for the details. I’ll test that next week.
> 
> […]
> 
> 
> Kind regards,
> 
> Paul
> 
