Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JceuM-0008It-9T
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 11:55:34 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JcevG-0005Am-4F
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 13:56:30 +0300
Date: Fri, 21 Mar 2008 13:56:30 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <200803210956.03053@orion.escape-edv.de>
Message-ID: <Pine.LNX.4.62.0803211354320.19123@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803200118.26462@orion.escape-edv.de>
	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
	<200803210956.03053@orion.escape-edv.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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



On Fri, 21 Mar 2008, Oliver Endriss wrote:

>> solves the problem.
>> Maybe, I'll check other values.
>
> Hm - buf[6] is not the baseband cut-off.
> I guess you changed buf[5] back to 0xff, correct?
ah! sorry!
//      buf[5] = 0x77; // baseband cut-off 19 MHz
         buf[5] = 0xf1; // new: baseband cut-off ?MHz
         buf[6] = 0xfe; // baseband gain 9 db + no RF attenuation

> Could you please find out the _minimum_ value required?
> You might try 0xff, 0xf7, 0xef, 0xe7, 0xdf, 0xd7, 0xcf, 0xc7 and so on.
> The symbol rate of the transponder is 44948000, right?
yes.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
