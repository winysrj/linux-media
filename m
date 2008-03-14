Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JaBkx-0005BZ-6V
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 16:23:41 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JaBmA-0003If-W9
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 18:24:57 +0300
Date: Fri, 14 Mar 2008 18:24:54 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <31748235-0C9E-4847-93E1-71B39029E718@krastelcom.ru>
Message-ID: <Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<04AD1EEA-DF6C-4575-8A8B-D460F199288F@krastelcom.ru>
	<Pine.LNX.4.62.0803141736520.8859@ns.bog.msu.ru>
	<31748235-0C9E-4847-93E1-71B39029E718@krastelcom.ru>
MIME-Version: 1.0
Subject: Re: [linux-dvb] TT budget S-1401 Horizontal transponder fails
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



On Fri, 14 Mar 2008, Vladimir Prudnikov wrote:

> How does it work with Orion if it doesn't have a CI?
>>> What TT card have you got?
>>> I'm unable to lock to any of Orion Express transponders with TT S2-3200.
>> I have GI-SS3 (TT budget S-1401)
There are several free channels to view. Also, I have STB with irdeto 
card. Errors in the cahnnel were detected visually first.
But it is possible to detect the problem with the stream directly: one can 
get the full TS from the card, and get statistics for BER (shown in my 
first message).

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
