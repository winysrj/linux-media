Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51315 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZCYKO1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 06:14:27 -0400
Message-ID: <49CA0457.1090708@redhat.com>
Date: Wed, 25 Mar 2009 11:15:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Subject: Re: libv4l, yuv420 and gspca-stv06xx conversion
References: <49C7E5A1.9010501@gmail.com>
In-Reply-To: <49C7E5A1.9010501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/23/2009 08:40 PM, Erik Andrén wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Hans,
> I'm trying to get gstreamer and the yuv420 format conversion in
> libv4l to play nice with the gspca-stv06xx driver. Currently this is
> not working.
>
> The resolution of the vv6410 sensor is 356*292 pixels and the native
> format of the camera is V4L2_PIX_FMT_SGRBG8.
> This produces a total image size of 103952 bytes which gets page
> aligned to 106496.
>
> When requesting to conversion to yuv420 in gstreamer I launch
> gst-launch with the following parameters:
> gst-launch-0.10 -v v4l2src queue-size=4 ! ffmpegcolorspace ! xvimageink
>
> gstreamer then proceeds with complaining that it received a frame of
>   size 155928 bytes but it expected a frame of size 156512 bytes.
>
> The delivered 155928 size seems sane as 155928 / 356 gives 438 and
> 155928 / 292 gives 534.
>
> Furthermore, the difference between the received size and the
> expected size is 584 bytes which is 2x the height.
>
> Anyhow, I hacked libv4l2.c and padded the frame with 584 in order to
> acheive the requested 156512 bytes. This worked and yielded the
> attached image.
>
> I'm currently at loss what's the root cause of this.
>
> Could the page align interfer somehow with the frame size?
> What's the correct image size? The converted image is clearly correct.
>

I think that something in the gstreamer stack expect the U and V planes of
the YUV planar data, to have each line start 32 bit word aligned. So they
expect us to add 2 bytes of padding after each line of U and V data.

That would give us 2 x (292 / 2) extra bytes for the U and for the V plane,
so 2 x (2 x (292 / 2)) = 584 bytes of additional data, and would also
explain the color banding in the image you've attached.

Now the question is, is gstreamer right in assuming this padding?

The v4l2 standard is pretty clear on this:
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/c2030.htm#V4L2-PIX-FORMAT

And then the bytesperline description, clearly says the what gstreamer expects is wrong.
But what is normal for other YUV420 planar data producing sources?

Regards,

Hans
