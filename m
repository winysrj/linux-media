Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kesq1-000265-6a
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 16:44:34 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K76007FRWXAIB50@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:43:59 -0400 (EDT)
Date: Sun, 14 Sep 2008 10:43:58 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809141354.52902.liplianin@tut.by>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-id: <48CD232E.3060005@linuxtv.org>
MIME-version: 1.0
References: <48C70F88.4050701@linuxtv.org> <48CC3D67.8060204@linuxtv.org>
	<20071.1221355165@kewl.org> <200809141354.52902.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] S2API History update: MPEG initialization
 in cx24116.
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

Igor M. Liplianin wrote:
> Hi,
> 
> History update: MPEG initialization in cx24116.
> 
> Adjust MPEG initialization in cx24116 in order to accomodate different
> MPEG CLK position and polarity in different cards. For example, HVR4000
> uses 0x02 value, but DvbWorld & TeVii USB cards uses 0x01. Without it MPEG
> stream was broken on that cards for symbol rates > 30000 kSyms/s.
> 
> 
> Igor
> 

Merged, thanks.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
