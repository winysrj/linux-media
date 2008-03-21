Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Jceik-0006lo-27
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 11:43:36 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Jcejd-00053C-RC
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 13:44:29 +0300
Date: Fri, 21 Mar 2008 13:44:29 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <47E2CF49.8070302@t-online.de>
Message-ID: <Pine.LNX.4.62.0803211340200.19123@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
	<200803200118.26462@orion.escape-edv.de>
	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
	<47E2CF49.8070302@t-online.de>
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

On Thu, 20 Mar 2008, Hartmut Hackmann wrote:

>> buf[6] = 0xfe;
>> solves the problem.
>> Maybe, I'll check other values.
> This might be right! I could not get good information regarding the
> transponder bandwidths. We might need to make this depend on the
> symbol rate or a module parameter.
> Can we grind this out after easter?
Yes!
would be good to have automatic update, depending on rate, but module 
param... or, maybe, better, over ioctl, to make it possible to switch 
transponders without computer reboot?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
