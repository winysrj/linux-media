Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:33190 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1HYQPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 12:15:49 -0400
Message-ID: <4E56734A.3080001@mlbassoc.com>
Date: Thu, 25 Aug 2011 10:07:38 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Getting started with OMAP3 ISP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Background:  I have working video capture drivers based on the
TI PSP codebase from 2.6.32.  In particular, I managed to get
a driver for the TVP5150 (analogue BT656) working with that kernel.

Now I need to update to Linux 3.0, so I'm trying to get a driver
working with the rewritten ISP code.  Sadly, I'm having a hard
time with this - probably just missing something basic.

I've tried to clone the TVP514x driver which says that it works
with the OMAP3 ISP code.  I've updated it to use my decoder device,
but I can't even seem to get into that code from user land.

Here are the problems I've had so far:
   * udev doesn't create any video devices although they have been
     registered.  I see a full set in /sys/class/video4linux
        # ls /sys/class/video4linux/
        v4l-subdev0  v4l-subdev3  v4l-subdev6  video1       video4
        v4l-subdev1  v4l-subdev4  v4l-subdev7  video2       video5
        v4l-subdev2  v4l-subdev5  video0       video3       video6

     Indeed, if I create /dev/videoX by hand, I can get somewhere, but
     I don't really understand how this is supposed to work.  e.g.
       # v4l2-dbg --info /dev/video3
       Driver info:
           Driver name   : ispvideo
           Card type     : OMAP3 ISP CCP2 input
           Bus info      : media
           Driver version: 1
           Capabilities  : 0x04000002
                   Video Output
                   Streaming

   * If I try to grab video, the ISP layer gets a ton of warnings, but
     I never see it call down into my driver, e.g. to check the current
     format, etc.  I have some of my own code from before which fails
     miserably (not a big surprise given the hack level of those programs).
     I tried something off-the-shelf which also fails pretty bad:
       # ffmpeg -t 10 -f video4linux2 -s 720x480 -r 30 -i /dev/video2 junk.mp4

I've read through Documentation/video4linux/omap3isp.txt without learning
much about what might be wrong.

Can someone give me some ideas/guidance, please?

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
