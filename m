Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:47691 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbATUDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 15:03:54 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so3166314lab.6
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 12:03:52 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Jan 2015 21:03:52 +0100
Message-ID: <CANMdSOwCgaY3SORCoy=_y9R_aZyPgBMgBnAqp0E8EjoBnQ8hkw@mail.gmail.com>
Subject: [stk1160] Audio chip not detected on a Easycap Model 001
From: Daniel Kamil Kozar <dkk089@gmail.com>
To: elezegarcia@gmail.com, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm running Linux 3.18.2. I have a "generic" Easycap device that I
would like to use, however it appears that my particular revision of
this device is not supported. The VID/PID of the device is 05e1:0408,
in fact the whole USB descriptor is the same as the "reference" one
available on the LinuxTV Wiki page -
http://www.linuxtv.org/wiki/index.php/Stk1160_based_USB_2.0_video_and_audio_capture_devices
.

The stk1160 driver detects the device and I can successfully capture
video through the device node. However, the AC97 codec available on
the board does not seem to be initialized at all, with the following
kernel message :

stk1160 2-1.1.2.4:1.0: AC'97 0 access is not valid [0x0], removing mixer.

Which means that the AC97 vendor ID has been read as either 0 or
0xff..ff. According to the aforementioned LinuxTV Wiki page, this
error occurs when the particular Easycap stick uses the 8-bit ADC
instead of a full AC97 codec. I had a look at the PCB itself, and it
seems to contain the following chips :

 * Syntek STK1160,
 * Philips SAA7113,
 * Realtek ALC655.

For your reference, photos of the PCB are available here :
http://i.imgur.com/tl6pb3C.jpg , http://i.imgur.com/ONWf5ir.jpg .

I also backported the old easycap driver to run on my kernel, however
the effect was exactly the same : the video is captured successfully,
but there is no audio. There is only a short burst of noise at the
start of the capture, which doesn't even occur with stk1160.

I'm really curious what may be wrong in this case. Is it possible that
the initialization of the AC97 codec fails due to another slight
modification of the hardware, or should I just assume that the
hardware is simply faulty? What can I do to further track down this
problem?

Thank you very much in advance,
-dkk
