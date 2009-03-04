Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:44150 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZCDBLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 20:11:08 -0500
Received: by yw-out-2324.google.com with SMTP id 5so2024416ywh.1
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 17:11:06 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Mar 2009 19:11:06 -0600
Message-ID: <819c946f0903031711ob76bd5dsac27c68eb6a92aee@mail.gmail.com>
Subject: em28xx problems
From: jim Peters <jiminycricket180@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Linux media group,
I hope I am asking this in the proper place and fashion, if not,
please let me know.
I have an old USB video capture device that I used some on windows a
few years ago and just the other day I found it and tried it on my
Mythtv box. It is a "Super Digital Video Dazzle Series USB 2.0 Box".
It is recognized on my system as a "eMPIA Technology, Inc. GrabBeeX+
Video Encoder", the board itself contains a em2800-02 chip as well as
a SAA1713H chip, the tuner is a "Shengyi Electronics" model TSY5311-N.

In both Mythtv an Tvtime I have Composite and S-video but the NTSC
tuner is not showing up.

Here are the relevant lines from Dmesg

em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2801): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 4
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 644
em28xx #0: Alternate setting 2, max size= 1288
em28xx #0: Alternate setting 3, max size= 2580
em28xx #0: em28xx chip ID = 9
saa7115' 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
tuner' 2-0061: chip found @ 0xc2 (em28xx #0)
tuner' 2-0063: chip found @ 0xc6 (em28xx #0)
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 0 (Temic PAL (4002 FH5))
em28xx #0: AC97 command still being executed: not handled properly!
em28xx #0: AC97 command still being executed: not handled properly!
em28xx #0: AC97 command still being executed: not handled properly!
em28xx #0: AC97 command still being executed: not handled properly!
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found eMPIA Technology, Inc. GrabBeeX+ Video Encoder
em28xx audio device (eb1a:2801): interface 1, class 1
usbcore: registered new interface driver em28xx
usbcore: registered new interface driver snd-usb-audio

I see it finds the tuner as a "Temic PAL (4002 FH5)" which I know is
incorrect because it's an NTSC tuner, I did try adding "tuner = 69"
(Tena TNF 5335 and similar models) to my modeprobe options but this
had no effect on the tuner working. (of course I am not sure that is
even the correct one to use, I just found 1 reference to it being
correct on the web.)

Is it possible to get TV working with this device?

Thanks, Jim
