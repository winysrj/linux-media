Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40942 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbZITCWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 22:22:38 -0400
Subject: Preliminary working HVR-1850 IR hardware and grey Hauppauge RC-5
	remote
From: Andy Walls <awalls@radix.net>
To: stoth@kernellabs.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <1252369138.2571.17.camel@morgan.walls.org>
References: <1252297247.18025.8.camel@morgan.walls.org>
	 <1252369138.2571.17.camel@morgan.walls.org>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 22:20:36 -0400
Message-Id: <1253413236.13400.24.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve,

I've finally have a working implementation of the the HVR-1850 IR
receiver and the grey Hauppauge RC-5 remote with in kernel (non-LIRC) IR
input to key press events.

If you feel adventurous, give it a try for testing the IR receiver:

http://www.linuxtv.org/hg/~awalls/cx23888-ir


Caveat emptor:

1. I would not recommend reviewing the code by individual change sets.
The change sets become an evolutionary mess towards the end, as I would
find a few minutes here or there to add a few lines of code. :)  I will
provide a cleaned up version, most likely some time after the LPC.

2. I need to clean up of some dead/commented out code.

3. I need to port it forward to catch up with recent changes to the
cx25840 module, cx23885 module, and IR keytable changes.  (The code
compiles and works, but I started working from a v4l-dvb clone from a
few months ago. There have been a few changes in areas I have worked.)

4. It only works for CX23888 devices right now. CX23885 devices should
be easy enough to support after cleanup and initial merge of this code.

5. I specifically did not address the RC-6(A) remote.  With the
CX2388[58] hardware, it wouldn't be hard to handle the RC-6(A) remote,
but the v4l-dvb tree is missing lots of RC-6 definitions and helper
functions.  I figured I'd rather focus on a LIRC plug-in for a
v4l_device rather than reinvent RC-6(A) inside the v4l-dvb code.


Regards,
Andy

