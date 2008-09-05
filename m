Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbbQp-0002Cu-Ux
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 15:33:01 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Q00I8N5M1UWU0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 05 Sep 2008 09:32:26 -0400 (EDT)
Date: Fri, 05 Sep 2008 09:32:25 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <29147.65816.qm@web38804.mail.mud.yahoo.com>
To: borisstevenson@yahoo.com
Message-id: <48C134E9.7010503@linuxtv.org>
MIME-version: 1.0
References: <29147.65816.qm@web38804.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSS Support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

boris stevenson wrote:
> One option that is missing in your new api is DSS support. Manu's 
> multiprotocol currently supports DSS (DTV) mode and is a requirement for 
> quite a few people. My vote is to approve any approach that 
> automatically suppots DSS mode.
> 
> 

That's interesting, because I've previously thought that the kernel 
demux didn't understand 144 (?) byte packets.

Does this actually work, and are the regular DVB tools giving you 144 
transport packets? Which applications do you use for analysis and/or 
playback?

The HVR4000 silicon supports DSS but I've never enabled it, if the 
applications and kernel support are maturing then I'll certainly do 
this. Why not, right?

Let me know.

Regards,

Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
