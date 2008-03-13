Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eir.is.scarlet.be ([193.74.71.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JZlAn-0001k4-Ja
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 12:00:34 +0100
Received: from fry (ip-81-11-185-209.dsl.scarlet.be [81.11.185.209])
	by eir.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m2DB0R8g018923
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 12:00:28 +0100
From: "Ben Backx" <ben@bbackx.com>
To: <linux-dvb@linuxtv.org>
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
	<21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
	<20080313062848.GC17780@tkukoulu.fi>
In-Reply-To: <20080313062848.GC17780@tkukoulu.fi>
Date: Thu, 13 Mar 2008 12:00:19 +0100
Message-ID: <004401c884f9$6e37c150$4aa743f0$@com>
MIME-Version: 1.0
Content-Language: en-gb
Subject: Re: [linux-dvb] Implementing support for multi-channel
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


> -----Original Message-----
> From: Tero Pelander [mailto:tpeland@tkukoulu.fi]
> Sent: 13 March 2008 07:29
> To: Ben Backx
> Subject: Re: [linux-dvb] Implementing support for multi-channel
> 
> On Wed, Mar 12, 2008 at 12:19:58PM -0000, Stephen Rowles wrote:
> >> I was wondering if there's some info to find on how to implement
> (and
> >> test) multi-channel receiving?
> 
> One such program that is easy to understand due to modularity is
> dvbyell. It has separate code for tuner part and separate code for
> splitting MPTS (multiple program transport stream) into many single
> program transport streams.
> 
> http://www.dvbyell.org/


Thank you everybody for the answers so far, I do have enough software-based
solutions to start testing.
However, there's still the question: can filtering be done in the driver?
Are there any drivers that support this or which dvb-api-functions need to
be implemented?

Regards,
Ben


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
