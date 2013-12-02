Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57735 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab3LBUKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Dec 2013 15:10:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VnZoi-0002rf-06
	for linux-media@vger.kernel.org; Mon, 02 Dec 2013 21:10:04 +0100
Received: from wsip-70-164-106-210.sd.sd.cox.net ([70.164.106.210])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 02 Dec 2013 21:10:03 +0100
Received: from abishop by wsip-70-164-106-210.sd.sd.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 02 Dec 2013 21:10:03 +0100
To: linux-media@vger.kernel.org
From: Alex Bishop <abishop@datacast.com>
Subject: dvbnet - Multiple PIDs on Single Network Interface Attempt
Date: Mon, 2 Dec 2013 20:03:12 +0000 (UTC)
Message-ID: <loom.20131202T202014-656@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I'm quite stuck and am hoping I can find some guidance.  I have N PIDs
carrying MPE multicast packets that have been exposed via dvb0_N interfaces.
 It does not appear that multiple PIDs can be assigned to a single DVB
network interface via V4L/DVB API.

My goal is to have all packets (in general, multicast or not) arrive on a
single interface (i.e. sat0).  That is, a tcpdump -i sat0 will show dvb0_1,
dvb0_2, ... , dvb0_N packets.

Statically routing (smcroute) does work but, the multicast group address
isn't generally known or joined via this process.  The other process is
pre-existing software that knowns nothing of dvb0_N interfaces too.

Bridging the dvb0_N interfaces doesn't show the multicast packets on the
bridge interface (i.e. br0 via bridge-utils).  I had thought this would be
the solution.

Routing all multicast packets via route/iptables didn't seem to work either.
 From what what I gather multicast packets can't be routed 'normally'.

I have attempted some with a dynamic multicast router such as mrouted
without success.  Chance this is my limited experience in this domain, I
don't fully grasp the necessities with IGMP and such.

So, I think the question is, what would be the method you'd choose to
combine packets received from dvb0_N interfaces into a single interface? 
Can this be done multicast agnostic?  Without static routing?

Cheers,
 Alex

