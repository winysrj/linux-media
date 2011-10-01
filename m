Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57775 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1JAPzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 11:55:43 -0400
Received: by gyg10 with SMTP id 10so2310652gyg.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 08:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8716D1.9010104@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <4E8716D1.9010104@mlbassoc.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sat, 1 Oct 2011 17:55:28 +0200
Message-ID: <CAAwP0s07U3wHR0LoSmvQzXG3KxUoARgjH7G2gxi911RBVe9HRw@mail.gmail.com>
Subject: Re: [PATCH 0/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 1, 2011 at 3:34 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-09-30 18:33, Javier Martinez Canillas wrote:
>>
>> Hello,
>>
>> The tvp5150 video decoder is usually used on a video pipeline with several
>> video processing integrated circuits. So the driver has to be migrated to
>> the new media device API to reflect this at the software level.
>>
>> Also the tvp5150 is able to detect what is the video standard at which
>> the device is currently operating, so it makes sense to add video format
>> detection in the driver as well as.
>>
>> This patch-set migrates the tvp5150 driver to the MCF and adds video
>> format detection.
>>
>
> What is this patchset relative to?

Hello Gary,

Thank you, I'm a newbie with v4l2 in general and media controller
framework in particular so your comments and suggestions are highly
appreciated.

I'm working to have proper support for the tvp5151 video capture
connected through its parallel interface with our custom TI DM3730 ARM
OMAP board. I think it's better to show the code as early as possible
so I can have feedback from the community an see if I'm in the right
path or completely lost, that is this patch-set about :)

We hack a few bits of the ISP CCDC driver to support ITU-R BT656
interlaced data with embedded syncs video format and ported the
tvp5150 driver to the MCF so it can be detected as a sub-device and be
part of the OMAP ISP image processing pipeline (as a source pad).

We are configuring the graph like this:

./media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'

I thought (probably wrong for your comments) that since the tvp5150
can sense which signal shape is being transfer to it (NTSC/PAL/etc) we
can configure automatically the tvp5150 source pad frame format to
capture all the lines (not only the visible ones). And if user space
wants a different frame format we can process the image latter.

So we only have to configure the ISP CCDC input pad format to be
coherent with the tvp5150 output pad.

./media-ctl --set-format '"OMAP3 ISP CCDC":0 [UYVY 720x625]'

> Does it still handle the case of overscan? e.g. I typically capture from
> an NTSC source using this device at 720x524.

For the case of the overscan of if you want to crop the image I
thought to use either the CCDC (to copy less lines on the memory
output buffer) or the ISP resizer. But in that case one has to
manually configure a different pipeline including the resizer and set
the frame formats for each input and output pad (probably I'm wrong
with this approach too).

> Even if it does detect the signal shape (NTSC, PAL), doesn't one still need
> to [externally] configure the pads for this shape?
>

Yes, that is why I wanted to do the auto-detection for the tvp5151, so
we only have to manually configure the ISP components (or any other
hardware video processing pipeline entities, sorry for my
OMAP-specific comments).

> Have you given any thought as to how the input (composite-A, composite-B or
> S-Video)
> could be configured using the MCF?
>

I didn't know that the physical connection affected the video output
format, I thought that it was only a physical medium to carry the same
information, sorry if my comments are silly but I'm really newbie with
video in general.

> Note: CC list trimmed to only the linux-media list.
>

Thanks a lot, I just followed get_maintainer script suggestions.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
