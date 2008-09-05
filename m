Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbbDi-0000Ov-Ts
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 15:19:29 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Q00IRS4ZAV2R0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 05 Sep 2008 09:18:47 -0400 (EDT)
Date: Fri, 05 Sep 2008 09:18:46 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080904160756.146270@gmx.net>
To: Hans Werner <HWerner4@gmx.de>
Message-id: <48C131B6.60006@linuxtv.org>
MIME-version: 1.0
References: <48BF6A09.3020205@linuxtv.org> <20080904160756.146270@gmx.net>
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

Hans Werner wrote:
>> Hello,
>>
>> It's been a crazy few days, please forgive my short absence.
>>
>> What have I been doing? Well, rather than spending time discussing a new 
>> S2API on the mailing list, I wanted to actually produce a working series 
>> of patches that kernel and application developers could begin to test.
>>
> 
> Great, that's good to hear :) .
> 
>> In addition, here's is a userland application that demonstrates tuning 
>> the current DVB-S/T/C and US ATSC modulations types using the new API. 
>> (www.steventoth.net/linux/s2/tune-v0.0.1.tgz)
>>
>> A tuning demo app? What? Obviously, tuning older modulation types via 
>> the new API isn't a requirements, but it's a useful validation exercise 
>> for the new S2API. What _IS_ important is..... that it also demonstrates 
>> using the same tuning mechanism to tune DVB-S2 8PSK / NBC-QPSK 
>> modulation types, and also has rudimentary ISDB-T support for any 
>> developers specifically interested.
>>
>> This S2API tree also contains support for the cx24116 demodulator 
>> driver, and the Hauppauge HVR4000 family of S2 products. So those 
>> interested testers/developers can modify the tune.c app demo and make 
>> changes specific to their area, and try experimenting with the new API 
>> if they desire. [1]
> 
> Even better!
>  
>> Obviously, tune.c isn't intelligent, it's not a replacement for szap, 
>> tzap or whatever - it's simply a standalone S2API test tool, that 
>> demonstrates the important API interface.
> 
>> If anyone is willing to pull the tree and begin testing with the tune.c 
>> app then please post all feedback on this thread. [2]
> 
> I will test it with the HVR4000.
> 
> Looking at the code in dvb_frontend.c I think TV_SET_TONE and TV_SET_VOLTAGE don't do
> anything. Or am I missing something?

My bad.

Pull again from ~stoth/s2, I fixed this last night and tested with a 
generator.

DVB-S is working fine. 8PSK and NBC-QPSK would also work - assuming you 
have the right tuning params (pilot etc).

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
