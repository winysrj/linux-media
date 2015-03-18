Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:34749 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbbCRKRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:17:14 -0400
Received: by ykfc206 with SMTP id c206so14449213ykf.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 03:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvf8-hLA3o6m+xAiKORJrO=bfr6ohJ1Zz1vh5vj4xDz2krzsA@mail.gmail.com>
References: <CAFvf8-hLA3o6m+xAiKORJrO=bfr6ohJ1Zz1vh5vj4xDz2krzsA@mail.gmail.com>
From: Moritz Kassner <moritzkassner@gmail.com>
Date: Wed, 18 Mar 2015 11:16:53 +0100
Message-ID: <CAO14JipX1V6GCmqTeWJC7NviwSCh7dZ-6uOFgdwBOP2nheHh5A@mail.gmail.com>
Subject: Re: two UVC simultaneous devices impossible?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

your problem is not related to de-facto bandwidth use but with
bandwidth allocation.

The uvc driver follows the uvc specification: The driver selects an
alternate setting for the Isochronous endpoint that  satisfies the
bandwidth requirements for the negotiated video stream. The bandwidth
requirement depends on the stream resolution,rate and format (think
YUV or MJPEG...) and is reported by the camera. This is where the
problem lies: Especially when you select a compressed format (for high
resolutions and rates this is usually the case.), the camera reports a
very conservative estimate on the minimum bandwidth required. This
effectively prohibits multiple streams.

One workaround is to estimate the bandwidth yourself.

For uncompressed streams a quirk exists:
http://www.ideasonboard.org/uvc/faq/#faq7
For mjpeg stream there is a patch (not written by me) here:
https://gist.githubusercontent.com/mkassner/10134241/raw/5ea34a0269d5b4bc12ec3ee466238cf82000e29d/mjepg_bandwidth.patch


I would really like to integrate the patch. I think I will do some
writeup and submit a clean version.

On Wed, Mar 18, 2015 at 7:50 AM, dongdong zhang <dongguangit@gmail.com> wrote:
> Using kernel 3.2.0 on ti am3354 ,
> Kernel 2.6.35.7 on samsung s5pv210,
> Kernel 3.0.8 on samsung s5pv210,
> Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:08:14 UTC
> 2014 i686 i686 i686 GNU/Linux
> Ubuntu 14.04 on x86
>
> I find it impossible to
> start motion with two UVC cameras:
>
> uvcvideo: Failed to submit URB 0 (-28).
>  Error starting stream.
>  VIDIOC_STREAMON: No space left on  device
>  ioctl(VIDIOCGMBUF) - Error device does not support memory map
> When using one UVC camera with the same configuration it works fine.
>  Is there a limitation in the UVC driver regarding simultaneous camera.
>
>
> Lowering the resolution on both two cameras to the minimum (160x120)
> open simultaneously doesn't
> help. However with the same camera of two UVC at 1280x720 open
> simultaneously  on windows xp software platform it works fine.
> So it doesn't seem to be a USB bandwidth problem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
