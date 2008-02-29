Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33103.mail.mud.yahoo.com ([209.191.69.133])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JUycd-0007R5-J1
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 07:21:31 +0100
Date: Thu, 28 Feb 2008 22:20:46 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Message-ID: <42116.91911.qm@web33103.mail.mud.yahoo.com>
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

With 72e81184fb9f I get lock  5/10 times of the times and with a9ecd19a37c9 9/10 times.
But with 72e81184fb9f I couldn't get neither my rotor nor diseqc switch to work as 
opposed to the tip where both work with some problems - sending more than
2 diseqc messages messes up my rotor.

----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: Simeon Simeonov <simeonov_2000@yahoo.com>
Cc: linux-dvb@linuxtv.org
Sent: Thursday, February 28, 2008 1:29:55 AM
Subject: Re: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping

Simeon Simeonov wrote:
> I don't know if is the same but with the latest mantis tree I get 100% success.
> Reverting to changeset mantis-100d4b009238 (which I think corresponds to multiproto 7200)
> I do NOT any locks on the same transponder.

For the mantis tree, please test this changeset: 7275    72e81184fb9f as head
Please test how that looks in comparison to tip changeset 7282    a9ecd19a37c9

Regards,
Manu





      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
