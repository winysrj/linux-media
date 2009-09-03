Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46921 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZICLiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:38:51 -0400
Subject: Re: Audio on cx18 based cards (Hauppauge HVR1600)
From: Andy Walls <awalls@radix.net>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4A9FA529.9030707@onelan.com>
References: <4A9FA529.9030707@onelan.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 07:37:24 -0400
Message-Id: <1251977844.22279.28.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-09-03 at 12:14 +0100, Simon Farnsworth wrote:
> Hello,
> 
> I'm trying to make a Hauppauge HVR1600 (using the cx18 driver) work well
> with Xine; Hans de Goede has sorted out the video side of the card for
> me, and I now need to get the audio side cleared up.
> 
> I'm used to cards like the Hauppauge HVR1110, which exports an ALSA
> interface for audio capture; the HVR1600 doesn't do this. Instead, it
> exports a "video" device, /dev/video24 that appears to have some
> variation on PCM audio on it instead of video.

Yes, it's PCM straight from the capture unit in the CX23418.



> How should I handle this in Xine's input_v4l.c? Should the driver be
> changed to use ALSA?

It would be nice to have.  Your the first person to really need it.  The
end result can be ported to ivtv too.


>  If not, how do I detect this case, and how should I
> configure the PCM audio device?

It can be configured with the V4L2 control ioctl()s.  It should the be a
case of making select() and read() calls.


> If the driver needs modifying, I can do this, but I'll need an
> explanation of how to do so without breaking things for other people -
> I've not done much with ALSA drivers or with V4L2 drivers.

The skeleton of cx18-alsa support is almost done, but the heavy lifting
is not.

http://linuxtv.org/hg/~awalls/mc-lab

I'll push any uncommitted changes I have lying around to that repo
tonight.


Regards,
Andy


