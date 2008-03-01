Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33106.mail.mud.yahoo.com ([209.191.69.136])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JVF9t-0007cA-Vk
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 01:00:58 +0100
Date: Fri, 29 Feb 2008 16:00:23 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Message-ID: <315532.95101.qm@web33106.mail.mud.yahoo.com>
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

Yes, ocasionally I see the message from stb0899_wait_diseqc_fifo_empty() 
but trying to increase the time in the call did not help. So I am not sure if
my problem is related to that message.
 
----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: Simeon Simeonov <simeonov_2000@yahoo.com>
Cc: linux-dvb@linuxtv.org
Sent: Friday, February 29, 2008 3:40:05 PM
Subject: Re: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping

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





      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
