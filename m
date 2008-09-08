Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kcj85-0001rF-Su
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 17:58:18 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6V004I1WC2U5X0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 08 Sep 2008 11:57:38 -0400 (EDT)
Date: Mon, 08 Sep 2008 11:57:37 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C42851.8070005@koala.ie>
To: Simon Kenyon <simon@koala.ie>
Message-id: <48C54B71.4020408@linuxtv.org>
MIME-version: 1.0
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <20080904204709.GA32329@linuxtv.org>
	<d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
	<48C1380F.7050705@linuxtv.org> <48C42851.8070005@koala.ie>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Simon Kenyon wrote:
> Steven Toth wrote:
>> A big difference between can and will, the em28xx fiasco tells us this.
>>   
> just wondering if your tree will go any way towards resolving that 
> little problem?

I have enough in the API now to tune some experimental ISDB-T products 
we have in the lab. That code is already in the the tune.c for anyone to 
view.

Like everything, it will evolve over time but the code is available now 
for you to view in tune.c

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
