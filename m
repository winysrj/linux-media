Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1L4Dhe-0001zE-05
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 13:04:38 +0100
Message-ID: <492946D0.1050005@linuxtv.org>
Date: Sun, 23 Nov 2008 13:04:32 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Michel Verbraak <michel@verbraak.org>
References: <4928288B.1050306@cadsoft.de> <49291E33.1050204@verbraak.org>
In-Reply-To: <49291E33.1050204@verbraak.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to determine DVB-S2 capability in S2API?
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

Michel Verbraak wrote:
> I have the same problem with diseqc version. There is no request we can 
> do to determine which version is supported by te device. This was 
> allready missing in V3 of the API.

FE_DISEQC_RECV_SLAVE_REPLY sets errno to EOPNOTSUPP if DiSEqC 2.x is
not supported by the device driver. Set slave_reply->timeout to 0 to
avoid blocking.

Have you ever seen a switch, LNB, motor or other satellite equipment
which actually provides useful data via DiSEqC 2.x?

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
