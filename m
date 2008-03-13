Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlenz@vorgon.com>) id 1JZfZy-0000dC-NC
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 06:02:12 +0100
Message-ID: <002201c884c7$620c22e0$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 12 Mar 2008 22:02:00 -0700
MIME-Version: 1.0
Subject: [linux-dvb] Problem with lspci and PCIe slots - HVR-1800 not seen
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

I just put my new HVR-1800 in and restarted and found lspci dosen't see it.
I have not redone drivers yet. They are still built only for the Nexus. I
have searched all the logs for ref to the chip used, but nothing. Google
came back with a lot of people having problems with lspci and PCIe cards.
Some mis-named, some not showing at all.

Going ahead with trying to build multiproto drivers and se what happens....


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
