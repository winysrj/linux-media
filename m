Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdDEh-00086A-Dr
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 02:07:08 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Y00136DMWZ340@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 09 Sep 2008 20:06:33 -0400 (EDT)
Date: Tue, 09 Sep 2008 20:06:32 -0400
From: Steven Toth <stoth@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48C70F88.4050701@linuxtv.org>
MIME-version: 1.0
Subject: [linux-dvb] S2API - More updates
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

Hi,

I merged patches from Igor today, so the S2API tree has five S2 devices 
in total.

HVR4000 S/S2 card
HVR4000LITE (Also known as the S2 Lite) S/S2 card
TeVii S460 S/S2 card
TeVii S650 S2 card
DvbWorld DVB-S/S2 USB2.0 S/S2

I also have some changes I'd like to merge from Darron Broad over the 
next few days, specifically for the CX24116 demod.

In terms of the core API suggestions, I'm going to rationalize the 
comments and feedback tonight and tomorrow so you should start to see 
some discussion being generated.

... and hopefully some of the smaller patches this evening also over the 
next 48hrs.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
