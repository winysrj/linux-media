Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47009 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0GIVEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 17:04:24 -0400
Received: by yxk8 with SMTP id 8so559311yxk.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100709200312.755e8069@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Fri, 9 Jul 2010 17:04:03 -0400
Message-ID: <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 9, 2010 at 2:03 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> OK. So, this means that the sonixj driver sets something in the webcam
> which prevents the audio to run. I don't see anything but the GPIO.

I was considering adding more code to print out more detailed IO information.

> I have no ms-win trace from your webcam. May you do it? I just need the
> connection and one second of streaming with a USB sniffer in text mode
> as sniffbin.

I tried using a couple of USB sniffers in Windows 7, but I'm unable to
find one that has an option to save in text mode as sniffbin.
Apologies in advanced for the length of the log files that I managed
to capture. I captured the device connection, video capture start and
stop, then device removed. The capture start took a moment to begin
since the application loaded more slowly with usb capturing in
progress.

---------------------------

I tried using the open source SnoopyPro under Windows 7 and I'm not
sure how well it works normally, but I was unable to capture any usb
traffic in Win7. If you have any other suggestions let me know,
because I've never used a usb sniffer before. I connected my webcam to
a Windows XP laptop and was able to get it to capture (Windows XP
laptop is 32-bit, Windows7/Ubuntu 10.10 desktop is 64-bit...which is
what I am working to get the webcam working on).
http://sourceforge.net/projects/usbsnoop/

In the USB Devices list I see my camera listed 3 times:

USB\VID_045E&PID_00F7&REV_0101&MI_00,USB\VID_045E&PID_00F7&MI_00
USB\VID_045E&PID_00F7&REV_0101&MI_01,USB\VID_045E&PID_00F7&MI_01
USB\VID_045E&PID_00F7&REV_0101,USB\VID_045E&PID_00F7

Log file from SnoopyPro:
http://bit.ly/bNJiLu

---------------------------

I also installed a free usb sniffer called "Simple USB Logger" that
seemed to do a very good job and I captured data from the point that
the camera was plugged into usb, then start capture, end capture and
unplugged from usb. So it should be a large bit of the data you will
need.
http://www.all-freeware.com/download/67384/simple-usb-logger.html

Log file from Simple USB Logger:
http://bit.ly/92ipQ8

---------------------------

I hope these help and are what you were looking for. Let me know if
you needed something different or if there is more information I can
send to you. I've saved the exact program versions in case you have
trouble getting them for any reason and would like to look into them:
SnoopyPro: http://bit.ly/bX6r9r
Simple USB Logger: http://bit.ly/bshLuz

Thanks.

-- 
Kyle Baker
