Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JZpk9-0005Th-Qj
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 16:53:22 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JXO00C1YERZPN10@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 13 Mar 2008 11:52:47 -0400 (EDT)
Date: Thu, 13 Mar 2008 11:52:46 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <002201c884c7$620c22e0$0a00a8c0@vorg>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Message-id: <47D94DCE.4090109@linuxtv.org>
MIME-version: 1.0
References: <002201c884c7$620c22e0$0a00a8c0@vorg>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with lspci and PCIe slots - HVR-1800 not
	seen
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

Timothy D. Lenz wrote:
> I just put my new HVR-1800 in and restarted and found lspci dosen't see it.
> I have not redone drivers yet. They are still built only for the Nexus. I
> have searched all the logs for ref to the chip used, but nothing. Google
> came back with a lot of people having problems with lspci and PCIe cards.
> Some mis-named, some not showing at all.
> 
> Going ahead with trying to build multiproto drivers and se what happens....

lspci always shows the HVR1800 and other PCIe cards for me.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
