Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVEpv-0006Ln-Nr
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 00:40:20 +0100
Message-ID: <47C897D5.70001@gmail.com>
Date: Sat, 01 Mar 2008 03:40:05 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <919719.6255.qm@web33105.mail.mud.yahoo.com>
In-Reply-To: <919719.6255.qm@web33105.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 users,
 please verify results was Re: TechniSat SkyStar HD: Problems
 scaning and zaping
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

Simeon Simeonov wrote:
> I am using VP-1041 with the lnb21_attach changes to the ISEL and PCL bit settings.
> At the moemnt I have no clue why I am having this diseqc issue. I also checked the
> logs and I see from time to time diseqc_fifo_full messages but there is no correlation
> with the problem. 

Did you mean the "timed out !!" message from 
stb0899_wait_diseqc_fifo_empty() ?
(stb0899_drv.c, line #686, Trying to understand the problem that you are 
facing)

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
