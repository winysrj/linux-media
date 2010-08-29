Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59557 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0H2FYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 01:24:37 -0400
Received: by pwi7 with SMTP id 7so1754876pwi.19
        for <linux-media@vger.kernel.org>; Sat, 28 Aug 2010 22:24:36 -0700 (PDT)
Message-ID: <4C79EF0F.2090401@brooks.nu>
Date: Sat, 28 Aug 2010 23:24:31 -0600
From: Lane Brooks <lane@brooks.nu>
MIME-Version: 1.0
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Subject: Snapshot with the OMAP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

  Laurent,

Suppose I am streaming 2048x1536 YUV images from a sensor into the OMAP. 
I am piping it through the resizer to drop it to 640x480 for display. So 
I am reading from /dev/video6 (resizer) and have the media bus links 
setup appropriately. Now the user presses the shutter button. What is 
the recommended way to read a single full resolution image?

It seems there are several options:

1. Reconfigure the media bus and read a single single full resolution 
image out of the CCDC output on /dev/video2 and then
reconfigure it back to video mode.

2. Reconfigure the resizer to stop downsampling but instead output the 
full resolution image for a single frame.

Do I need to stop the stream while doing either option?

These seem like clunky and slow options, though.

Is there a way to setup the media bus links so that I can actually have 
handles to /dev/video2 and /dev/video6 open simultaneously? Then I can 
normally read from /dev/video6 and then read single frames from 
/dev/video2 whenever the user presses the shutter button?

I have noticed there is a some ISP_PIPELINE_STREAM_SINGLESHOT streaming 
states in the isp code, but I don't what it is for or how to use it. Is 
it related to my questions at all?

It gets even more complex if I want the streaming the video out of the 
sensor at a lower resolution (for higher video rates) and want to change 
the resolution of the sensor for the snapshot.

Thanks,
Lane
