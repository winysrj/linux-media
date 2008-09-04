Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbF5C-0001cH-SV
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 15:41:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6O001W5BBFOS80@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 04 Sep 2008 09:40:28 -0400 (EDT)
Date: Thu, 04 Sep 2008 09:40:27 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48BFBE68.7070707@beardandsandals.co.uk>
To: Roger James <roger@beardandsandals.co.uk>
Message-id: <48BFE54B.2080405@linuxtv.org>
MIME-version: 1.0
References: <48BF6A09.3020205@linuxtv.org>
	<48BFBE68.7070707@beardandsandals.co.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - First release
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

Roger James wrote:
> Steven Toth wrote:
>> A tuning demo app? What? Obviously, tuning older modulation types via 
>> the new API isn't a requirements, but it's a useful validation exercise 
>> for the new S2API.
> Steven,
> 
> Your statement about tuning older modulation types not being a 
> requirement worries me. I would have thought it was an important 
> requirement from an application perspective to be able to tune old and 
> new modulation types through one api. The services I use (BSkyB and 
> Freesat) are mostly DVB-S with very little if any S2. But I would like 
> to be able to tune them via my (not so) new S2 card. Maybe I have 
> misinterpreted what you meant.

Late night, odd choice of words.

The new API is capable of tuning the old and new products. For 
application developers it's not mandatory to move all of your tuning 
code to the new API just to support all of your current DVB products.

The S2 API support is written to support every current and new DVB card 
we're likely to see over the next 10 years, it's flexible... I'm simply 
saying that application developers can slowly migrate their code to it 
... you don't have to move all of your tuning code to the new API in one go.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
