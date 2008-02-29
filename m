Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33105.mail.mud.yahoo.com ([209.191.69.135])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JVEjD-0005Rg-CD
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 00:33:23 +0100
Date: Fri, 29 Feb 2008 15:32:37 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Message-ID: <919719.6255.qm@web33105.mail.mud.yahoo.com>
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

I am using VP-1041 with the lnb21_attach changes to the ISEL and PCL bit settings.
At the moemnt I have no clue why I am having this diseqc issue. I also checked the
logs and I see from time to time diseqc_fifo_full messages but there is no correlation
with the problem. For example I have not seen these messages for the last two days
but sending more than 2 diseqc messages re-programs my rotor.

----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: Simeon Simeonov <simeonov_2000@yahoo.com>
Cc: linux-dvb@linuxtv.org
Sent: Friday, February 29, 2008 3:20:39 PM
Subject: Re: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping

Simeon Simeonov wrote:
> With 72e81184fb9f I get lock  5/10 times of the times and with a9ecd19a37c9 9/10 times.
> But with 72e81184fb9f I couldn't get neither my rotor nor diseqc switch to work as 
> opposed to the tip where both work with some problems - sending more than
> 2 diseqc messages messes up my rotor.

You are using the Technisat HD2 or the VP-1041 ? if you are using the HD2,
changeset 7280 alone adds support for the HD2, so in this case you will
need to manually add support for the same.

In either of the case, i guess you have some sort of diseqc issue, but then
have you tried with the LNBP21 attach change ?


Regards,
Manu


> ----- Original Message ----
> From: Manu Abraham <abraham.manu@gmail.com>
> To: Simeon Simeonov <simeonov_2000@yahoo.com>
> Cc: linux-dvb@linuxtv.org
> Sent: Thursday, February 28, 2008 1:29:55 AM
> Subject: Re: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping
> 
> Simeon Simeonov wrote:
>> I don't know if is the same but with the latest mantis tree I get 100% success.
>> Reverting to changeset mantis-100d4b009238 (which I think corresponds to multiproto 7200)
>> I do NOT any locks on the same transponder.
> 
> For the mantis tree, please test this changeset: 7275    72e81184fb9f as head
> Please test how that looks in comparison to tip changeset 7282    a9ecd19a37c9
> 
> Regards,
> Manu
> 
> 
> 
> 
> 
>       ____________________________________________________________________________________
> Looking for last minute shopping deals?  
> Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
> 






      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
