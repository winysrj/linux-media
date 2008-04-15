Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JlleN-0001AK-Qm
	for linux-dvb@linuxtv.org; Tue, 15 Apr 2008 15:56:50 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZD00A2GDDFFP90@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 15 Apr 2008 09:56:04 -0400 (EDT)
Date: Tue, 15 Apr 2008 09:56:02 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <37824.1208252766@iinet.net.au>
To: sonofzev@iinet.net.au
Message-id: <4804B3F2.60004@linuxtv.org>
MIME-version: 1.0
References: <37824.1208252766@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing to
 help test e.t.c...
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

sonofzev@iinet.net.au wrote:
> Hi Folks
> 
> I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as a 
> result of misreading some other posts and sites. I was under the 
> impression that it would work either from the current kernel source or 
> using Chris Pascoe's modules.  Unfortunately I didn't realise that the 
> American and Euro/Australian version were different.

I'm pretty sure the major lifting is already done in the cx23885 tree, 
I've already done this for another design. Assuming support doesn't 
already exist, then it's probably just a matter of defining the new PCIe 
ID', defining the card etc, attach structs, serial/parallel etc.

Get me a login to a remote dev system with the board installed (and 
working antenna feeds) then I should be able to get this done for you.

You can mail me privately with any details.

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
