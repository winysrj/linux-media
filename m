Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:51266 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676Ab3BGWeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 17:34:17 -0500
Received: by mail-ea0-f181.google.com with SMTP id i13so1343697eaa.12
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 14:34:16 -0800 (PST)
Message-ID: <51142BE5.8010102@gmail.com>
Date: Thu, 07 Feb 2013 23:34:13 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Alexander Nestorov <alexandernst@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Hi again
References: <CACuz9s2w28eVG8qS9FXkUYAggXn7y2deHi2fPGizcURu_Bp4wg@mail.gmail.com> <CACuz9s1_KKfVDCa4FvZLe9pEVWuqQzuLPX7pYX9Tw1NUQGPtzA@mail.gmail.com> <CACuz9s1waQ3VgRjdxw9CoiHX2BtfOaxTosqLDwhX+O7px0=JXg@mail.gmail.com> <50D31BF8.8040301@gmail.com> <CACuz9s3xtCndC2jks4T-ytSWxwTBjLbXUrehEtsNwm7H=wJC1Q@mail.gmail.com> <50D31F63.6090304@gmail.com> <CACuz9s06v5nXNze+AAZyPTyxib4OXmqRi9E_Hw4SqBoprym0UA@mail.gmail.com> <50D85D93.7060201@gmail.com> <CACuz9s19ssgPkVM3fB+3JQ5EOp9rTTOncaZro_rA=4c98DJGZQ@mail.gmail.com> <CACuz9s1Bs4W8Nq_2R3uMQn4dJVahtrqWhfEAVH1PGwguZWALEA@mail.gmail.com> <50E081DE.5070208@gmail.com> <CACuz9s30Om4DTqy8=VVQma=+GEC0=vmbK_n1+ic4v6YiCfdYQQ@mail.gmail.com> <50E359D2.4080105@gmail.com> <CACuz9s3_+MsDcwNdPeyaTaPC3zvknCe0sZ6vGCENUcQdfz6ZJg@mail.gmai l.com> <5109A415.8090300@gmail.com> <CACuz9s3nrTYsSvDSecV3OO4U22DmEVynmixkkJ6BQX83smNL1A@mail.gmail.com> <CACuz9s2MwexhTuNYf2rN5QSaN=Q0FZ2qJXK2Ud7ytkr-rUoQ6w@mail.gmail.com> <5112ECDD.6080004@gmail.com>
In-Reply-To: <5112ECDD.6080004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2013 12:53 AM, Sylwester Nawrocki wrote:
> root@mini2440:~ echo 100 > /sys/module/videobuf2_core/parameters/debug
>
> root@mini2440:~ gst-launch -v v4l2src device=/dev/video0 queue-size=2
> ! video/x-raw-yuv,format='(fourcc)'YV12 ! ffmpegcolorspace ! fbdevsink
>
> root@mini2440:~ dmesg -c
> [ 1907.110000] s3c-camif s3c2440-camif: dma_alloc_coherent of size
> 12582912 failed
> [ 1907.115000] vb2: Failed allocating memory for buffer 1
>
> The error is ignored here, it should all fail at this point.
>
> [ 1907.120000] vb2: Buffer 0, plane 0 offset 0x00000000
> [ 1907.125000] vb2: Allocated 1 buffers, 1 plane(s) each
> [ 1907.220000] vb2: Buffer 0, plane 0 successfully mapped
> [ 1907.225000] vb2: qbuf of buffer 0 succeeded
> [ 1907.230000] vb2: Streamon successful

I've found there is a bug in the driver. It happens that only one buffer
out of two gets allocated and the minimum required for the driver to start
streaming is 2. I've pushed a patch fixing this bug [1] to the 3.7 based
testing/s3c-camif branch. I'll post it to LMML in a minute.

It won't really solve your problem, but at least there is now clear
indication what's wrong, and the application should not get stuck. Please
check you CMA memory region size. I suspect that you use the default 16 MB
and it allows you to allocate only one buffer. 16 MB might still be
sufficient for 1280x1024 - OV9650's maximum resolution. Anyway, it might
be worth to check what CONFIG_CMA_SIZE_MBYTES is set to.
(Device drivers -> Generic Driver Options -> Contiguous Memory Allocator)

>> [23:07]<KaKaRoTo> which is also why it freezes (doesn't output
>> buffers) instead of giving an error when you try to set that
>> resolution

Thanks,
Sylwester
