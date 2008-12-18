Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1LDL7D-0003DH-9m
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 16:48:43 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0KC200JPMX856WF1@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 18 Dec 2008 10:48:08 -0500 (EST)
Date: Thu, 18 Dec 2008 10:48:05 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <49293640.10808@cadsoft.de>
To: linux-dvb@linuxtv.org
Message-id: <494A70B5.6050500@linuxtv.org>
MIME-version: 1.0
References: <49293640.10808@cadsoft.de>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

Klaus Schmidinger wrote:
> The attached patch adds a capability flag that allows an application
> to determine whether a particular device can handle "second generation
> modulation" transponders. This is necessary in order for applications
> to be able to decide which device to use for a given channel in
> a multi device environment, where DVB-S and DVB-S2 devices are mixed.
> 
> It is assumed that a device capable of handling "second generation
> modulation" can implicitly handle "first generation modulation".
> The flag is not named anything with DVBS2 in order to allow its
> use with future DVBT2 devices as well (should they ever come).
> 
> Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>

This looks good.

Acked-By: Steven Toth <stoth@linuxtv.org>

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
