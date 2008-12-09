Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n8a.bullet.ukl.yahoo.com ([217.146.183.156])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <btanastasov@yahoo.co.uk>) id 1LA6F3-00070d-Tk
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 18:19:26 +0100
Date: Tue, 9 Dec 2008 19:18:46 +0200
From: Boyan <btanastasov@yahoo.co.uk>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Message-Id: <20081209191846.9fb5353d.btanastasov@yahoo.co.uk>
In-Reply-To: <alpine.LRH.1.10.0812081838450.19364@pub4.ifh.de>
References: <49005E1C.3010104@yahoo.co.uk>
	<alpine.LRH.1.10.0812081838450.19364@pub4.ifh.de>
Mime-Version: 1.0
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

On Mon, 8 Dec 2008 18:42:08 +0100 (CET)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:
> 
> 
> On Thu, 23 Oct 2008, Boyan wrote:
> > There is a regression regarding this DVB-C card from the subject, which
> > as it looks is not very new, but nobody noticed the problem.
> > After bisecting I've found the commit which is responsible for this
> > problem - that the card is not detected.
> > By the way mercurial bisect was not very useful because some commits
> > does not compile or load, so I had to "simulate" bisecting.
> 
> Hi Boyan,
> 
> did you try the latest hg from linuxtv.org recently?
> 
> A patch was provided fixing the cablestar support.
> 
> Can you please try it ?
> 
> regards,
> Patrick.


Hi Patrick,


Thanks for asking.
It's been long time and I've missed the fix in hg.
The card is now detected. Thanks!

Regards


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
