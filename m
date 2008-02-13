Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail34.syd.optusnet.com.au ([211.29.133.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <russell@kliese.wattle.id.au>) id 1JPIQj-0000Lh-2k
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 15:17:45 +0100
Received: from [192.168.0.4] (c220-239-70-96.rochd3.qld.optusnet.com.au
	[220.239.70.96]) (authenticated sender russell.kliese)
	by mail34.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m1DEHciY021048
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 01:17:39 +1100
Message-ID: <47B2FDD7.6060701@kliese.wattle.id.au>
Date: Thu, 14 Feb 2008 00:25:27 +1000
From: Russell Kliese <russell@kliese.wattle.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Trying to solve firmware upload problem with MSI
 TV@nywhere A/D v1.1 card
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I'm interested in trying to get the MSI TV@nywhere A/D v1.1 card 
working. There is a problem with firmware uploads to the TDA10046A chip 
being unreliable. I wonder if someone could give an overview on how the 
firmware upload process works from the point of view of the driver and 
what I settings I should be looking at to try and solve the problem 
being experienced with this card?

I previously posted some details of what's happening with this card that 
are available form 
http://www.linuxtv.org/pipermail/linux-dvb/2008-February/thread.html#23574

I've cloned the mercural v4l-dvb repository and have begun setting up a 
new card entry for this card and am looking for ideas of what I could 
try to fix this unreliable firmware upload problem. Perhaps some GPIO 
ports need to be initialized before uploading firmware?

Cheers,

Russell Kliese



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
