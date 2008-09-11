Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdmDG-0004aF-FH
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 15:27:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7100ILO9DGZEX0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 11 Sep 2008 09:27:16 -0400 (EDT)
Date: Thu, 11 Sep 2008 09:27:15 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <alpine.LRH.1.10.0809101111130.30794@pub2.ifh.de>
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48C91CB3.50608@linuxtv.org>
MIME-version: 1.0
References: <48C72F99.20501@linuxtv.org>
	<alpine.LRH.1.10.0809101111130.30794@pub2.ifh.de>
Subject: Re: [linux-dvb] S2API - Code review and suggested changes (1)
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

Patrick Boettcher wrote:
> Hi Steve,
> 
> On Tue, 9 Sep 2008, Steven Toth wrote:
>> * I think it would be better to change TV_ to FE_ (because TV is by
>> * far not
>> * the only application for linux-dvb) , but this is a very unimportant
>> * detail.
>>
>> A few people prefer dtv_ and DTV_, rather than tv_ and TV_. is fe_
>> and FE_ still important to you?
> 
> Expanding the term "dtv" to digital television and then translate 
> television into "seeing something somewhere which takes/took place 
> somewhere else" I can agree with the dtv-prefix.
> 
> Still I think the term TV is used by a lot of people with different 
> understandings. But except me nobody has seen the term dtv too 
> restrictive, so I'm joining the majority.
> 
> On thing I almost forgot: You should add a bandwidth-thing as an 
> integer, like the frequency/symbolrate.
> 
> For DVB-T we (DiBcom) can basicly run with any channel bandwidth, not 
> only 5,6,7,8 MHz. And some people are even using it...
> 
> Another example: DVB-SH is mentioning explicitly a 1.7 MHz bandwidth in 
> the spec (default is 5MHz).
> 
> Please consider adapting it.

I've added this to the list.

Thanks,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
