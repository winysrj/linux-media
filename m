Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KYLgb-0003Yf-3r
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 16:07:50 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K69004VAJ7WM230@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Aug 2008 10:07:14 -0400 (EDT)
Date: Wed, 27 Aug 2008 10:07:09 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <003201c9082d$4b7fff80$e27ffe80$@com.au>
To: Thomas Goerke <tom@goeng.com.au>
Message-id: <48B55F8D.9090005@linuxtv.org>
MIME-version: 1.0
References: <20080827061320.298E2104F0@ws1-3.us4.outblaze.com>
	<003201c9082d$4b7fff80$e27ffe80$@com.au>
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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

> 
> 
> Stephen,
> 
> I managed to install a copy of D-scaler (v4.1.11) which contained regspy
> from http://www.dscaler.org/downloads.htm, but was unable to get regspy nor
> d-scaler to recognize the Compro E800 card.  Thus I have been unable to get
> the register dump you requested.  I can try again if you think that regspy
> can be made to work with the card and any suggestions here would be
> appreciated.

http://steventoth.net/ReverseEngineering/PCI/

This was the version I originally added cx23885/7/8 support to.

It assumes dscaler is installed.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
