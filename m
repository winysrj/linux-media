Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:17849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbZC0Jgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 05:36:33 -0400
Received: by fg-out-1718.google.com with SMTP id 16so145fgg.17
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 02:36:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49CA0457.1090708@redhat.com>
References: <49C7E5A1.9010501@gmail.com> <49CA0457.1090708@redhat.com>
Date: Fri, 27 Mar 2009 10:36:29 +0100
Message-ID: <62e5edd40903270236x35157732mbf81c699afdd0fd0@mail.gmail.com>
Subject: Re: libv4l, yuv420 and gspca-stv06xx conversion
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/3/25 Hans de Goede <hdegoede@redhat.com>:
>
>
> On 03/23/2009 08:40 PM, Erik Andrén wrote:
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi Hans,
>> I'm trying to get gstreamer and the yuv420 format conversion in
>> libv4l to play nice with the gspca-stv06xx driver. Currently this is
>> not working.
>>
>> The resolution of the vv6410 sensor is 356*292 pixels and the native
>> format of the camera is V4L2_PIX_FMT_SGRBG8.
>> This produces a total image size of 103952 bytes which gets page
>> aligned to 106496.
>>
>> When requesting to conversion to yuv420 in gstreamer I launch
>> gst-launch with the following parameters:
>> gst-launch-0.10 -v v4l2src queue-size=4 ! ffmpegcolorspace ! xvimageink
>>
>> gstreamer then proceeds with complaining that it received a frame of
>>  size 155928 bytes but it expected a frame of size 156512 bytes.
>>
>> The delivered 155928 size seems sane as 155928 / 356 gives 438 and
>> 155928 / 292 gives 534.
>>
>> Furthermore, the difference between the received size and the
>> expected size is 584 bytes which is 2x the height.
>>
>> Anyhow, I hacked libv4l2.c and padded the frame with 584 in order to
>> acheive the requested 156512 bytes. This worked and yielded the
>> attached image.
>>
>> I'm currently at loss what's the root cause of this.
>>
>> Could the page align interfer somehow with the frame size?
>> What's the correct image size? The converted image is clearly correct.
>>
>
> I think that something in the gstreamer stack expect the U and V planes of
> the YUV planar data, to have each line start 32 bit word aligned. So they
> expect us to add 2 bytes of padding after each line of U and V data.
>
> That would give us 2 x (292 / 2) extra bytes for the U and for the V plane,
> so 2 x (2 x (292 / 2)) = 584 bytes of additional data, and would also
> explain the color banding in the image you've attached.
>
> Now the question is, is gstreamer right in assuming this padding?
>

You're right in that gstreamer expects:

        outsize = GST_ROUND_UP_4 (*w) * GST_ROUND_UP_2 (*h);
        outsize += 2 * ((GST_ROUND_UP_8 (*w) / 2) * (GST_ROUND_UP_2 (*h) / 2));

I tried to hack around this by changing the 8 to a 4 which produces
the same image as when I added the 584 offset.
My take is that the alignment is also used somewhere else in the
gstreamer stack. I'll try to post on their devel list and see if I can
get any tips on how to resolve this problem.

Best regards,
Erik


> The v4l2 standard is pretty clear on this:
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/c2030.htm#V4L2-PIX-FORMAT
>
> And then the bytesperline description, clearly says the what gstreamer
> expects is wrong.
> But what is normal for other YUV420 planar data producing sources?
>
> Regards,
>
> Hans
>
