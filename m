Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KgZwX-00028G-Hl
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 08:58:19 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7F005YFKO64DA1@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 19 Sep 2008 02:57:43 -0400 (EDT)
Date: Fri, 19 Sep 2008 02:57:42 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
To: Thierry Merle <thierry.merle@free.fr>
Message-id: <48D34D66.7000200@linuxtv.org>
MIME-version: 1.0
References: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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
> Hi Thierry,
> 
> On Fri, 19 Sep 2008, Thierry Merle wrote:
> 
>> Hello all,
>> About the rework from Tomi Orava I stored here:
>> http://linuxtv.org/hg/~tmerle/cinergyT2
>>
>> since there seems to be no bug declared with this driver by testers (I
>> tested this driver on AMD/Intel/ARM platforms for months), it is time for
>> action.
>> If I receive no problem report before 19th of October (in one month), I
>> will push this driver into mainline.
> 
> Are you really sure you want to wait until October 19 with that? You heard 
> Jonathan this morning, he is expecting a new release every day now, so the 
> merge window will start quite soon. Maybe it would be better to shorten 
> your deadline in favour of having the driver in-tree for 2.6.28. When it 
> is inside it is still possible for at least 1.5 months to fix occuring 
> problems.

Agreed, shorten and aim for 2.6.28 - especially if you've already done a 
significant amount of personal testing.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
