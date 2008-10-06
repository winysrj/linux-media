Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KmvzO-0001ul-Ic
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 21:43:31 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8C00LGP1FIW4G0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 06 Oct 2008 15:42:56 -0400 (EDT)
Date: Mon, 06 Oct 2008 15:42:53 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20081004183442.GM28168@braindead1.acher>
To: Georg Acher <acher@in.tum.de>, linux-dvb@linuxtv.org
Message-id: <48EA6A3D.7050604@linuxtv.org>
MIME-version: 1.0
References: <20081004204740.571e84d9@bk.ru>
	<20081004183442.GM28168@braindead1.acher>
Subject: Re: [linux-dvb] cx24116 & BER for dvb-s2
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

Georg Acher wrote:
> On Sat, Oct 04, 2008 at 08:47:40PM +0400, Goga777 wrote:
>> 	Hi
>>
>> my old questions :)
>>
>> Is it possible to implement the BER's support in cx24116 for dvb-s2 ?
> 
> The data sheet only mentions the registers c6-c9 for that purpose
> "Reed-Solomon or BCH Corrected Bit Error Count (NBC, DVB-S, or DTV Legacy)".
> There is a possibility to increase the integration window, but the contents
> are still mostly 0 in S2-modes, even when UNC is !=0. Unfortunately, the
> data sheet and the sample code also are not very clear or consistent at
> dealing with the BER counter...
> 

Georg,

How is the integration window adjusted? What bits have to be set and 
what behavior do they implement?

If you could tell me this then I'll implement it in the driver.

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
