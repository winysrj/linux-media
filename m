Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45432 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbeJGQLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Oct 2018 12:11:37 -0400
Subject: Re: Problem with example program from
 https://gitlab.collabora.com/koike/v4l2-codec.git
To: Dafna Hirschfeld <dafna3@gmail.com>
Cc: helen.koike@collabora.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAJ1myNRosDxNLYRQrFDasJCL-5Zn1Fo9VqoNyFD=hvf7KWkCYw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fd7ae60c-66c9-aced-fde2-fc3b209cda9e@xs4all.nl>
Date: Sun, 7 Oct 2018 11:04:55 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ1myNRosDxNLYRQrFDasJCL-5Zn1Fo9VqoNyFD=hvf7KWkCYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2018 10:39 AM, Dafna Hirschfeld wrote:
> Hi,
> As part of applying to the outreachy program,
> I compiled the code in https://gitlab.collabora.com/koike/v4l2-codec.git
> I get errors running it.
> When I install vicodec.ko I see in the kernel log:
> 
> [10752.727509] vicodec vicodec.0: Device registered as /dev/video2
> [10752.727534] vicodec vicodec.0: Device registered as /dev/video3
> 
> I think /dev/video0, /dev/video1 are already used by uvcvideo

Correct.

> 
> The dev file used in v4l2-decode.c is "/dev/video1"

A patch that adds support for an argument so you can pass the device name
are welcome.

> 
> When running the code as is, it prints:
> "mmap: Invalid argument"

Yes, since video1 isn't a memory-to-memory device.

> 
> Changing the code of v4l2-decode.c to use "/dev/video0" prints:
> "Driver didn't accept RGB24 format. Can't proceed."
> 
> Changing it to use "/dev/video2" prints:
> "Driver didn't accept FWHT format. Can't proceed."
> 
> Changing it to use "/dev/video3" prints:
> "Driver didn't accept RGB24 format. Can't proceed."

This is the right device node to use (the decoder).

I get this when I run it:

$ ./v4l2-decode
Warning: driver is sending image at 640x480

Helen, vicodec has a minimum height of 480, and v4l2-codec.c tries to select
360, hence the difference. How did you test this? I think vicodec always had
480 as minimum height. I'm a bit surprised about this message.

> 
> I tried it on both kernel and modules 4.19.0-rc4+ compiled from https://git.linuxtv.org/linux.git
> and kenel and modules 4.19.0-rc1+ compiled from git://linuxtv.org/media_tree.git <http://linuxtv.org/media_tree.git>

Use the master branch of media_tree,git. You should see files named codec-fwht.c,
codec-v4l2-fwht.c and vicodec-core.c in drivers/media/platform/vicodec/.

> 
> Any idea what is the problem or how to investigate ?

You can use v4l2-ctl to check this. Try:

v4l2-ctl -d3 --list-formats

You should see this:

$ v4l2-ctl -d3 --list-formats
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture

        [0]: 'YU12' (Planar YUV 4:2:0)
        [1]: 'YV12' (Planar YVU 4:2:0)
        [2]: '422P' (Planar YUV 4:2:2)
        [3]: 'NV12' (Y/CbCr 4:2:0)
        [4]: 'NV21' (Y/CrCb 4:2:0)
        [5]: 'NV16' (Y/CbCr 4:2:2)
        [6]: 'NV61' (Y/CrCb 4:2:2)
        [7]: 'NV24' (Y/CbCr 4:4:4)
        [8]: 'NV42' (Y/CrCb 4:4:4)
        [9]: 'YUYV' (YUYV 4:2:2)
        [10]: 'YVYU' (YVYU 4:2:2)
        [11]: 'UYVY' (UYVY 4:2:2)
        [12]: 'VYUY' (VYUY 4:2:2)
        [13]: 'BGR3' (24-bit BGR 8-8-8)
        [14]: 'RGB3' (24-bit RGB 8-8-8)
        [15]: 'HSV3' (24-bit HSV 8-8-8)
        [16]: 'BGR4' (32-bit BGRA/X 8-8-8-8)
        [17]: 'XR24' (32-bit BGRX 8-8-8-8)
        [18]: 'RGB4' (32-bit A/XRGB 8-8-8-8)
        [19]: 'BX24' (32-bit XRGB 8-8-8-8)
        [20]: 'HSV4' (32-bit XHSV 8-8-8-8)

Note the presence of RGB3 (i.e. V4L2_PIX_FMT_RGB24).

BTW, for questions like this just mail to Helen and myself and don't include the
linux-media mailinglist in the future. It's not relevant for the list.

Regards,

	Hans

> Thanks,
> 
> Dafna Hirschfeld
> 
> 
