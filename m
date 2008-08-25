Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KXefb-0004eH-Ed
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 18:11:58 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K650054DZMW2O01@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 25 Aug 2008 12:11:21 -0400 (EDT)
Date: Mon, 25 Aug 2008 12:11:20 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B2C6DD.9040806@linuxtv.org>
To: Robin Perkins <robin.perkins@internode.on.net>
Message-id: <48B2D9A8.4020208@linuxtv.org>
MIME-version: 1.0
References: <E8C49B92-E40C-499D-9362-923C3A3A1F9A@internode.on.net>
	<48B2C6DD.9040806@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Reverse enginnering using i2c protocol analysers
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

Steven Toth wrote:
> Robin Perkins wrote:
>> Does anyone have any experiences using i2c logic analysers to work out 
>> how cards work ?
>> Is it an effective reverse enginering method ?
>> I was looking for them online but most of them seem pretty expensive 
>> (~$4000) however I found the Total Phase Beagle 
>> <http://www.totalphase.com/products/beagle_ism/> for about $300. Has 
>> anyone else tried this adapter out ? (It appears to have software for 
>> Linux, OS X and Windows which seems pretty good.)
> 
> A parallel port on a spare linux box, two wires and a copy of lmilk does 
> it for me. < $10.

Just for the record, it won't go above 100KHz so while it works on 
almost everything I've ever used it on ... at somepoint of someone wants 
to run their i2c bus at > 100Khz, this won't work.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
