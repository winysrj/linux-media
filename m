Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52504 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198AbZJaUPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 16:15:07 -0400
Subject: cx18: YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain
Date: Sat, 31 Oct 2009 16:16:44 -0400
Message-Id: <1257020204.3087.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

At

http://linuxtv.org/hg/~awalls/cx18-yuv

I have checked in some improvements to YUV handling in the cx18
driver.  

There was a problem in that a lost/dropped buffer between the cx18
driver and the CX23418 firmware would cause the video frame alignment to
be lost with no easy way to recover.

These changes do the following:

1. Force YUV buffer sizes to be large enough to hold either 1 full 525
line system frame or 1 full 625 line system frame with new module
options and defaults.  That makes the YUV buffers quite large, but
allows for "1 frame per buffer" for full sized video frames.

2. Not being able to allocate the now large YUV buffers is non-fatal.
The driver will still load and work for other stream types, even if it
can't get the YUV buffers.  A warning is blurted out in the log, in case
YUV buffers can't be allocated.

3. __GFP_REPEAT has been added when trying to make the initial video
buffer allocations.  After I added this, I never had the large YUV
buffers fail to be allocated.

4. We now lie to the firmware about the actual YUV buffer size, so that
the firmware always thinks the buffers are exactly large enough to hold
exactly an integral number of YUV frames based on the image height.
This means that dropped/lost YUV buffers between the cx18 driver and the
CX23418 firmware will only drop whole frames and no misalignment should
occur.


# modinfo cx18
[...]
parm:           enc_yuv_buffers:Encoder YUV buffer memory (MB). (enc_yuv_bufs can override)
			Default: 3 (int)
parm:           enc_yuv_bufsize:Size of an encoder YUV buffer (kB)
			Allowed values:
				  0 (do not allocate YUV buffers)
				507 (when never capturing 625 line systems)
				608 (when capturing 625 and/or 525 line systems)
			Default: 608 (int)
parm:           enc_yuv_bufs:Number of encoder YUV buffers
			Default is computed from other enc_yuv_* parameters (int)
[...]

# modprobe cx18
# mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc


You can add 'debug=264' to the modprobe line to watch the size of the
payloads coming back from the firmware to make sure they are an integral
number of frames, but logging stats on every noticably degrades
performance.

Regards,
Andy

