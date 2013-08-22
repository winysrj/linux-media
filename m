Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60331 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3HVHTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 03:19:45 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so1298866wes.33
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 00:19:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130820T114431-434@post.gmane.org>
References: <loom.20130820T114431-434@post.gmane.org>
Date: Thu, 22 Aug 2013 09:19:44 +0200
Message-ID: <CAGGh5h1GauYirv=LT4GEbHKSAO85X_-BLoz60D1eDS+L0XnEoA@mail.gmail.com>
Subject: Re: OMAP3 ISP change image format
From: jean-philippe francois <jp.francois@cynove.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is my understanding that you should set up the format with
media-ctl, and only check
the result in your application. In other words, using G/S/TRY_FMT
ioctl on the video output
nodes won't work.

You can try the following pipeline :
ov3640 -> ccdc -> previewer -> previewer V4L2 output

and set previewer sink pad to bayer and previewer src pad to yuv

I don't think you can output rgb565 however. It is only an input
format for the CCDC.
Anyway, when you use G/S/TRY_FMT ioctl, always check the returned format.


2013/8/20 Tom <Bassai_Dai@gmx.net>:
> Hello,
>
> I try from my own application out to grab an image with a ov3640 sensor. For
> this I need to understand the media-api and the isp pipeline correctly.
>
> I had problems with the use of media-ctl so I implemented the functionality
> into my application and it seems to work fine. Without an error I grabbed an
> image, but it was black.
>
> So maybe my format settings are not correctly set. My Question is:
>
> For example I want to grab a rgb565 image from my camera sensor and display
> it on a webpage. my pipeline looks like this:
>
> ov3640->ccdc->memory
>
> Would it be enough to just set a raw bayer format on the source and sink
> pads and just the format of the video device (/dev/video2) as rgb565?
>
> Regards, Tom
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
