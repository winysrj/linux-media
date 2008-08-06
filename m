Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQY5X-00044X-Mm
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 03:45:21 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5500H0JOUK6B11@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 05 Aug 2008 21:44:45 -0400 (EDT)
Date: Tue, 05 Aug 2008 21:44:44 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080805234129.GD11008@brainz.yelavich.home>
To: Luke Yelavich <themuso@themuso.com>
Message-id: <4899020C.50000@linuxtv.org>
MIME-version: 1.0
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
	<4897AC24.3040006@linuxtv.org> <20080805214339.GA7314@kryten>
	<20080805234129.GD11008@brainz.yelavich.home>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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


>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy with the  
>>> results. Can you both try the DViCO board?
>> It tests fine and I like how simpler things have got.
> 
> I pulled the above linked tree, and compiled the modules. It seems at the moment for the dual express, that I have to pass the parameter card=11 to the driver, for it to correctly find the card and make use of all adapters. Without any module parameters, dmsg complains that the card couldn't be identified, yet two adapters are shown. I have two of these cards.
> 
> Hope this helps some.

.. And they're both the same model?

If so, insert one at a time and run the 'lspci -vn' command, save the 
output for each card.

Post the output here.

Assuming you load the driver with card=11, does each card work correctly 
after that?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
