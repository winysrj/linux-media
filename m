Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K6O7V-0008D7-2d
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 13:04:04 +0200
Received: from [192.168.1.2] (01-157.155.popsite.net [66.217.131.157])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m5BB3sA3000897
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 07:03:55 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <139261.21368.qm@web55108.mail.re4.yahoo.com>
References: <139261.21368.qm@web55108.mail.re4.yahoo.com>
Date: Wed, 11 Jun 2008 07:03:28 -0400
Message-Id: <1213182208.3158.13.camel@palomino.walls.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] symbol rate and signal level
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

On Tue, 2008-06-10 at 23:24 -0700, alireza ghahremanian wrote:
> Dear friends 
> 
> What is the relation between symbol rate and signal level, why when decrease the symbol rate the signal level increase ?
> 

S/N = Es/No * Rs/B

S = Received signal power (Watts)
N = Noise power (Watts)

Es = Average energy per symbol (Joules/symbol)
No = Noise density (Watts/Hz)

Rs = Symbol rate (Symbols/second)
B  = Bandwidth (Hz)


For a particular BER, the receiver will require a certain Es/No.  If S
goes down, then Rs must go down (or B must go up) as well to maintain
the same Es/No and hence the same BER.


So in the case of lowering Rs and holding S/N the same, you are
operating at a higher Es/No which means a lower BER.


-Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
