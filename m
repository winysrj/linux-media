Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49722 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537Ab3GUOrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 10:47:36 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id B838620ED5
	for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 10:47:35 -0400 (EDT)
Received: from symphony.aura-online.co.uk (unknown [77.99.213.246])
	by mail.messagingengine.com (Postfix) with ESMTPA id 4EE02680104
	for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 10:47:35 -0400 (EDT)
Date: Sun, 21 Jul 2013 15:47:34 +0100
From: James Le Cuirot <chewi@aura-online.co.uk>
To: linux-media@vger.kernel.org
Subject: No events for LifeView FlyDVB-S LR300 (saa7134-input)
Message-ID: <20130721154734.5285ea31@symphony.aura-online.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have had a LifeView FlyDVB-S LR300 for many years and used it
successfully with LIRC using the saa7134-input driver for much of that
time. About a year ago, LIRC stopped working but I've never been able
to determine precisely why.

udev successfully symlinks my device to /dev/input/lr300 and lircd
successfully starts using the -H devinput -d /dev/input/lr300 options.

The problem is that the clients never seem to receive any events. I've
tried really basic things like "ircat mythtv" with a single action
defined, as shown below. Nothing. Not even a hint of activity with
strace.

begin
  prog = mythtv
  button = KEY_1
  config = 1
end

I know that the above configuration is being read from /etc/lirc/lircrc
because I can see the contents in the strace output. My lircd.conf file
is based on the top half of the sample devinput file distributed with
LIRC, not the obsolete 32-bit bottom half. I know that is being read by
lircd for the same reason. I did try creating my own with irrecord and
while it was able to pick up the button presses, clients were
subsequently unable to receive them.

If I cat /dev/input/lr300 and press a few buttons then I see some
output. However, this output stops after the first client connects. I
then don't see any further output until I stop lircd. This may be
normal, I'm not sure. I suspect it is because if I run lircd in the
foreground with strace, I still see activity when I press buttons, even
after the output from /dev/input/lr300 stops.

This would lead one to suspect a communication issue between lircd and
the clients but I do see the "accepted new client" message from lircd
so there is at least some chatter going on.

I'm not sure if these problems began with the arrival of the new remote
control kernel drivers. I gather these make it possible to use remotes
without the need for LIRC? I also gather that LIRC still has its uses
and is well supported by applications so I still intend to use it.
Either way, no matter what I do, I can never get any keytables or
protocols associated with the device. ir-keytable always gives me this,
despite having loaded all the associated modules.

Found /sys/class/rc/rc0/ (/dev/input/event5) with:
	Driver saa7134, table rc-empty
	Supported protocols: 
	Enabled protocols: 
	Name: saa7134 IR (LifeView FlyDVB-S /
	bus: 1, vendor/product: 5168:0300, version: 0x0001
	Repeat delay = 500 ms, repeat period = 125 ms

Perhaps the saa7134-input driver hasn't been updated for this new
model? Is this why I can't get LIRC to work? I actually believe these
are two separate issues but please tell me if I'm wrong.

My environment is a relatively up-to-date Gentoo system running Linux
3.9.4 and lirc 0.9.0. Any help would be appreciated and I will gladly
provide more information. I did post this to the LIRC list initially
but got no response there so trying here instead.

Regards,
James
