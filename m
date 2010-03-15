Return-path: <linux-media-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:22950 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756198Ab0COCsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 22:48:39 -0400
Message-ID: <4B9DA003.90306@teksavvy.com>
Date: Sun, 14 Mar 2010 22:48:35 -0400
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Mark Lord <kernel@teksavvy.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>	 <1267493641.4035.17.camel@palomino.walls.org>	 <4B8CA8DD.5030605@teksavvy.com> <1267533630.3123.17.camel@palomino.walls.org>
In-Reply-To: <1267533630.3123.17.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/10 07:40, Andy Walls wrote:
> Again, maybe dynamically allocating these work order objects from the
> kernel as needed, would be better from a small dynamically allocated
> pool for each card.  I was concerned that the interrupt handler was
> taking to long at the time I implemented the things the way they are
> now.
..

I haven't seen that particular issue again, with or without increasing
the work orders, so hopefully it won't recur.

But after updating to the tip of the v4l2-dvb git tree last week,
I've been hitting the "no audio" on analog recordings bug much more often.

Digging through google, it appears this problem has been around as long
as the cx18 driver has existed, with no clear resolution.  Lots of people
have reported it to you before, and nobody has found a silver bullet fix.

The problem is still there.

I have now spent a good many hours trying to isolate *when* it happens,
and have narrowed it down to module initialization.

Basically, if the audio is working after modprobe cx18, it then continues
to work from recording to recording until the next reboot.

If the audio is not working after modprobe, then simply doing rmmod/modprobe
in a loop (until working audio is achieved) is enough to cure it.

So for my Mythtv box here, I now have a script to check for missing audio
and do the rmmod/modprobe.  This is a good, effective workaround.

    http://rtr.ca/hvr1600/fix_hvr1600_audio.sh

That's a link to my script.

As for the actual underlying cause/bug, it's still not clear what is happening.
But the problem is a LOT more prevalent (for me, and for two other people I know)
with versions of the cx18 driver since spring 2009.

My suspicion is that the firmware download for the APU is somehow being corrupted,
and now that the driver downloads the firmware *twice* during init, it doubles the
odds of said corruption.  Just a theory, but it's the best fit so far.

I think we have some nasty i2c issues somewhere in the kernel.

Cheers
