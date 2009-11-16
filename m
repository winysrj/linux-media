Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:55669 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZKPPwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 10:52:35 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1090395qwe.37
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 07:52:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B016937.7010906@rug.nl>
References: <4B016937.7010906@rug.nl>
Date: Mon, 16 Nov 2009 10:52:40 -0500
Message-ID: <829197380911160752lcbfd202gcdbed97b85238bd2@mail.gmail.com>
Subject: Re: xawtv and v4lctl with usbvision kernel driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sietse Achterop <s.achterop@rug.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 16, 2009 at 10:01 AM, Sietse Achterop <s.achterop@rug.nl> wrote:
>    Dear all,
>
> Context:
>  debian/lenny with usb frame grabber:
>     Zoran Co. Personal Media Division (Nogatech) Hauppauge WinTV Pro (PAL/SECAM)
>  This uses the usbvision driver.
>
> The problem is that while xawtv works OK with color, v4lctl ONLY shows the frames
> in black-and-white.
>
> I understood that the usbvision driver needs some attention, e.g. a command like
> "v4lctl setinput 2" is not working, it will keep using setting 0.
> Because I need 2 (S-video) I patched the driver to always use 2 by setting
> channel=2 in "usbvision_muxsel" to permanently select that channel.
> With that usbvision module loaded I am getting pictures, but in BLACK_AND_WHITE,
> as mentioned.
>
> When starting "xawtv", it works fine!
>
> With a simple opencv application I do an
>        CvCapture* capture = cvCaptureFromCAM( cnum );
>                 ...
>        cam = (CvCaptureCAM_V4L*)capture;
>                 ...
>        ioctl(cam->deviceHandle,VIDIOC_G_FMT,&format))
>                 ...
> and find that the format is YV12, but the picture is black-and-white.
> But YV12 is a color format.
>
> The question is, how to get proper color pictures when using v4lctl or other
> simple applications with this driver.
>
>  Thanks in advance,
>    Sietse Achterop

I don't know about that board in particular, but on some boards the
composite and s-video are actually wired together (sharing the luma
line), so if you have the device configured in "composite" mode but
have the s-video plugged in, then you will get a black/white image
(since it expects to see both luma/chroma on the one pin that provides
luma).

I had this issue on the HVR-950q.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
