Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33103.mail.mud.yahoo.com ([209.191.69.133])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JUZyP-0003vr-RS
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 05:02:22 +0100
Date: Wed, 27 Feb 2008 20:01:30 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>, linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <803523.78624.qm@web33103.mail.mud.yahoo.com>
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

I don't know if is the same but with the latest mantis tree I get 100% success.
Reverting to changeset mantis-100d4b009238 (which I think corresponds to multiproto 7200)
I do NOT any locks on the same transponder.

----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-dvb@linuxtv.org
Sent: Tuesday, February 26, 2008 1:44:37 PM
Subject: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping

Vangelis Nonas wrote:
> Hello,
> 
> Here is the output of hg log|head -n 5 for two different directories 
> (multiproto and multiproto_7200)
> 
> for multiproto:
> changeset:   7205:9bdb997e38b5
> tag:         tip
> user:        Manu Abraham <manu@linuxtv.org>
> date:        Sun Feb 24 02:10:56 2008 +0400
> summary:     We can now reduce the debug levels, just need to look at 
> errors only.
> 
> for multiproto_7200:
> changeset:   7200:45eec532cefa
> tag:         tip
> parent:      7095:a577a5dbc93d
> parent:      7199:0448e5a6d8a6
> user:        Manu Abraham <manu@linuxtv.org>
> 
> 
> So I guess I was referring to 7200 and not to 7201.
> I am very positive about the results because I have tested it many 
> times. It is just that it is 7200 instead of 7201.
> So as a concluesion, 7200 behaves better than 7205. My corrected little 
> table follows below just for clarification.


Ok, fine this is very much possible. Can other STB0899 users (all of them)
verify this result, such that i can revert back the changes ?


> 
> Changeset   Verbose  channels
> --------------------------------
> 7200         1        2152
> 7200         2        2105
> 7200         5        2081
> 7205         1        1760
> 7205         2        1608
> 7205         5        1578
> 
> 
> I apologise for the confusion, I may have caused.

No worries, don't apologise, this is all a part of the testing phase.


Thanks,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb





      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
