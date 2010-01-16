Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39091 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0APEEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 23:04:25 -0500
Subject: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>,
	"Igor M. Liplianin" <liplianin@me.by>, stoth@kernellabs.com
Content-Type: text/plain
Date: Fri, 15 Jan 2010 23:02:41 -0500
Message-Id: <1263614561.6084.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got reworked changes for the IR for the TeVii S470 and the HVR-1250
at

	http://linuxtv.org/hg/~awalls/cx23885-ir2

Thanks to loaner HVR-1250 hardware from Devin Heitmueller,
I've solved the infinite interrupt problem with the CX23885 AV core and
have reworked the change set against the latest v4l-dvb.

Please test.

Note

1. the parameters for the IR controller setup in
linux/drivers/video/cx23885-input.c may need to be tweaked to set the
proper "params.modulation" and "params.invert_level" before you get
keypresses decoded.

2. I guessed at a reasonable set of remote keycodes for the TeVii S470,
so don't be surprised if the button mapping isn't quite right.

3.  These module settings may be helpful for debug and test:

       # modprobe cx25840 debug=2 ir_debug=2
       # modprobe cx23885 debug=7

Also directing "kern.*" messages to /var/log/messages
in /etc/rsyslogd.conf and giving rsyslod a SIGHUP may be helpful for
capturing the messages.

4.  In case I didn't fix the infinite interrupts problem for the TeVii
S470: Before testing, blacklist the cx23885 module
in /etc/modprobe.d/blacklist, so that when you reboot, the module
doesn't automatically load.  If your system seems to be very busy with
inifinite interrupts upon cx23885 module load, stop testing (and let me
know). 

Regards,
Andy

