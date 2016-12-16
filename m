Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933002AbcLPWI2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 17:08:28 -0500
Date: Fri, 16 Dec 2016 23:08:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?Q?Niels_M=C3=B6ller?= <nisse@google.com>
cc: linux-media@vger.kernel.org
Subject: Re: Problem with uvcvideo timestamps
In-Reply-To: <CANKQH8jiPypkgJ30KAjedjJvfDASZ6V9sZXKHN54xpv1=i9XbA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1612162259430.22053@axis700.grange>
References: <CANKQH8jiPypkgJ30KAjedjJvfDASZ6V9sZXKHN54xpv1=i9XbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niels,

Sorry for a late reply.

On Mon, 31 Oct 2016, Niels Möller wrote:

> Hi,
> 
> I'm tracking down a problem in Chrome, where video streams captured
> from a Logitech c930e camera get bogus timestamps. Chrome started
> using camera timestamps on linux a few months ago. I've noted commit
> 
>   https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5d0fd3c806b9e932010931ae67dbb482020e0882
> 
>   "[media] uvcvideo: Disable hardware timestamps by default"
> 
> but I'm running with a kernel which doesn't have that change.
> 
> First, let me say that for our purposes, the hairy syncing to the
> "SOF" clock done by uvc_video_clock_update is not that useful.
> Ideally, I would prefer if the v4l2_buffer of a captured frame
> included both
> 
>   * untranslated pts timestamp from the camera device (if I've
>     understood this correctly, and there is a pts sent over the wire),
>     and
> 
>   * the value of system monotonic clock at the point when the frame
>     was received by the kernel.
> 
> Is there any reasonable way to get this information out from the
> driver? We could then do estimation of the camera's epoch and clock
> drift in the application. The raw pts is the most important piece of
> information.

I think these patches can help you;

http://www.mail-archive.com/linux-media@vger.kernel.org/msg106077.html

Note, that they require an additional patch from Laurent:

https://patchwork.linuxtv.org/patch/36810/

Thanks
Guennadi

> 
> Second, I'd like to try to provide some logs to help track down the
> bug. To reproduce, I'm using the example program at
> https://gist.github.com/maxlapshin/1253534, modified to print out
> camera timestamp and gettimeofday for each frame. Log attached as
> time-2.log.
> 
> I also enabled tracing of the clock translation logic using
> 
>   echo 4096 > /sys/module/uvcvideo/parameters/trace
> 
> The corresponding kernel log messages are attached as trace-2.log.
> 
> In time-2.log (i.e., the application log), I see that camera
> timestamps move backwards in time,
> 
>   TIMESTAMP_MONOTONIC
>      cam: 2321521.085372
>      sys: 1477913910.983620
>   TIMESTAMP_MONOTONIC
>      cam: 2321520.879272
>      sys: 1477913911.051628
> 
> In trace-2.log (i.e., kernel log messages) I see
> 
>   uvcvideo: Logitech Webcam C930e: PTS 219483992 y 4084.798004 SOF
> 4084.798004 (x1 2064310082 x2 2148397132 y1 218759168 y2 268238848 SOF
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 4084.798004 y 3105900702 ts
> 2321520.879272 buf ts 2321521.153372 (x1 218759168/1546/1290 x2
> 274071552/1878/2045 y1 1000000000 y2 3380001263)
>   uvcvideo: Logitech Webcam C930e: PTS 221480532 y 4156.709564 SOF
> 4156.709564 (x1 2079524156 x2 2148397450 y1 256376832 y2 272629760 SOF
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 4156.709564 y 2453257742 ts
> 2321520.378627 buf ts 2321521.217373 (x1 262275072/1698/1864 x2
> 278265856/1942/64 y1 1000000000 y2 3292003672)
>   uvcvideo: Logitech Webcam C930e: PTS 223477044 y 4223.428085 SOF
> 4223.428085 (x1 2081269216 x2 2148397122 y1 264568832 y2 276955136 SOF
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 2175.428085 y 2158773894 ts
> 2321520.208143 buf ts 2321521.285373 (x1 136183808/1822/1989 x2
> 148504576/2010/130 y1 1000000000 y2 3236003012)
> 
> I don't know the details of the usb protocol, but it looks like the
> "SOF" value is usually increasing. But close to the bogus output
> timestamp of 2321520.879272, it goes through some kind of wraparound,
> with the sequence of values
> 
>   4156.709564
>   4223.428085
>   2175.428085    # 2048 less than previous value
>   2243.169921
> 
> I hope the attached logs provide enough information to analyze where
> uvc_video_clock_update gets this wrong.
> 
> Best regards,
> /Niels Möller
> 
