Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sif.is.scarlet.be ([193.74.71.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JrugP-0007Xw-9f
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 14:48:57 +0200
Received: from fry (ip-81-11-162-157.dsl.scarlet.be [81.11.162.157])
	by sif.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m42CklAW027736
	for <linux-dvb@linuxtv.org>; Fri, 2 May 2008 14:46:48 +0200
From: "Ben Backx" <ben@bbackx.com>
To: <linux-dvb@linuxtv.org>
References: <38846.203.200.233.131.1209733086.squirrel@203.200.233.138>
In-Reply-To: <38846.203.200.233.131.1209733086.squirrel@203.200.233.138>
Date: Fri, 2 May 2008 14:46:37 +0200
Message-ID: <001f01c8ac52$8fc92900$af5b7b00$@com>
MIME-Version: 1.0
Content-Language: en-gb
Subject: Re: [linux-dvb] pes to ts conversion
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

Shouldn't you do it the other way around?
There are different PES in one TS, so it's breaking up the TS into PES...
Or combine PES into one TS...
I'm currently working on a program to split the TS into different PES, if
you're interested, I'll publish the code.


Regards,
Ben

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-
> bounces@linuxtv.org] On Behalf Of Gurumurti Laxman Maharana
> Sent: 02 May 2008 14:58
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] pes to ts conversion
> 
> Hi All
> I want to know the steps to convert the PES stream to TS.
> basically to break PES into TS.
> Can any body help inthis regard or siggest any document or site.
> thanks with regards.
> --
> guru
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
