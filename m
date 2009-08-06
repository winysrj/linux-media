Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f183.google.com ([209.85.212.183]:58897 "EHLO
	mail-vw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZHFU3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 16:29:17 -0400
Received: by vws13 with SMTP id 13so1071790vws.22
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 13:29:17 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 6 Aug 2009 16:29:17 -0400
Message-ID: <c4aed99f0908061329h1485053cr7ac2b0319218e138@mail.gmail.com>
Subject: sn9c20x driver seems ok, but no video
From: Chris Hallinan <challinan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Trying to get a usb webcam based on SN9C20x driver working on Ubuntu.

Loading the module, everything looks good (log output trimmed for easy reading):

 kernel: usb 7-3: new high speed USB device using ehci_hcd and address 4
 kernel: usb 7-3: configuration #1 chosen from 1 choice
 kernel: sn9c20x: SN9C20X USB 2.0 Webcam - 0C45:628F plugged-in.
 kernel: sn9c20x: Detected OV9650 Sensor.
 kernel: sn9c20x: Webcam device 0C45:628F is now controlling video
device /dev/video0
 kernel: input: SN9C20X Webcam as /class/input/input10
 kernel: sn9c20x: No ack from I2C slave 0x30 for write to address 0x17
 kernel: sn9c20x: Using yuv420 output format

However, I've tried several different apps (cheese, Xsane, gstreamer,
etc) but cannot
see any video output.  I confess to being completely ignorant on
issues video, etc. :)

If I type 'cat /dev/video0 >j.dump', the green LED on camera comes on,
and j.dump is filled with binary data.

However, gst-launch shows this:
# gst-launch-0.10 v4l2src ! ffmpegcolorspace ! ximagesink
Setting pipeline to PAUSED ...
ERROR: Pipeline doesn't want to pause.
WARNING: from element /pipeline0/v4l2src0: Failed to get current input
on device '/dev/video0'. May be it is a radio device
Additional debug info:
v4l2_calls.c(756): gst_v4l2_get_input (): /pipeline0/v4l2src0: system
error: Invalid argument
ERROR: from element /pipeline0/v4l2src0: Could not negotiate format
Additional debug info:
gstbasesrc.c(2387): gst_base_src_start (): /pipeline0/v4l2src0:
Check your filtered caps, if any
Setting pipeline to NULL ...
FREEING pipeline ...

I'm running Ubuntu Jaunty kernel (2.6.28) with Hardy userland.

Any input/pointers would be most appreciated!  And if there is a
better list to post such a question, I'd appreciate it.  I posted on
microdia@googlegroups.com, but that list hasn't had a single message
in more than 24 hours!

Thanks,

Chris

-- 
Life is like Linux - it never stands still.
