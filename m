Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1L9k86-0007qb-6e
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 18:42:47 +0100
Date: Mon, 8 Dec 2008 18:42:08 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Boyan <btanastasov@yahoo.co.uk>
In-Reply-To: <49005E1C.3010104@yahoo.co.uk>
Message-ID: <alpine.LRH.1.10.0812081838450.19364@pub4.ifh.de>
References: <49005E1C.3010104@yahoo.co.uk>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [REGRESSION] - Cable2PC/CableStar 2 DVB-C not
 detected
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



On Thu, 23 Oct 2008, Boyan wrote:
> There is a regression regarding this DVB-C card from the subject, which
> as it looks is not very new, but nobody noticed the problem.
> After bisecting I've found the commit which is responsible for this
> problem - that the card is not detected.
> By the way mercurial bisect was not very useful because some commits
> does not compile or load, so I had to "simulate" bisecting.

Hi Boyan,

did you try the latest hg from linuxtv.org recently?

A patch was provided fixing the cablestar support.

Can you please try it ?

regards,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
