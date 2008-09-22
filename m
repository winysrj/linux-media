Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KhdZE-0005xQ-Hc
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 07:02:38 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7K00BVLZBESGM0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 22 Sep 2008 01:02:02 -0400 (EDT)
Date: Mon, 22 Sep 2008 01:02:01 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <002701c91c6b$6d310fa0$47932ee0$@net>
To: James Evans <jrevans1@earthlink.net>
Message-id: <48D726C9.3030605@linuxtv.org>
MIME-version: 1.0
References: <002001c91c65$939d8b60$bad8a220$@net>
	<48D71852.5090705@linuxtv.org> <002701c91c6b$6d310fa0$47932ee0$@net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV5 Express Support
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

James Evans wrote:
> Thank you for such a quick response.
> 
>> Debug looks OK. If you have another board where you know for certain
>> that tuning a specific 8VSB frequency works, then tuning this same
>> frequency with the LG should probably work reliably.
> 
> The installed Airstar HD5000 cards both have an LG tuner and can tune perfectly fine.

OK, pick a single frequency and focus on always tuning that for the time 
being with the Express card.

> 
>> In terms of the tuner-to-demod, are you confident that the I/F is set
>> correctly? (And inversion for that matter?)
> 
> I am not sure I understand the above question.  How would I go about setting up the interface for the tuner-to-demod?

/me checks the code and thinks it should be working fine.

Specifically, please list here the frequencies that lock reliably for 
you on 8VSB with other boards. I've seen issues in the past (mainly due 
to driver issues) where channels tables work reliably for one tuner but 
not for another.

Still, that shouldn't effect a new complete scan using the 5_EXP card, 
the channels table would be wrong if that was the case, but it would 
still lock.... unless something broke.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
