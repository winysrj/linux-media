Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:45158 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbZH3SnW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 14:43:22 -0400
Date: Sun, 30 Aug 2009 20:43:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Dotan Cohen <dotancohen@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Using MSI StarCam 370i Webcam with Kubuntu Linux
Message-ID: <20090830204315.515e98af@tele>
In-Reply-To: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
References: <880dece00908281140r16385c1fr476b18f2fcfe3c1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Aug 2009 21:40:38 +0300
Dotan Cohen <dotancohen@gmail.com> wrote:

> I have the MSI StarCam 370i Webcam and I have trying to use it with
> Kubuntu Linux 9.04 Jaunty. According to this page, "The StarCam 370i
> is compliant with UVC, USB video class":
> http://gadgets.softpedia.com/gadgets/Computer-Peripherals/The-MSI-StarCam-370i-3105.html
> 
> According to the Linux UVC driver and tools download page, "Linux
> 2.6.26 and newer includes the Linux UVC driver natively" which is nice
> as I am on a higher version:
> $ uname -r
> 2.6.28-15-generic
> 
> However, plugging in the webcam and testing with camorama, cheese, and
> luvcview led me to no results:
	[snip]
> jaunty2@laptop:~$ dmesg | tail
> [ 2777.811972] sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers
> v1:1.47pre49
> [ 2777.814989] usb 2-1: SN9C105 PC Camera Controller detected (vid:pid
> 0x0C45:0x60FC)
> [ 2777.842123] usb 2-1: HV7131R image sensor detected
> [ 2778.185108] usb 2-1: Initialization succeeded
> [ 2778.185220] usb 2-1: V4L2 device registered as /dev/video0
> [ 2778.185225] usb 2-1: Optional device control through 'sysfs'
> interface disabled
> [ 2778.185283] usbcore: registered new interface driver sn9c102
> [ 2778.216691] usbcore: registered new interface driver snd-usb-audio
> [ 2778.218738] usbcore: registered new interface driver sonixj
> [ 2778.218745] sonixj: registered
	[snip]
> Anything missing? What should I do? Thanks in advance!

Hello Dotan,

Your webcam is not UVC compliant. One problem may be the fact that it is
handled by 2 drivers: sn9c102 and gspca/sonixj. In both cases, the
driver gives JPEG images. These ones are not handled natively by some
applications as luvcview which knows only about MJPG. You have to use
the wrapper of the v4l2 library to make them work.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
