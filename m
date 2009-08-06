Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:53423 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZHFVfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 17:35:24 -0400
Received: by yxe5 with SMTP id 5so1435028yxe.33
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 14:35:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c4aed99f0908061329h1485053cr7ac2b0319218e138@mail.gmail.com>
References: <c4aed99f0908061329h1485053cr7ac2b0319218e138@mail.gmail.com>
Date: Thu, 6 Aug 2009 17:35:24 -0400
Message-ID: <f34657950908061435g39ad4684ha6ed513617797166@mail.gmail.com>
Subject: Re: sn9c20x driver seems ok, but no video
From: Brian Johnson <brijohn@gmail.com>
To: Chris Hallinan <challinan@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris,
The sn9c20x module only supports jpeg, bayer and its own yuv420
format. most applications do not nativly understand these formats and
will therefore require the use of libv4l a user space library able to
convert between formats in order to work. This library was first
included on ubuntu with intrepid, since you are using hardy you will
have to manually download it and compile it yourself or upgrade your
ubuntu system to at least intrepid. If you don't decide to upgrade you
can download the latest version of libv4l at
http://people.atrpms.net/~hdegoede/

Also the driver you are using while it certainly should work fine when
using libv4l for conversion, there is now a gspca based version of
that driver included in the latest v4l-dvb as well as kernel
repositories, You should be able to upgrade from your jaunty kernel to
the current karmic kernel and have the gspca sn9c20x driver included.
You still will need to use the libv4l for handling format conversions
though.

Regards,
Brian Johnson

On Thu, Aug 6, 2009 at 4:29 PM, Chris Hallinan<challinan@gmail.com> wrote:
> Hi folks,
>
> Trying to get a usb webcam based on SN9C20x driver working on Ubuntu.
>
> Loading the module, everything looks good (log output trimmed for easy reading):
>
>  kernel: usb 7-3: new high speed USB device using ehci_hcd and address 4
>  kernel: usb 7-3: configuration #1 chosen from 1 choice
>  kernel: sn9c20x: SN9C20X USB 2.0 Webcam - 0C45:628F plugged-in.
>  kernel: sn9c20x: Detected OV9650 Sensor.
>  kernel: sn9c20x: Webcam device 0C45:628F is now controlling video
> device /dev/video0
>  kernel: input: SN9C20X Webcam as /class/input/input10
>  kernel: sn9c20x: No ack from I2C slave 0x30 for write to address 0x17
>  kernel: sn9c20x: Using yuv420 output format
>
> However, I've tried several different apps (cheese, Xsane, gstreamer,
> etc) but cannot
> see any video output.  I confess to being completely ignorant on
> issues video, etc. :)
>
> If I type 'cat /dev/video0 >j.dump', the green LED on camera comes on,
> and j.dump is filled with binary data.
>
> However, gst-launch shows this:
> # gst-launch-0.10 v4l2src ! ffmpegcolorspace ! ximagesink
> Setting pipeline to PAUSED ...
> ERROR: Pipeline doesn't want to pause.
> WARNING: from element /pipeline0/v4l2src0: Failed to get current input
> on device '/dev/video0'. May be it is a radio device
> Additional debug info:
> v4l2_calls.c(756): gst_v4l2_get_input (): /pipeline0/v4l2src0: system
> error: Invalid argument
> ERROR: from element /pipeline0/v4l2src0: Could not negotiate format
> Additional debug info:
> gstbasesrc.c(2387): gst_base_src_start (): /pipeline0/v4l2src0:
> Check your filtered caps, if any
> Setting pipeline to NULL ...
> FREEING pipeline ...
>
> I'm running Ubuntu Jaunty kernel (2.6.28) with Hardy userland.
>
> Any input/pointers would be most appreciated!  And if there is a
> better list to post such a question, I'd appreciate it.  I posted on
> microdia@googlegroups.com, but that list hasn't had a single message
> in more than 24 hours!
>
> Thanks,
>
> Chris
>
> --
> Life is like Linux - it never stands still.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
