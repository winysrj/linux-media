Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Jdrrk-0002rs-8y
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 19:57:56 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JdrsP-0002n7-14
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 21:58:35 +0300
Date: Mon, 24 Mar 2008 21:58:33 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <002e01c88ddd$1d9ff450$58dfdcf0$@com>
Message-ID: <Pine.LNX.4.62.0803242147460.3556@ns.bog.msu.ru>
References: <47D99FE8.80903@googlemail.com>
	<001801c88d9c$903339f0$b099add0$@com>
	<47E7B2DB.3050009@googlemail.com> <002e01c88ddd$1d9ff450$58dfdcf0$@com>
MIME-Version: 1.0
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



On Mon, 24 Mar 2008, Ben Backx wrote:

> The hardware can handle it (up to a certain number of PID-filters).
For Skystar3 it is 255.

> The main
> difference: cpu-load. When the hardware handles the filtering, the cpu can
> be busy with other stuff... (at least, that's what I think).
Seems, that today's CPUs are capable of doing full TS decoding without any 
significant CPU load (for 68Mbit stream with 20 channels it is less than 
5% 3GHz CPU). More, sw. decoder is not a small atomic thing, and can do 
many additional things. If the PID filter is in the kernel in such case, 
there is a chance, that we've get additional memcpy() etc.

> The (performance) difference between driver and software will be little, I
> expect.
More, we can miss CPU power and increase kernel size.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
