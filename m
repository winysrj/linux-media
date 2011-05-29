Return-path: <mchehab@pedra>
Received: from mxout002.mail.hostpoint.ch ([217.26.49.181]:59728 "EHLO
	mxout002.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882Ab1E2NpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 09:45:23 -0400
Received: from [10.0.2.20] (helo=asmtp002.mail.hostpoint.ch)
	by mxout002.mail.hostpoint.ch with esmtp (Exim 4.76 (FreeBSD))
	(envelope-from <hackfin@section5.ch>)
	id 1QQfhy-0000iR-PC
	for linux-media@vger.kernel.org; Sun, 29 May 2011 15:07:06 +0200
Received: from [82.192.239.137] (helo=[0.0.0.0])
	by asmtp002.mail.hostpoint.ch with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76 (FreeBSD))
	(envelope-from <hackfin@section5.ch>)
	id 1QQfhy-000E1u-8q
	for linux-media@vger.kernel.org; Sun, 29 May 2011 15:07:06 +0200
Message-ID: <4DE244F4.90203@section5.ch>
Date: Sun, 29 May 2011 15:07:00 +0200
From: Martin Strubel <hackfin@section5.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: v4l2 device property framework in userspace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I was wondering if it makes sense to raise a discussion about a few
aspects listed below - my apology, if this might be old coffee, I
haven't been following this list for long.

Since older kernels didn't have the matching functionality, we (a few
losely connected developers) had "hacked" a userspace framework to
address various extra features (multi sensor head, realtime stuff or
special sensor properties). So, our kernel driver (specific to the PPI
port of the Blackfin architecture) is covering frame acquisition only,
all sensor specific properties (that were historically rather to be
integrated into the v4l2 system) are controller from userspace or over
network using our netpp library (which was just released into opensource).

The reasons for this were:
1. 100's of register controlling various special properties on some SoC
sensors
2. One software and kernel should work with all sorts of camera
configuration
3. I'm lazy and hate to do a lot of boring code writing (ioctls()..).
Also, we didn't want to bloat the kernel with property tables.
4. Some implementations did not have much to do with classic "video"

So nowadays we write or parse sensor properties into XML files and
generate a library for it that wraps all sensor raw entities (registers
and bits) into named entities for quick remote control and direct access
to peripherals on the embedded target during the prototyping phase (this
is what netpp does for us).

Now, the goal is to opensource stuff from the Blackfin-Side, too (as
there seems to be no official v4l2 driver at the moment). Obviously, a
lot of work has been done meanwhile on the upstream v4l2 side, but since
I'm not completely into it yet, I'd like to ask the experts:

1. Can we do multi sensor configurations on a tristated camera bus with
the current kernel framework?
2. Is there a preferred way to route ioctls() back to userspace
"property handlers", so that standard v4l2 ioctls() can be implemented
while special sensor properties are still accessible through userspace?
3. Has anyone measured latencies (or is aware of such) with respect to
process response to a just arrived video frame within the RT_PREEMPT
context? (I assume any RT_PREEMPT latency research could be generalized
to video, but asking anyhow)
4. For some applications it's mandatory to queue commands that are
commited to a sensor immediately during a frame blank. This makes the
shared userspace and kernel access for example to an SPI bus rather
tricky. Can this be solved with the current (new) v4l2 framework?

Cheers,

- Martin
