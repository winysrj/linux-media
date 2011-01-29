Return-path: <mchehab@pedra>
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:58973
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410Ab1A2Rhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 12:37:40 -0500
Received: from [192.168.2.54] (unknown [192.168.2.54])
	by oac.localdomain (Postfix) with ESMTP id B8A86212E3D
	for <linux-media@vger.kernel.org>; Sat, 29 Jan 2011 11:31:45 -0600 (CST)
Subject: HDPVR Woes
From: Rob Davis <rob@davis-family.info>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Jan 2011 11:31:44 -0600
Message-ID: <1296322304.1732.40.camel@eeepc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am using a Hauppauge HDPVR unit with vdr and the pvrinput plugin. This
normally works really well, however every now and then thing stops
streaming, the big blue light goes off and pvrinput doesn't notice.  I
am trying to diagnose this with Lars Hanisch, one of the authors of
pvrinput.

The part of pvrinput it's failing on is:

else if (FD_ISSET(parent->v4l2_fd, &selSet)) {
log(pvrDEBUG1, "read");
r = read(parent->v4l2_fd, buffer, bufferSize);
log(pvrDEBUG1, "done read");


So, it never returns from r = read(parent->v4l2_fd, buffer, bufferSize);

If I do a cat /dev/video0 >/tmp/test.ts, and change the resolution of 
the cable box, the cat command never finishes, but the blue light goes 
out and test.ts stops increasing in size. (This simulates the same kind 
of behaviour, so I'm guessing it's a TS error of some sort).

I am compiling the latest dev tree of v4l at the moment but don't think 
much development has happened in this driver.

The problem compounds on VDR as if there is no signal while recording, 
VDR assumes its a driver lockup and restarts itself, breaking any 
concurrent recordings on other input devices.

Rob

