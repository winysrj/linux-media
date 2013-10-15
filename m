Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53726 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3JOOPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 10:15:32 -0400
Message-ID: <525D4DFB.9080806@gmail.com>
Date: Tue, 15 Oct 2013 10:15:23 -0400
From: Gary Mort <garyamort@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: linux-usb@vger.kernel.org
Subject: [RFC] Using UVC as a monitor
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm pulling together code at the moment which I'll post for comment 
later in the week.

What I want to do is combine the operations of 2 drivers to create a 
virtual monitor via UVC, uvcfbsource

It involves configuring the UVC video-streaming capability of the USB 
Webcam Gadget to use a framebuffer as it's source.

The SimpleFB driver currently in the kernel requires the framebuffer 
memory to be allocated by some other program/driver - so it seems a good 
choice for the framebuffer.

Using the current capabilities of the USB webcam gadget, it seems for a 
simple solution all I need to do is have a userspace application which 
grabs the framebuffer data, wraps it into a videobuf2 format and inserts 
it into the queue.

In this mode, the "Monitor" becomes any application capable of 
displaying streaming video - for that matter, if multiple instances of 
the userspace application are executed then you can have multiple 
monitors all displayed on the same computer.

Purpose: I am working with a couple of ARM development boards, primarily 
the BeagleBoneBlack.  Using a usb montor gadget, I can give my BBB a 
monitor without actually having to plug in a monitor.

In simple mode, the framebuffer would be configured with a resolution of 
720p and to store data in the YUV format so it matches one of the 
currently defined formats in the Webcam gadget.

Beyond that though, I'd like to extend this to a smarter kernel driver 
which could:
1) Use the start streaming/stop streaming USB events to emulate 
hotplugging the monitor.
2) Allow for different resolutions to be supported and controlled by the 
remote computer[IE show different options, and allow the webcam viewer 
application to choose one of the streams]
3) Allow for the complete set of UVC supported YUV formats for frames
4) Switch from the video stream UVC encapsulation to the frame buffer stream

Using UVC in this manner has the downside that full uncompressed frame 
data is being transmitted over USB - however UVC does provide a number 
of optional compression and encoding methods - so it's possible to 
improve performance if there is demand for it.  It is also possible to 
use 'vendor defined' compression and encoding methods if those are not 
sufficient.   Since UVC allows the gadget to advertise multiple 
capabilities - a device using the uvcfbsource driver could be used by 
any system supporting standard Webcams - Mac, Windows, Android, Linux, 
etc via the uncompressed format - while the compressed format can be 
used if the viewer application supports it.

I wanted to check now to see if there is something I'm missing, or known 
projects already working on this sort of thing, before I start coding.

My long term goal is to use the code developed for a fully functional 
uvcfbsink driver to create a uvcfbsource driver: ie an application which 
reverses the process and receives data from a uvc "webcam" and pushes it 
into a framebuffer.  That would allow for creating an open source 
alternative to DisplayLink while avoiding any usage of their API and any 
potential patent issues.


-Gary






